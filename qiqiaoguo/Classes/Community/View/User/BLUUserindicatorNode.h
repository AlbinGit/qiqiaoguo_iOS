//
//  BLUUserindicatorNode.h
//  Blue
//
//  Created by Bowen on 8/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "ASCellNode.h"

@interface BLUUserindicatorNode : ASCellNode

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) ASImageNode *indicatorNode;
@property (nonatomic, strong) ASDisplayNode *separator;

@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIImage *indicatorImage;

@property (nonatomic, assign) UIEdgeInsets bodyInsets;
@property (nonatomic, assign) CGSize avatarSize;
@property (nonatomic, assign) CGSize indicatorSize;
@property (nonatomic, assign) CGFloat contentOffset;

@end
