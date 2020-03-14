//
//  BLUPostDetailCommentUserInfoNode.h
//  Blue
//
//  Created by Bowen on 23/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASDisplayNode.h"

@class BLUComment;
@class BLUUserGenderImageNode;

@interface BLUPostDetailCommentUserInfoNode : ASControlNode

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *nicknameNode;
@property (nonatomic, strong) ASImageNode *timeImageNode;
@property (nonatomic, strong) ASTextNode *timeTextNode;
@property (nonatomic, strong) BLUUserGenderImageNode *genderNode;
@property (nonatomic, strong) ASTextNode *floorNode;
@property (nonatomic, strong) ASTextNode *levelNode;
@property (nonatomic, strong) ASDisplayNode *levelBackground;
@property (nonatomic, strong) ASButtonNode *likeButton;

@property (nonatomic, strong) ASButtonNode *userButton;

@property (nonatomic, strong) UIColor *upColor;
@property (nonatomic, strong) ASTextNode *upNode; //楼主
@property (nonatomic, strong) ASDisplayNode *upBackground;

@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, assign) BOOL isUp;

- (instancetype)initWithComment:(BLUComment *)comment
                      anonymous:(BOOL)anonymous
                           isUp:(BOOL)isUp;

- (CGSize)avatarSize;
- (void)configureLikeButtonWithComment:(BLUComment *)comment;

@end
