//
//  BLUPostCommonVideoNode.h
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "ASCellNode.h"

@class  BLUPost;

@interface BLUPostCommonVideoNode : ASCellNode

@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) UIEdgeInsets contentPadding;
@property (nonatomic, assign) CGFloat elementSpacing;
@property (nonatomic, assign) CGSize videoCoverSize;

@property (nonatomic, strong) ASDisplayNode *background;
@property (nonatomic, strong) ASImageNode *videoIndicator;
@property (nonatomic, strong) ASNetworkImageNode *videoCover;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, strong) ASButtonNode *numberOfViewsNode;
@property (nonatomic, strong) ASButtonNode *numberOfCommentsNode;

@property (nonatomic, strong) BLUPost *post;

- (instancetype)initWithPost:(BLUPost *)post;

@end