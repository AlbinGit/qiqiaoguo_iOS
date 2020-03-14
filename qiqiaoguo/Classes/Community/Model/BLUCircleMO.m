//
//  BLUCircleMO.m
//  
//
//  Created by Bowen on 24/11/2015.
//
//

#import "BLUCircleMO.h"
#import "BLUCircle.h"

NSString * BLUCircleMOKeyDidFollowCircle = @"didFollowCircle";
NSString * BLUCircleMOKeyPriority = @"priority";
NSString * BLUCircleMOKeyCircleID = @"circleID";

@implementation BLUCircleMO

- (void)configCircleMOWithCircle:(BLUCircle *)circle {
    self.circleID = @(circle.circleID);
    self.createDate = circle.createDate;
    self.name = circle.name;
    self.slogan = circle.slogan;
    self.circleDescription = circle.circleDescription;
    self.postCount = @(circle.postCount);
    self.followedUserCount = @(circle.followedUserCount);
    self.logoThumb = circle.logo.thumbnailURL.absoluteString;
    self.didFollowCircle = @(circle.didFollowCircle);
    self.shouldVisible = @(circle.shouldVisible);
    self.unreadPostCount = @(circle.unreadPostCount);
    self.priority = @(circle.priority);
    self.masterUserID = @(0);
    self.isFollowRequesting = @(NO);
}

- (void)updateFromCircle:(BLUCircle *)circle {
    BOOL circleIDCompare = [self.circleID isEqual:@(circle.circleID)];
    BOOL createDateCompare = [self.createDate isEqual:circle.createDate];
    BOOL nameCompare = [self.createDate isEqual:circle.name];
    BOOL sloganCompare = [self.slogan isEqual:circle.slogan];
    BOOL circleDescriptionCompare = [self.circleDescription isEqual:circle.circleDescription];
    BOOL postCountCompare = [self.postCount isEqual:@(circle.postCount)];
    BOOL followedUserCountCompare = [self.followedUserCount isEqual:@(circle.followedUserCount)];
    BOOL logoThumbCompare = [self.logoThumb isEqual:circle.logo.thumbnailURL.absoluteString];
    BOOL didFollowCircleCompare = [self.didFollowCircle isEqual:@(circle.didFollowCircle)];
    BOOL shouldVisibleCompare = [self.shouldVisible isEqual:@(circle.shouldVisible)];
    BOOL unreadPostCountCompare = [self.unreadPostCount isEqual:@(circle.unreadPostCount)];
    BOOL priorityCompare = [self.priority isEqual:@(circle.priority)];
    BOOL isFollowingRequesting = [self.isFollowRequesting isEqual:@(circle.isFollowRequesting)];

    if (circleIDCompare &&
        createDateCompare &&
        nameCompare &&
        sloganCompare &&
        circleDescriptionCompare &&
        postCountCompare &&
        followedUserCountCompare &&
        logoThumbCompare &&
        didFollowCircleCompare &&
        shouldVisibleCompare &&
        unreadPostCountCompare &&
        priorityCompare &&
        isFollowingRequesting) {
        return ;
    } else {
        [self configCircleMOWithCircle:circle];
    }
}

- (void)resetUnreadPostCount {
    self.unreadPostCount = 0;
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
//        if (error) {
//            BLULogError(@"Error = %@", error);
//        } else {
//            BLULogInfo(@"Save circles success");
//        }
//    }];
}

+ (BLUCircleMO *)savetyInsertCircle:(BLUCircle *)circle withUserID:(NSInteger)userID {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    BLUCircleMO *circleMO = [BLUCircleMO MR_findFirstWithPredicate:[self circlePredicateWithUserID:userID circleID:circle.circleID] sortedBy:BLUCircleMOKeyCircleID ascending:NO inContext:context];

    if (circleMO == nil) {
        circleMO = [BLUCircleMO MR_createEntityInContext:context];
        circleMO.masterUserID = @(userID);
    }

    [circleMO configCircleMOWithCircle:circle];

    return circleMO;
}

+ (BLUCircleMO *)circleMOFromCircle:(BLUCircle *)circle userID:(NSInteger)userID {
    BLUCircleMO *circleMO = [BLUCircleMO MR_findFirstWithPredicate:[self circlePredicateWithUserID:userID circleID:circle.circleID] sortedBy:BLUCircleMOKeyCircleID ascending:NO];
    return circleMO;
}

+ (BLUCircleMO *)circleMOFromCircleID:(NSInteger)circleID userID:(NSInteger)userID {
    BLUCircleMO *circleMO = [BLUCircleMO MR_findFirstWithPredicate:[self circlePredicateWithUserID:userID circleID:circleID] sortedBy:BLUCircleMOKeyCircleID ascending:NO];
    return circleMO;
}

+ (NSPredicate *)circlePredicateWithUserID:(NSInteger)userID circleID:(NSInteger)circleID {
    return [NSPredicate predicateWithFormat:@"masterUserID == %@ && circleID == %@", @(userID), @(circleID)];
}

@end
