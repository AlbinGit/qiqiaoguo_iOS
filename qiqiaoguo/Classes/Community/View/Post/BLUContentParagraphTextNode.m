//
//  BLUContentParagraphTextNode.m
//  Blue
//
//  Created by Bowen on 18/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUContentParagraphTextNode.h"

static const NSString * BLUContentParagraphContentName = @"BLUContentParagraphContentName";
static const NSString * BLUContentParagraphTitleName = @"BLUContentParagraphTitleName";
static const NSString * BLUContentParagraphImageName = @"BLUContentParagraphImageName";
static const NSString * BLUContentParagraphImageURLName = @"BLUContentParagraphImageURLName";
static const NSString * BLUContentParagraphTagName = @"BLUContentParagraphTagName";

@interface BLUContentParagraphTextNode ()

@end

@implementation BLUContentParagraphTextNode

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)addTitle:(NSString *)title {

}

- (void)addParagraph:(BLUContentParagraph *)paragraph {

}

- (void)addTags:(NSArray *)tags {

}

- (void)addCircle:(BLUCircle *)circle {

}

@end

@implementation BLUContentParagraphTextNode (Delegate)

- (void)textNodeTappedTruncationToken:(ASTextNode *)textNode {

}

- (void)textNode:(ASTextNode *)textNode
tappedLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point
       textRange:(NSRange)textRange {

}

- (void)textNode:(ASTextNode *)textNode
longPressedLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point
       textRange:(NSRange)textRange {

}

- (BOOL)textNode:(ASTextNode *)textNode
shouldHighlightLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point {
    return YES;
}

- (BOOL)textNode:(ASTextNode *)textNode
shouldLongPressLinkAttribute:(NSString *)attribute
           value:(id)value
         atPoint:(CGPoint)point {
    return YES;
}

@end
