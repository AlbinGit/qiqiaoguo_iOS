//
//  BLUCirleHotTagNode.h
//  Blue
//
//  Created by cws on 16/4/6.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BLUPostTag.h"

@interface BLUCirleHotTagNode : ASCellNode

@property (nonatomic, strong) ASNetworkImageNode *TagImageNode;
@property (nonatomic, strong) ASTextNode *TagNode;
@property (nonatomic, strong) ASTextNode *connetNode;
@property (nonatomic, strong) ASTextNode *joinNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) BLUPostTag *tag;

- (instancetype)initWithTag:(BLUPostTag *)tag;

@end

@interface BLUCirleHotTagNode (Text)

- (NSAttributedString *)attributedTag:(NSString *)tag;
- (NSAttributedString *)attributedConnetNode:(NSString *)connet;
- (NSAttributedString *)attributedJoin:(NSString *)Join;

@end