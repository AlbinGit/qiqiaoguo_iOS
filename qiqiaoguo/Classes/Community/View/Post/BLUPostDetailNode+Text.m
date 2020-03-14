//
//  BLUPostDetailNode+Text.m
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailNode+Text.h"
#import "BLUCircle.h"
#import "BLUPostTagTextAttachment.h"
#import "BLUPost.h"

@implementation BLUPostDetailNode (Text)

- (NSString *)circleLinkedAttributedName {
    return @"BLUPostDetailCircleLinkedAttributedName";
}

- (NSString *)tagLinkedAttributedName {
    return @"BLUPostDetailTagLinkAttributedName";
}

- (NSArray *)circleLinkedAttributedNames {
    return @[[self circleLinkedAttributedName]];
}

- (NSArray *)tagLinkedAttributedNames {
    return @[[self tagLinkedAttributedName]];
}

- (NSDictionary *)titleAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithSize(20),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#333333"],
             };
}

- (NSDictionary *)contentAttributes {
    NSMutableParagraphStyle *textStyle =
    [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    textStyle.lineSpacing = BLUThemeMargin;
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#666666"],
             NSParagraphStyleAttributeName: textStyle,
             };
}

- (NSDictionary *)circleFromAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal),
             NSForegroundColorAttributeName:
                 [UIColor colorFromHexString:@"#999999"],
             };
}

- (NSDictionary *)circleAttributes {
    return @{
             NSFontAttributeName:
                 BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal),
             NSForegroundColorAttributeName:
                 BLUThemeMainColor,
             [self circleLinkedAttributedName]: self.post.circle,
             };
}

- (NSAttributedString *)attributedTitle:(NSString *)title {
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:[self titleAttributes]];
}

- (NSAttributedString *)attributedContent:(NSString *)content {
    return [[NSAttributedString alloc] initWithString:content
                                           attributes:[self contentAttributes]];
}

- (NSAttributedString *)attributedLink:(NSString *)content {
    NSMutableParagraphStyle *textStyle =
    [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    textStyle.lineSpacing = BLUThemeMargin;
    NSDictionary *attributes =
    @{NSFontAttributeName:
          BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
      NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.61 saturation:0.68 brightness:0.86 alpha:1],
      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
      NSParagraphStyleAttributeName: textStyle};
    return [[NSAttributedString alloc] initWithString:content
                                           attributes:attributes];
}

- (NSAttributedString *)attributedCircle:(BLUCircle *)circle {

    NSString *fromString =
    NSLocalizedString(@"post-detail-node.circle-text-node.from", @"From");
    NSString *circleName = circle.name;
    NSString *circleString =
    [NSString stringWithFormat:@"%@ %@", fromString, circleName];

    NSMutableAttributedString *attributedCircleString =
    [[NSMutableAttributedString alloc] initWithString:circleString];

    [attributedCircleString addAttributes:[self circleFromAttributes]
                                    range:[circleString rangeOfString:fromString]];
    [attributedCircleString addAttributes:[self circleAttributes]
                                    range:[circleString rangeOfString:circleName]];

    return attributedCircleString;
}

- (NSAttributedString *)attributedTags:(NSArray *)tags {
    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];

    for (BLUPostTag *tag in tags) {
        NSAttributedString *str = [self attrStrFromTag:tag];
        [attrStr appendAttributedString:str];
    }

    return attrStr;
}

- (NSAttributedString *)attrStrFromTag:(BLUPostTag *)tag {
    NSMutableParagraphStyle *textStyle =
    [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    textStyle.lineSpacing = BLUThemeMargin;
    NSDictionary *textAttributes =
    @{
      NSFontAttributeName:
          BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge),
      NSForegroundColorAttributeName:
          [UIColor colorFromHexString:@"#9FA0A2"],
      NSParagraphStyleAttributeName: textStyle,
      [self tagLinkedAttributedName]: tag,
      };
    return [BLUPostTagTextAttachment
            postTagAttributeStringWithTag:tag
            font:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)
            selected:NO
            deleteAble:NO
            textAttributes:textAttributes];
}

- (NSAttributedString *)attributedNumberOfLikedUsers:(NSInteger)number {
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"post-detail-node.liked-user-button.title-%@", @"Like"), @(number)];
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:[self circleFromAttributes]];
}

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange {
    if ([attribute isEqualToString:[self tagLinkedAttributedName]]) {
        BLULogDebug(@"tap tag = %@", value);
        if ([self.delegate
             respondsToSelector:@selector(shouldShowTagDetailForTag:from:sender:)]) {
            [self.delegate shouldShowTagDetailForTag:value
                                                from:self
                                              sender:textNode];
        }
    } else if ([attribute isEqualToString:[self circleLinkedAttributedName]]) {
        BLUCircle *circle = (BLUCircle *)value;
        BLULogDebug(@"tag circle = %@", circle);
        if ([self.delegate
             respondsToSelector:
             @selector(shouldShowCircleDetailForCircleID:from:sender:)]) {
            [self.delegate shouldShowCircleDetailForCircleID:circle.circleID
                                                        from:self
                                                      sender:textNode];
        }
    } else {
        return;
    }
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    if ([attribute isEqualToString:[self tagLinkedAttributedName]]) {
        return YES;
    } else if ([attribute isEqualToString:[self circleLinkedAttributedName]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
