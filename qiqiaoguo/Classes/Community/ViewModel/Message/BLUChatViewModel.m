//
//  BLUChatViewModel.m
//  Blue
//
//  Created by Bowen on 30/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUChatViewModel.h"
#import "BLUMessageMO.h"
#import "BLUMessage.h"
#import "BLUApiManager+Message.h"
//#import "BLUGoodMO.h"

static const NSInteger kChatTimeDifference = 300;

@interface BLUChatViewModel ()

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, weak) id <NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;
@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, assign, readwrite) BLUChatViewModelState state;
@property (nonatomic, strong, readonly) BLUMessageMO *lastMessageMO;

@end

@implementation BLUChatViewModel

- (instancetype)initWithUserID:(NSInteger)userID
fetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate {
    if (self = [super init]) {
        _userID = userID;
        _fetchedResultsControllerDelegate = delegate;
        _state = BLUChatViewModelStateNormal;
        return self;
    }
    return nil;
}

- (instancetype)init {
    return nil;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination =
        [[BLUPagination alloc]
         initWithPerpage:BLUPaginationPerpageMax
         group:nil
         order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSFetchRequest *fetchRequest = [self chatFetchRequestWithContext:context];

    _fetchedResultsController =
    [BLUMessageMO MR_fetchController:fetchRequest
                            delegate:_fetchedResultsControllerDelegate
                        useFileCache:NO
                           groupedBy:nil
                           inContext:context];

    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        BLULogError(@"Error = %@", error);
        abort();
    }

    return _fetchedResultsController;
}

- (void)fetch {
    [self.fetchDisposable dispose];

    if ([BLUAppManager sharedManager].currentUser) {
        self.state = BLUChatViewModelStateFetching;
        @weakify(self);
        [[[[BLUApiManager sharedManager]
          fetchMessagesUser:self.userID
           didRead:NO
           pagination:self.pagination]
          retry:3]
         subscribeNext:^(NSArray *messages) {

             @strongify(self);
             self.state = BLUChatViewModelStateNormal;

             if (messages.count > 0) {
                 [self insertMessages:messages];
             } else {
                 NSUInteger count = [BLUMessageMO
                                     MR_countOfEntitiesWithPredicate:
                                    [self messagePredicate]];
                 if (count == 0) {
                     [[[BLUApiManager sharedManager]
                       fetchMessagesUser:self.userID
                       didRead:YES
                       pagination:self.pagination] subscribeNext:^(NSArray *messages) {
                         [self insertMessages:messages];
                     } error:^(NSError *error) {
                         self.state = BLUChatViewModelStateFetchFailed;
                     }];
                 }
             }

         } error:^(NSError *error) {
             @strongify(self);
             self.state = BLUChatViewModelStateFetchFailed;
         }];
    }
}

- (void)insertMessages:(NSArray <BLUMessage *> *)messages {
    NSInteger orderIndex = 0;
    BLUMessageMO *lastMessageMO = self.lastMessageMO;
    if (lastMessageMO) {
        orderIndex = lastMessageMO.orderIndex.integerValue + 1;
    }

    __block NSDate *lastDate;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = messages.count - 1; i >= 0; i--) {
        [arr addObject:messages[i]];
    }
    
    [arr enumerateObjectsUsingBlock:^(BLUMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        BLUMessageMO *messageMO = [BLUMessageMO MR_createEntity];
        [messageMO configMessageMOWithMessage:message];
        messageMO.orderIndex = @(orderIndex + idx);
        if (lastDate != nil) {
            NSTimeInterval 	timeInterval = [messageMO.createDate  timeIntervalSinceDate:lastDate];
            if (timeInterval > kChatTimeDifference) {
                messageMO.showSendTime = @(YES);
            } else {
                messageMO.showSendTime = @(NO);
            }
        } else {
            messageMO.showSendTime = @(NO);
        }
        lastDate = messageMO.createDate;
    }];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            BLULogInfo(@"MOC Save success!");
        } else {
            BLULogError(@"MOC save failed, error = %@", error);
        }
    }];
}

- (void)deleteAllMessages {
    [BLUMessageMO MR_deleteAllMatchingPredicate:[self messagePredicate] inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (RACSignal *)sendMessage:(NSString *)message {

    BLUMessageMO *messageMO = [BLUMessageMO MR_createEntity];

    BLUUser *fromUser = [[BLUAppManager sharedManager] currentUser];
    
    NSInteger orderIndex = 0;
    BLUMessageMO *lastMessageMO = self.lastMessageMO;
    if (lastMessageMO) {
        orderIndex = lastMessageMO.orderIndex.integerValue + 1;
    }

    NSDate *lastDate = lastMessageMO.createDate;

    messageMO.contentType = @(0);
    messageMO.text = message;
    messageMO.remoteState = @(BLUMessageMORemoteStateSending);
    messageMO.orderIndex = @(orderIndex);
    messageMO.createDate = [NSDate date];
    messageMO.imageURL = fromUser.avatar.thumbnailURL.absoluteString;
    messageMO.fromUserGender = @(fromUser.gender);
    messageMO.fromUserID = @(fromUser.userID);
    messageMO.fromUserThumbnailAvatarURL = fromUser.avatar.thumbnailURL.absoluteString;
    messageMO.fromUserNickname = fromUser.nickname;

    messageMO.toUserID = @(self.userID);

    return [[[[BLUApiManager sharedManager] sendMessageToUser:self.userID content:message type:0] doNext:^(BLUMessage *recievedMessage) {
        messageMO.messageID = @(recievedMessage.messageID);
        messageMO.createDate = recievedMessage.createDate;
        messageMO.remoteState = @(BLUMessageMORemoteStateNormal);

        if (lastDate) {
            NSTimeInterval chatInterval = [messageMO.createDate timeIntervalSinceDate:lastDate];
            if (chatInterval > kChatTimeDifference) {
                messageMO.showSendTime = @(YES);
            } else {
                messageMO.showSendTime = @(NO);
            }
        } else {
            messageMO.showSendTime = @(NO);
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            if (contextDidSave) {
                BLULogInfo(@"MOC Save success!");
            } else {
                BLULogError(@"MOC save failed, error = %@", error);
            }
        }];
        
    }] doError:^(NSError *error) {
        messageMO.remoteState = @(BLUMessageMORemoteStateSendFailed);
    }];
}

- (void)generateGoodHint:(BLUGoodMO *)goodMO {
//    BLUParameterAssert([goodMO isKindOfClass:[BLUGoodMO class]]);
    BLUMessageMO *messageMO = [BLUMessageMO MR_createEntity];
    BLUUser *fromUser = [[BLUAppManager sharedManager] currentUser];
    BLUMessageMO *lastMessageMO = [self lastMessageMO];
    NSInteger orderIndex = [self lastOrderIndexWithLastMessage:self.lastMessageMO];

    NSDate *lastDate;
    if (lastMessageMO) {
        lastDate = lastMessageMO.createDate;
    } else {
        lastDate = [NSDate date];
    }

    messageMO.contentType = @(BLUMessageTypeAdText);
    messageMO.styleType = @(BLUMessageStyleTypeGoodHint);
    messageMO.orderIndex = @(orderIndex);
    messageMO.createDate = lastDate;

    messageMO.fromUserGender = @(fromUser.gender);
    messageMO.fromUserID = @(fromUser.userID);
    messageMO.fromUserThumbnailAvatarURL =
    fromUser.avatar.thumbnailURL.absoluteString;
    messageMO.fromUserNickname = fromUser.nickname;

    messageMO.toUserID = @(self.userID);
//    messageMO.good = goodMO;
}

- (RACSignal *)sendGood:(id)goodMO {
    
    
    BLUMessageMO *messageMO = [BLUMessageMO MR_createEntity];
    BLUUser *fromUser = [[BLUAppManager sharedManager] currentUser];
    BLUMessageMO *lastMessageMO = [self lastMessageMO];
    NSInteger orderIndex = [self lastOrderIndexWithLastMessage:self.lastMessageMO];
    NSDate *lastDate = lastMessageMO.createDate;
    
    BLUMessageType messageType = BLUMessageTypeAdText;
    BLUPageRedirectionType RedirectionType = 0;
    NSInteger redirectID = 0;
    
    if ([goodMO isKindOfClass:[QGStoreDetailModel class]]) {
        QGStoreDetailModel *model = goodMO;
        messageMO.idTitle = model.item.title;
        if (model.item.seckillingInfo) {
           RedirectionType = BLUPageRedirectionTypeSeckillGood;
        }else{
            RedirectionType = BLUPageRedirectionTypeGood;
        }
        redirectID = model.item.id.integerValue;
    }else if([goodMO isKindOfClass:[QGCourseDetaiResultModel class]]){
        QGCourseDetaiResultModel *model = goodMO;
        messageMO.idTitle = model.item.title;
        RedirectionType = BLUPageRedirectionTypeCourse;
        redirectID = model.item.id.integerValue;
    }else if ([goodMO isKindOfClass:[QGEduTeacherDetailResultModel class]]){
        QGEduTeacherDetailResultModel *model = goodMO;
        messageMO.idTitle = model.item.name;
        RedirectionType = BLUPageRedirectionTypeTeacher;
        redirectID = model.item.teacher_id.integerValue;
    }else if ([goodMO isKindOfClass:[QGActlistDetailResultModel class]]){
        QGActlistDetailResultModel *model = goodMO;
        messageMO.idTitle = model.item.title;
        RedirectionType = BLUPageRedirectionTypeActiv;
        redirectID = model.item.id.integerValue;
    }else if ([goodMO isKindOfClass:[QGShopDetailsModel class]]){
        QGShopDetailsModel *model = goodMO;
        messageMO.idTitle = model.item.name;
        RedirectionType = BLUPageRedirectionTypeOrg;
        redirectID = model.item.id.integerValue;
    }

    
    NSString *content = messageMO.idTitle;
    messageMO.redirectType = @(RedirectionType);
    messageMO.redirectID = @(redirectID);
    messageMO.contentType = @(BLUMessageTypeAdText);
    messageMO.styleType = @(BLUMessageStyleTypeGoodPrompt);
    messageMO.orderIndex = @(orderIndex);
    messageMO.createDate = lastDate;

    messageMO.fromUserGender = @(fromUser.gender);
    messageMO.fromUserID = @(fromUser.userID);
    messageMO.fromUserThumbnailAvatarURL =
    fromUser.avatar.thumbnailURL.absoluteString;
    messageMO.fromUserNickname = fromUser.nickname;
    
    
    messageMO.toUserID = @(self.userID);
    messageMO.remoteState = @(BLUMessageMORemoteStateSending);

    return [[[[BLUApiManager sharedManager]
              sendMessageToUser:self.userID
              contentType:messageType
                content:content
              redirectType:RedirectionType
              redirectID:redirectID]
             doNext:^(BLUMessage *msg) {
          messageMO.messageID = @(msg.messageID);
          messageMO.createDate = msg.createDate;
          messageMO.remoteState = @(BLUMessageMORemoteStateNormal);

          if (lastDate) {
              NSTimeInterval chatInterval =
              [messageMO.createDate timeIntervalSinceDate:lastDate];
              if (chatInterval > kChatTimeDifference) {
                  messageMO.showSendTime = @(YES);
              } else {
                  messageMO.showSendTime = @(NO);
              }
          } else {
              messageMO.showSendTime = @(NO);
          }
                 [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                     if (contextDidSave) {
                         BLULogInfo(@"MOC Save success!");
                     } else {
                         BLULogError(@"MOC save failed, error = %@", error);
                     }
                 }];
    }] doError:^(NSError *error) {
        messageMO.remoteState = @(BLUMessageMORemoteStateSendFailed);
    }];
}

- (BLUUser *)currentUser {
    return [[BLUAppManager sharedManager] currentUser];
}

- (NSInteger)lastOrderIndexWithLastMessage:(BLUMessageMO *)lastMessage {
    NSInteger orderIndex = 0;

    if (lastMessage) {
        orderIndex = lastMessage.orderIndex.integerValue + 1;
    }

    return orderIndex;
}

- (RACSignal *)resendMessage:(BLUMessageMO *)messageMO {
    messageMO.remoteState = @(BLUMessageMORemoteStateSending);
    NSInteger orderIndex = 0;
    BLUMessageMO *lastMessageMO = self.lastMessageMO;
    if (lastMessageMO) {
        orderIndex = lastMessageMO.orderIndex.integerValue + 1;
    }
    NSDate *lastDate = lastMessageMO.createDate;
    messageMO.orderIndex = @(orderIndex);
    return [[[[BLUApiManager sharedManager] sendMessageToUser:self.userID content:messageMO.text type:0] doNext:^(BLUMessage *recievedMessage) {
        messageMO.messageID = @(recievedMessage.messageID);
        messageMO.createDate = recievedMessage.createDate;
        messageMO.remoteState = @(BLUMessageMORemoteStateNormal);

        if (lastDate) {
            if (lastDate) {
                NSTimeInterval chatInterval = [messageMO.createDate timeIntervalSinceDate:lastDate];
                if (chatInterval > kChatTimeDifference) {
                    messageMO.showSendTime = @(YES);
                } else {
                    messageMO.showSendTime = @(NO);
                }
            } else {
                messageMO.showSendTime = @(NO);
            }
        }
    }] doError:^(NSError *error) {
        messageMO.remoteState = @(BLUMessageMORemoteStateSendFailed);
    }];
}

- (BLUMessageMO *)lastMessageMO {
    return [BLUMessageMO MR_findFirstWithPredicate:[self messagePredicate]
                                          sortedBy:BLUMessageMOKeyOrderIndex ascending:NO];
}

- (NSFetchRequest *)chatFetchRequestWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest * fetchRequest =
    [BLUMessageMO MR_requestAllSortedBy:BLUMessageMOKeyOrderIndex
                              ascending:YES
                              inContext:context];
    fetchRequest.fetchBatchSize = 25;
    fetchRequest.predicate = [self messagePredicate];
    return fetchRequest;
}

- (NSPredicate *)messagePredicate {
    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    return [NSPredicate predicateWithFormat:
            @"(fromUserID == %@ && toUserID == %@)|| (fromUserID == %@ && toUserID == %@)",
            @(self.userID), @(currentUser.userID), @(currentUser.userID), @(self.userID)];
}

@end
