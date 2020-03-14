//
//  BLUDialogueViewModel.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDialogueViewModel.h"
#import "BLUApiManager+Dialogue.h"
#import "BLUDialogue.h"
#import "BLUDialogueMO.h"
#import "BLUChatViewModel.h"

@interface BLUDialogueViewModel ()

@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id <NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;
@property (nonatomic, assign, readwrite) BLUDialogueViewModelState state;

@end

@implementation BLUDialogueViewModel

- (instancetype)initWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate {
    if (self = [super init]) {
        _fetchedResultsControllerDelegate = delegate;
        _state = BLUDialogueViewModelStateNormal;
        return self;
    }
    return nil;
}

- (instancetype)init {
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSFetchRequest *fetchRequset = [self dialogueRequestWithContext:context];

        _fetchedResultsController =
        [BLUDialogueMO MR_fetchController:fetchRequset
                                 delegate:_fetchedResultsControllerDelegate
                             useFileCache:NO
                                groupedBy:nil
                                inContext:context];

        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            BLULogError(@"Error = %@", error);
            abort();
        }
    }

    return _fetchedResultsController;
}

- (BLUPagination *)pagination {
    if (_pagination == nil) {
        _pagination = [[BLUPagination alloc] initWithPerpage:BLUPaginationPerpageMax group:nil order:BLUPaginationOrderNone];
    }
    return _pagination;
}

- (void)fetch {
    [self.fetchDisposable dispose];
    if ([BLUAppManager sharedManager].currentUser) {
        self.pagination.page = 1;
        self.state = BLUDialogueViewModelStateFetching;
        @weakify(self);
        [[[[BLUApiManager sharedManager]
          fetchDialogueWithPagination:self.pagination]
          retry:3]
         subscribeNext:^(NSArray *items) {
             @strongify(self);
             self.state = BLUDialogueViewModelStateNormal;
             if (items) {
                 NSNumber *masterUserID = @([BLUAppManager sharedManager].currentUser.userID);

                 [items enumerateObjectsUsingBlock:^(BLUDialogue *dialogue, NSUInteger idx, BOOL * _Nonnull stop) {
                     if (!(dialogue.targetID <= 0)) {
                         BLUDialogueMO *dialogueMO = [BLUDialogueMO MR_findFirstByAttribute:BLUDialogueMOKeyFromUserID withValue:@(dialogue.targetID)];

                         if (dialogueMO == nil) {
                             dialogueMO = [BLUDialogueMO MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                         }

                         [dialogueMO configWithDialogue:dialogue];
                         dialogueMO.masterUserID = masterUserID;
                     }
                 }];

//                 [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
//                     BLULogDebug(@"dialogue change saved");
//                 }];
             }
         } error:^(NSError *error) {
             @strongify(self);
             BLULogError(@"Error = %@", error);
             self.state = BLUDialogueViewModelStateFetchFailed;
         }];
    }
}

- (void)deleteDialogue:(BLUDialogueMO *)dialogueMO {
    NSInteger fromUserID = dialogueMO.fromUserID.integerValue;
    BLUChatViewModel *chatViewModel = [[BLUChatViewModel alloc] initWithUserID:fromUserID fetchedResultsControllerDelegate:nil];
    [chatViewModel deleteAllMessages];
    BLUUser *masterUser = [[BLUAppManager sharedManager] currentUser];
    [BLUDialogueMO MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"fromUserID == %@ && masterUserID == %@", @(fromUserID), @(masterUser.userID)] inContext:[NSManagedObjectContext MR_defaultContext]];
    [[[BLUApiManager sharedManager] deleteDialogueWithDialogueID:dialogueMO.dialogueID.integerValue] subscribeCompleted:^{
    }];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

- (NSFetchRequest *)dialogueRequestWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest =
    [BLUDialogueMO MR_requestAllSortedBy:BLUDialogueMOKeyLastTime
                               ascending:NO
                               inContext:context];
    fetchRequest.fetchBatchSize = 25;
    fetchRequest.predicate = [self dialoguePredicate];
    return fetchRequest;
}

- (NSPredicate *)dialoguePredicate {
    BLUUser *currentUser = [[BLUAppManager sharedManager] currentUser];
    return [NSPredicate predicateWithFormat:
            @"masterUserID == %@", @(currentUser.userID)];
}

- (NSArray *)currentDialogues {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSFetchRequest *fetchRequest = [self dialogueRequestWithContext:context];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        BLULogError(@"Error =%@", error);
    }
    return fetchedObjects;
}

@end
