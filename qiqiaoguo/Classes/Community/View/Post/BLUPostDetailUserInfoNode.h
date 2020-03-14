//
//  BLUPostDetailUserInfoNode.h
//  Blue
//
//  Created by Bowen on 21/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASControlNode.h"

@class BLUUserGenderImageNode;

@interface BLUPostDetailUserInfoNode : ASControlNode

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *nicknameNode;
@property (nonatomic, strong) ASImageNode *timeImageNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, strong) BLUUserGenderImageNode *genderNode;
@property (nonatomic, strong) ASTextNode *levelNode;
@property (nonatomic, strong) ASDisplayNode *levelBackground;

@property (nonatomic, assign) BOOL anonymous;

- (instancetype)initWithUser:(BLUUser *)user
                    postTime:(NSString *)postTime
                   anonymous:(BOOL)anonymous;

@end
