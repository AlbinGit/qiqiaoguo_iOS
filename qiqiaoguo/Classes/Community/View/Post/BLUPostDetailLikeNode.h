//
//  BLUPostDetailLikeNode.h
//  Blue
//
//  Created by Bowen on 31/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"
#import "BLUPostDetailLikeNodeDelegate.h"

@class BLUPost;

@interface BLUPostDetailLikeNode : ASCellNode

@property (nonatomic, strong) ASImageNode *likeButton;
@property (nonatomic, strong) ASImageNode *showlikeUsersButton;
@property (nonatomic, strong) NSArray *likedUserNodes;
@property (nonatomic, strong) ASTextNode *likePromptNode;

@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, assign) CGFloat contentInset;
@property (nonatomic, assign) CGFloat contentMargin;
@property (nonatomic, assign) CGFloat likeUsersSpacing;
@property (nonatomic, assign) CGFloat likedUserWidth;
@property (nonatomic, assign) CGFloat likeButtonHeight;

@property (nonatomic, weak) id <BLUPostDetailLikeNodeDelegate> delegate;

- (instancetype)initWithPost:(BLUPost *)post;

@end
