//
//  BLUCircleFollowUserInfoNode.h
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"
#import "BLUCircleFollowedPostUserInfoNodeDelegate.h"


typedef NS_ENUM(NSInteger, BLUCircleFollowedPostUserInfoFollowState) {
    BLUCircleFollowUserInfoFollowStateFollow,
    BLUCircleFollowUserInfoFollowStateDidFollow,
    BLUCircleFollowUserInfoFollowStateNoFollow,
};

@class BLUUserGenderImageNode;
@class BLUPost;

@interface BLUCircleFollowedPostUserInfoNode : ASControlNode

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *nicknameNode;
@property (nonatomic, strong) ASImageNode *timeImageNode;
@property (nonatomic, strong) ASTextNode *timeTextNode;
@property (nonatomic, strong) BLUUserGenderImageNode *genderNode;
@property (nonatomic, strong) ASTextNode *levelNode;
@property (nonatomic, strong) ASDisplayNode *levelBackground;
@property (nonatomic, strong) ASTextNode *followNode;
@property (nonatomic, strong) ASControlNode *followBackground;

@property(nonatomic,weak) id<BLUCircleFollowedPostUserInfoNodeDelegate2> delegate;



@property (nonatomic, strong) BLUPost *post;
@property (nonatomic, assign) BLUCircleFollowedPostUserInfoFollowState state;
@property (nonatomic, assign) BOOL anonymous;

- (instancetype)initWithPost:(BLUPost *)post
                 followState:(BLUCircleFollowedPostUserInfoFollowState)state;

- (void)configureFollowWithState:(BLUCircleFollowedPostUserInfoFollowState)state;

@end
