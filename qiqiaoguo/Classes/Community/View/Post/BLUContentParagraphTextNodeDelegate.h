//
//  BLUContentParagraphTextNodeDelegate.h
//  Blue
//
//  Created by Bowen on 18/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPost;
@class BLUPostTag;
@class BLUCircle;
@class BLUUser;
@class BLUComment;
@class BLUPostDetailCommentNode;
@class BLUCommentReply;

@class BLUContentParagraphTextNode;

@protocol BLUContentParagraphTextNodeDelegate <NSObject>

- (void)shouldShowTagDetails:(BLUPostTag *)tag fromTextNode:(BLUContentParagraphTextNode *)textNode;
- (void)shouldShowImageDetails:(UIImage *)image fromTextNode:(BLUContentParagraphTextNode *)textNode;
- (void)shouldShowImageURLDetails:(NSURL *)URL fromTextNode:(BLUContentParagraphTextNode *)textNode;
- (void)shouldShowCircleDetails:(BLUCircle *)circle fromTextNode:(BLUContentParagraphTextNode *)textNode;

@end
