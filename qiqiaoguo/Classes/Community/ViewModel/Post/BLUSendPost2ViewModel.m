//
//  BLUSendPost2ViewModel.m
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewModel.h"
#import "BLUPost.h"
#import "BLUApiManager+Post.h"
#import "BLUApiManager+Others.h"
#import "BLUContentParagraph.h"
#import "BLUPostTag.h"

NSString * const BLUSendPostImageSpaceAttributedName = @"BLUSendPostImageSpaceAttributedName";

@implementation BLUSendPost2ViewModel

- (RACSignal *)validatePost {
    return [[RACSignal combineLatest:@[RACObserve(self, title), RACObserve(self, circleID)]]
            reduceEach:^id(NSString *title, NSNumber *circleID){
                BLULogDebug(@"title ==> %@", title);
                BLULogDebug(@"circleID ==> %@", circleID);
        NSNumber *ret =  @(title.length > 0 && circleID.integerValue > 0);
                BLULogDebug(@"ret ==> %@", ret);
                return ret;
    }];
}

- (RACCommand *)send {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self validatePost] signalBlock:^RACSignal *(id input) {
        @strongify(self);

        NSArray *paragraphs = [self paragraphsFromAttributedString:self.attributedContent];
        NSArray *imageResesNeedUpload = [self imageResesFromParagraph:paragraphs];
        if (imageResesNeedUpload.count > 0) {
            return [[[BLUApiManager sharedManager] uploadImageReses:imageResesNeedUpload] flattenMap:^RACStream *(NSArray *imageReses) {
                [self mergeImageReses:imageReses toParagraphs:paragraphs];
                NSArray *tagTitles = [self tagTitlesFromTags:self.tags];
                return [[BLUApiManager sharedManager] sendPostToCircle:self.circleID
                                                                 title:self.title
                                                            paragraphs:paragraphs
                                                             tagTitles:tagTitles
                                                             anonymous:self.anonymous];
            }];
        } else {
            NSArray *paragraphs = [self paragraphsFromAttributedString:self.attributedContent];
            NSArray *tagTitles = [self tagTitlesFromTags:self.tags];
            return [[BLUApiManager sharedManager] sendPostToCircle:self.circleID
                                                             title:self.title
                                                        paragraphs:paragraphs
                                                         tagTitles:tagTitles
                                                         anonymous:self.anonymous];
        }
    }];
}

- (NSArray *)imageResesFromParagraph:(NSArray *)paragraphs {
    NSMutableArray *imageReses = [NSMutableArray new];
    for (BLUContentParagraph *paragraph in paragraphs) {
        if (paragraph.imageRes) {
            BLUAssertObjectIsKindOfClass(paragraph.imageRes, [BLUImageRes class]);
            [imageReses addObject:paragraph.imageRes];
        }
    }
    return imageReses;
}

- (NSArray *)paragraphsFromAttributedString:(NSAttributedString *)attributedString {
    NSMutableArray *paragraphs = [NSMutableArray new];
    BLUContentParagraph *lastContentParagraph = nil;
    NSRange textRange = NSMakeRange(0, [self.attributedContent length]);
    if (textRange.length > 0) {
        NSInteger index = 0;
        do {
            NSRange effectiveRange;
            NSDictionary *attributes =
            [self.attributedContent attributesAtIndex:index
                                longestEffectiveRange:&effectiveRange
                                              inRange:textRange];

            NSTextAttachment *attachment =
            [attributes objectForKey:NSAttachmentAttributeName];

            id spaceObject = [attributes objectForKey:BLUSendPostImageSpaceAttributedName];

            if (spaceObject == nil) {
                if (attachment == nil) {
                    if (lastContentParagraph != nil) {
                        NSString *text =
                        [self textFromAttributedString:attributedString
                                               atRange:effectiveRange];
                        lastContentParagraph.text =
                        [lastContentParagraph.text stringByAppendingString:text];
                    } else {
                        NSString *text =
                        [self textFromAttributedString:attributedString atRange:effectiveRange];

                        BLUContentParagraph *paragraph =
                        [BLUContentParagraph paragraphWithText:text];

                        [paragraphs addObject:paragraph];
                        lastContentParagraph = paragraph;
                    }
                } else {
                    BLUImageRes *imageRes =
                    [self imageResFromAttributedString:attributedString
                                               atRange:effectiveRange];
                    if (imageRes) {
                        BLUContentParagraph *paragraph =
                        [BLUContentParagraph paragraphWithImageRes:imageRes];

                        [paragraphs addObject:paragraph];
                        lastContentParagraph = nil;
                    }
                }
            }

            index = effectiveRange.location + effectiveRange.length;

        } while (index < textRange.length);
    }
    return paragraphs;
}

- (NSArray *)tagTitlesFromTags:(NSArray *)tags {
    NSMutableArray *tagTitles = [NSMutableArray new];
    for (BLUPostTag *tag in tags) {
        BLUAssertObjectIsKindOfClass(tag, [BLUPostTag class]);
        NSString *tagTitle = tag.title;
        [tagTitles addObject:tagTitle];
    }
    return tagTitles;
}

- (NSString *)textFromAttributedString:(NSAttributedString *)attributedString atRange:(NSRange)range {
    NSAttributedString *attrText = [attributedString attributedSubstringFromRange:range];
    NSString *text = attrText.string;
    return text;
}

- (BLUImageRes *)imageResFromAttributedString:(NSAttributedString *)attributedString atRange:(NSRange)range {
    __block BLUImageRes *imageRes = nil;
    [attributedString enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

        NSTextAttachment *attachment = attrs[NSAttachmentAttributeName];

        UIImage *image = nil;
        if (attachment.image) {
            image = attachment.image;
        } else if (attachment.fileWrapper) {
            NSData *imageData = attachment.fileWrapper.regularFileContents;
            image = [UIImage imageWithData:imageData];
        } else {
            image = nil;
        }

        NSString *name = [[NSUUID UUID] UUIDString];

        if (image && name) {
            imageRes = [[BLUImageRes alloc] initWithImage:image name:name];
            *stop = YES;
        }
    }];
    return imageRes;
}

- (void)mergeImageReses:(NSArray *)imageReses toParagraphs:(NSArray *)paragraphs {
    for (BLUContentParagraph *paragraph in paragraphs) {
        for (BLUImageRes *imageRes in imageReses) {
            if ([paragraph.imageRes.name isEqualToString:imageRes.name]) {
                paragraph.imageRes.imageID = imageRes.imageID;
            }
        }
    }
}

@end
