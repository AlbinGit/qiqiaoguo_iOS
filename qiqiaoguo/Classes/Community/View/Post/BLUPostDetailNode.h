//
//  ASPostDetailNodel.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"
#import "BLUPostDetailNodeDelegate.h"
#import "BLUShowImageProtocol.h"

@class BLUPost, BLUPostDetailUserInfoNode, BLUContentParagraph;

@interface BLUPostDetailNode : ASCellNode

@property (nonatomic, strong) BLUPostDetailUserInfoNode *userNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *tagNode;
@property (nonatomic, strong) NSMutableArray *paragraphNodes;
@property (nonatomic, strong) ASTextNode *circleNode;
@property (nonatomic, strong) ASDisplayNode *separator;

@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, weak) id <BLUPostDetailNodeDelegate> delegate;
@property (nonatomic, weak) id <BLUShowImageProtocol> showImageDelegate;

@property (nonatomic, assign, readonly) CGFloat contentInset;
@property (nonatomic, assign, readonly) CGFloat contentMargin;

- (instancetype)initWithPost:(BLUPost *)post;

- (void)setParagraph:(id)paragraph
              toNode:(ASDisplayNode *)node;

- (BLUContentParagraph *)retrieveParagraphFromNode:(ASDisplayNode *)node;

- (CGFloat)likedUserAvatarHeight;
- (CGFloat)likedUserCollectionNodeHeight;

@end
