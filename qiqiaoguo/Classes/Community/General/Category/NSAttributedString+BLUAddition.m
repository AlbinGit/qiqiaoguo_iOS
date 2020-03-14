//
//  NSAttributedString+BLUAddition.m
//  Blue
//
//  Created by Bowen on 8/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "NSAttributedString+BLUAddition.h"

@implementation NSAttributedString (BLUAddition)

+ (NSAttributedString *)contentAttributedStringWithContent:(NSString *)content {
    if (content == nil) {
        return nil;
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge) range:NSMakeRange(0, [content length])];
    return attributedString;
}

- (NSArray *)allAttachments {
    NSMutableArray *theAttachments = [NSMutableArray array];
    NSRange theStringRange = NSMakeRange(0, [self length]);
    if (theStringRange.length > 0)
    {
        NSInteger N = 0;
        do
        {
            NSRange theEffectiveRange;
            NSDictionary *theAttributes = [self attributesAtIndex:N longestEffectiveRange:&theEffectiveRange inRange:theStringRange];
            NSTextAttachment *theAttachment = [theAttributes objectForKey:NSAttachmentAttributeName];
            if (theAttachment != NULL)
                [theAttachments addObject:theAttachment];
            N = theEffectiveRange.location + theEffectiveRange.length;
        }
        while (N < theStringRange.length);
    }
    return(theAttachments);
}

- (NSArray *)allAttachmentsString {
    NSMutableArray *attachemntStrings = [NSMutableArray array];
    NSRange textRange = NSMakeRange(0, [self length]);
    if (textRange.length > 0) {
        NSInteger i = 0;
        do {
            NSRange effectiveRange;
            NSDictionary *attributes = [self attributesAtIndex:i longestEffectiveRange:&effectiveRange inRange:textRange];
            NSTextAttachment *attachment = [attributes objectForKey:NSAttachmentAttributeName];
            if (attachment != NULL) {
                NSAttributedString *subString = [self attributedSubstringFromRange:effectiveRange];
                [attachemntStrings addObject:subString];
            }
            i = effectiveRange.location + effectiveRange.length;
        } while (i < textRange.length);
    }
    return(attachemntStrings);
}

- (NSArray *)allStrings {
    NSMutableArray *theStrings = [NSMutableArray array];
    NSRange theTextRange = NSMakeRange(0, [self length]);
    if (theTextRange.length > 0) {
        NSInteger i = 0;
        do {
            NSRange theEffectiveRange;
            id attribute =

            [self attribute:NSAttachmentAttributeName
                    atIndex:i
      longestEffectiveRange:&theEffectiveRange
                    inRange:theTextRange];

            if (attribute == nil) {
                NSAttributedString *str = [self attributedSubstringFromRange:theEffectiveRange];
                [theStrings addObject:str.string];
            }

            i = theEffectiveRange.location + theEffectiveRange.length;
        } while (i < theTextRange.length);
    }
    return theStrings;
}

- (NSRange)firstStringRange {
    NSRange textRange = NSMakeRange(0, [self length]);
    NSRange strRange = NSMakeRange(0, 0);

    if (textRange.length > 0) {
        NSInteger i = 0;
        do {
            NSRange effectiveRange;
            NSDictionary *attrs =
            [self attributesAtIndex:i
              longestEffectiveRange:&effectiveRange
                            inRange:textRange];
            NSTextAttachment *attachment =
            [attrs objectForKey:NSAttachmentAttributeName];

            if (attachment == nil) {
                strRange = effectiveRange;
                break;
            }
        } while (i < textRange.length);
    }

    return strRange;
}

@end
