//
//  BLUPostNodeCommentNode.m
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommonComentNode.h"

@implementation BLUPostCommonComentNode

- (instancetype)initWithComentsCount:(NSInteger)comentsCount {
    if (self = [super init]) {
        _comentsCount = comentsCount >= 0? comentsCount : 0;

        _iconNode = [[ASImageNode alloc] init];
        _iconNode.backgroundColor = [UIColor clearColor];
        _iconNode.tintColor =
        [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1];
        _iconNode.image = [UIImage imageNamed:@"post-common-comment-0"];

        _countNode = [[ASTextNode alloc] init];
        _countNode.attributedString =
        [[NSAttributedString alloc] initWithString:@(_comentsCount).description
                                        attributes:[self controlAttributed]];

        [self addSubnode:_iconNode];
        [self addSubnode:_countNode];

        self.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
        self.shouldRasterizeDescendants = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *mainStack =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:BLUThemeMargin
                                     justifyContent:ASStackLayoutJustifyContentStart
                                         alignItems:ASStackLayoutAlignItemsCenter
                                           children:@[_iconNode, _countNode]];

    return [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[mainStack]];
}

- (NSDictionary *)controlAttributed {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal),
             NSForegroundColorAttributeName:
                 [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1],
             };
}

@end
