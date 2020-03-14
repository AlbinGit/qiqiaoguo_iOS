//
//  BLUCircleFollowNode.h
//  Blue
//
//  Created by Bowen on 27/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"
#import "BLUCircleFollowedPostNodeDelegate.h"

@class BLUPost;
@class BLUCircle;
@class BLUPostCommonLikeNode;
@class BLUPostCommonComentNode;
@class BLUCircleFollowedPostUserInfoNode;

@interface BLUCircleFollowedPostNode : ASCellNode

@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, strong) BLUCircleFollowedPostUserInfoNode *userNode;
@property (nonatomic, strong) ASDisplayNode *backgroundNode;
@property (nonatomic, strong) ASImageNode *videoImageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) ASImageNode *tagImageNode;
@property (nonatomic, strong) NSArray *imageNodes;
@property (nonatomic, strong) ASTextNode *imageCountPrompter;
@property (nonatomic, strong) ASDisplayNode *imageCountBackgroundNode;
@property (nonatomic, strong) BLUPostCommonLikeNode *likeNode;
@property (nonatomic, strong) BLUPostCommonComentNode *comentNode;
@property (nonatomic, strong) ASTextNode *circleNode;
@property (nonatomic, strong) ASControlNode *circleBackgroundNode;
@property (nonatomic, strong) ASDisplayNode *separator;

@property (nonatomic, weak) id<BLUCircleFollowedPostUserInfoNodeDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger maximumDisplayImageCount;

- (instancetype)initWithPost:(BLUPost *)post;

@end

@interface BLUCircleFollowedPostNode (Text)

- (NSDictionary *)titleAttributes;
- (NSDictionary *)contentAttributes;
- (NSDictionary *)footerAttributes;
- (NSAttributedString *)attributedCircle:(BLUCircle *)circle;

@end
