//
//  BLUPostTagTextAttachment.m
//  Blue
//
//  Created by Bowen on 2/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagTextAttachment.h"
#import "UIImage+Tag.h"
#import "BLUPostTag.h"

NSString * BLUPostTagTitleAttributeName = @"BLUPostTagTitleAttributeName";

@implementation BLUPostTagTextAttachment

- (instancetype)initWithPostTag:(BLUPostTag *)tag {
    if (self = [super init]) {
        NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);
        NSParameterAssert(tag.title.length > 0);
        _tag = tag;
    }

    return self;
}

- (NSAttributedString *)tagAttrbuteString {
    return [NSAttributedString attributedStringWithAttachment:self];
}

- (NSAttributedString *)tagAttrbuteStringWithFont:(UIFont *)font
                                          seleted:(BOOL)seleted
                                      deletedAble:(BOOL)deleteAble
                                   textAttributes:(NSDictionary *)textAttributes {
    UIImage *image =
    [UIImage imageFromTag:_tag
                  seleted:seleted
               deleteAble:deleteAble
                     font:font];

    self.image = image;

    NSMutableAttributedString *mutAttrStr =
    [[NSMutableAttributedString alloc]
     initWithAttributedString:[NSAttributedString
                               attributedStringWithAttachment:self]];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]
                                 initWithDictionary:textAttributes];

    dict[BLUPostTagTitleAttributeName] = _tag.title;

    [mutAttrStr addAttributes:dict range:NSMakeRange(0, mutAttrStr.length)];

    return mutAttrStr;
}

+ (NSAttributedString *)postTagAttributeStringWithTag:(BLUPostTag *)tag
                                                      font:(UIFont *)font
                                                  selected:(BOOL)selected
                                                deleteAble:(BOOL)deleteAble
                                            textAttributes:(NSDictionary *)textAttributes {
    BLUPostTagTextAttachment *tatt =
    [[BLUPostTagTextAttachment alloc] initWithPostTag:tag];

    return [tatt tagAttrbuteStringWithFont:font
                            seleted:selected
                        deletedAble:deleteAble
                     textAttributes:textAttributes];

}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    CGRect bounds;
    bounds.origin = CGPointMake(0, -lineFrag.size.height / 2.0);
    bounds.size = self.image.size;
    return bounds;
}

+ (BLUPostTagTextAttachment *)postTagTextAttachmentWithTag:(BLUPostTag *)tag
                                                      font:(UIFont *)font
                                                  selected:(BOOL)seleted
                                               deletedAble:(BOOL)deleteAble {

    BLUPostTagTextAttachment *tatt =
    [[BLUPostTagTextAttachment alloc] initWithPostTag:tag];

    UIImage *image =
    [UIImage imageFromTag:tag
                  seleted:seleted
               deleteAble:deleteAble
                     font:font];

    tatt.image = image;
    return tatt;
}

@end

@implementation NSAttributedString (BLUPostTag)

- (void)logTagTitle {
    [self enumerateAttribute:BLUPostTagTitleAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        BLULogDebug(@"title = %@, range = %@", value ,NSStringFromRange(range));
    }];
}

- (NSArray *)allTags {
    NSArray *textAttachments = [self allAttachments];
    NSMutableArray *tags = [NSMutableArray new];
    [textAttachments enumerateObjectsUsingBlock:^(BLUPostTagTextAttachment *tatt,
                                                  NSUInteger idx,

                                                  BOOL * _Nonnull stop) {
        NSParameterAssert([tatt isKindOfClass:[BLUPostTagTextAttachment class]]);
        BLUPostTag *tag = tatt.tag;
        NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);
        [tags addObject:tag];
    }];
    return tags;
}

@end