//
//  BLUPostCommonNode.h
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"

@class BLUPost;
@class BLUPostCommonAuthorNode;
@class BLUPostCommonLikeNode;
@class BLUPostCommonComentNode;

@interface BLUPostCommonNode : ASCellNode

@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, strong) ASDisplayNode *backgroundNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) ASImageNode *tagImageNode;
@property (nonatomic, strong) NSArray *imageNodes;
@property (nonatomic, strong) ASTextNode *imageCountPrompter;
@property (nonatomic, strong) ASDisplayNode *imageCountBackgroundNode;
@property (nonatomic, strong) BLUPostCommonAuthorNode *authorNode;
@property (nonatomic, strong) BLUPostCommonLikeNode *likeNode;
@property (nonatomic, strong) BLUPostCommonComentNode *comentNode;

@property (nonatomic, strong) ASImageNode *videoImageNode;

@property (nonatomic, assign, readonly) NSInteger maximumDisplayImageCount;

- (instancetype) initWithPost:(BLUPost *)post;

@end

@interface BLUPostCommonNode (TextStyle)

- (NSDictionary *)titleAttributes;
- (NSDictionary *)contentAttributes;
- (NSDictionary *)footerAttributes;

@end
