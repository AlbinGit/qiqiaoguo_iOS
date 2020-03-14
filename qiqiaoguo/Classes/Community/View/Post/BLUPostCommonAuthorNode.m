//
//  BLUPostCommonAuthorNode.m
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostCommonAuthorNode.h"

@implementation BLUPostCommonAuthorNode

- (instancetype)initWithAuthor:(BLUUser *)author
                    createDate:(NSDate *)createDate
                     anonymous:(BOOL)anonymous{
    if (self = [super init]) {
        NSParameterAssert([author isKindOfClass:[BLUUser class]]);
        NSParameterAssert([createDate isKindOfClass:[NSDate class]]);
        _anonymous = anonymous;

        _nameNode = [[ASTextNode alloc] init];
        _nameNode.maximumNumberOfLines = 1;
        _nameNode.flexShrink = YES;
        _nameNode.truncationMode = NSLineBreakByTruncatingTail;
        _nameNode.attributedString =
        [self attributedName:author.nickname anonymous:anonymous];

//        if (anonymous == NO) {
//            _genderNode = [[ASImageNode alloc] init];
//            _genderNode.backgroundColor = [UIColor clearColor];
//            _genderNode.image = [UIImage postGenderImageWithGender:author.gender];
//        }

        _timeNode = [[ASTextNode alloc] init];
        _timeNode.maximumNumberOfLines = 1;
        _timeNode.attributedString =
        [self attributeTime:createDate.postTime];

        [self addSubnode:_nameNode];
//        if (_genderNode) {
//            [self addSubnode:_genderNode];
//        }
        [self addSubnode:_timeNode];

        self.shouldRasterizeDescendants = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSArray *elements = _genderNode ?
  @[_nameNode, _genderNode, _timeNode] :
  @[_nameNode, _timeNode];

    ASStackLayoutSpec *mainStack =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:BLUThemeMargin
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:ASStackLayoutAlignItemsCenter
                                           children:elements];

    return [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[mainStack]];
}

- (NSDictionary *)controlAttributes {
    return @{
        NSFontAttributeName:
            BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal),
        NSForegroundColorAttributeName:
            [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1],
    };
}

- (NSAttributedString *)attributedName:(NSString *)name anonymous:(BOOL)anonymous {
    if (anonymous) {
        name = NSLocalizedString(@"post-common-author-node.anonymous", @"Anonymous");
    }
    return [[NSAttributedString alloc] initWithString:name
                                           attributes:[self controlAttributes]];
}

- (NSAttributedString *)attributeTime:(NSString *)time {
    return [[NSAttributedString alloc ] initWithString:time
                                            attributes:[self controlAttributes]];
}

@end
