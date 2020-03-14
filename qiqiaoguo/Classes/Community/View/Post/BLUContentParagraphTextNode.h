//
//  BLUContentParagraphTextNode.h
//  Blue
//
//  Created by Bowen on 18/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASTextNode.h"

@class BLUContentParagraph, BLUCircle;

@interface BLUContentParagraphTextNode : ASTextNode

- (void)addTitle:(NSString *)title;
- (void)addParagraph:(BLUContentParagraph *)paragraph;
- (void)addTags:(NSArray *)tags;
- (void)addCircle:(BLUCircle *)circle;

@end

@interface BLUContentParagraphTextNode (Delegate) <ASTextNodeDelegate>

@end
