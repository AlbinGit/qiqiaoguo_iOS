//
//  BLUCircleActionDelegate.m
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleActionDelegate.h"
#import "BLUCircle.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircleMO.h"
#import "BLUCircleBriefCell.h"

@implementation BLUCircleActionDelegate

- (void)shouldFollowCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {
    [self p_followCircle:circleInfo follow:YES circleBriefCell:(BLUCircleBriefCell *)view];
}

- (void)shouldUnfollowCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender {
    [self p_followCircle:circleInfo follow:NO circleBriefCell:(BLUCircleBriefCell *)view];
}

- (void)p_followCircle:(NSDictionary *)circleInfo follow:(BOOL)follow circleBriefCell:(BLUCircleBriefCell *)cell {

    BLUCircle *circle = circleInfo[BLUCircleKeyCircle];
    NSNumber *circleID = circleInfo[BLUCircleKeyCircleID];
    
    NSParameterAssert(circle || circleID);
    
    NSInteger cid = circle ? circle.circleID : circleID.integerValue;

    BLUUser *currentUser = [BLUAppManager sharedManager].currentUser;
    if (currentUser == nil) {
        [self.viewController loginRequired:nil];
        return;
    }
    NSInteger userID = currentUser != nil ? currentUser.userID : 0;
    BLUCircleMO * circleMO = [BLUCircleMO circleMOFromCircleID:cid userID:userID];

    circleMO.isFollowRequesting = @(YES);

    if (follow) {
        @weakify(self);
        [[self followWithCircleID:cid] subscribeError:^(NSError *error) {
            @strongify(self);
            [self updateCircleMO:circleMO afterRequesAndSetFollow:NO];
            [self.viewController showTopIndicatorWithError:error];
        } completed:^{
            @strongify(self);
            [self updateCircleMO:circleMO afterRequesAndSetFollow:YES];
        }];
    } else {
        @weakify(self);
        [[self unfollowWithCircleID:cid] subscribeError:^(NSError *error) {
            @strongify(self);
            [self updateCircleMO:circleMO afterRequesAndSetFollow:YES];
            [self.viewController showTopIndicatorWithError:error];
        } completed:^{
            @strongify(self);
            [self updateCircleMO:circleMO afterRequesAndSetFollow:NO];
        }];
    }
}


- (void)updateCircleMO:(BLUCircleMO *)circleMO afterRequesAndSetFollow:(BOOL)follow {
    circleMO.didFollowCircle = @(follow);
    circleMO.isFollowRequesting = @(NO);
}

- (RACSignal *)followWithCircleID:(NSInteger)circleID {
    return [[BLUApiManager sharedManager] followCircleWithCircleID:circleID];
}

- (RACSignal *)unfollowWithCircleID:(NSInteger)circleID {
    return [[BLUApiManager sharedManager] unfollowCircleWithCircleID:circleID];
}

@end
