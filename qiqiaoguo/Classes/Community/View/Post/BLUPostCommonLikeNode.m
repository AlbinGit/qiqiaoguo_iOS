//
//  BLUPostCommonLikeNode.m
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommonLikeNode.h"

@implementation BLUPostCommonLikeNode

- (instancetype)initWithLikesCount:(NSInteger)likesCount liked:(BOOL)liked{
    if (self = [super init]) {
        _likesCount = likesCount >= 0 ? likesCount : 0;
        _liked = liked;
        _iconNode = [[ASImageNode alloc] init];
        _iconNode.backgroundColor = [UIColor clearColor];
        _iconNode.image = [UIImage imageNamed:@"post-common-like"];

        _countNode = [[ASTextNode alloc] init];
        _countNode.attributedString =
        [[NSAttributedString alloc] initWithString:@(_likesCount).description
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
