//
//  BLUPostDetailLikedUserNode.h
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"

@interface BLUPostDetailLikedUserNode : ASCellNode

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;

- (instancetype)initWithUser:(BLUUser *)user;

@end
