//
//  BLUPostDetailNode+Action.m
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailNode+Action.h"
#import "BLUContentParagraph.h"
#import "BLUPost.h"

@implementation BLUPostDetailNode (Action)

- (void)addActionToTextNode:(ASTextNode *)node {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:node];

    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);

    if (paragraph.type == BLUPostParagraphTypeRedirectText) {
        SEL selector = NULL;

        switch (paragraph.redirectType) {
            case BLUContentParagraphRedirectTypePost: {
                selector = @selector(touchAndRedirectToPost:);
            } break;
            case BLUContentParagraphRedirectTypeCircle: {
                selector = @selector(touchAndRedirectToCircle:);
            } break;
            case BLUContentParagraphRedirectTypeWeb: {
                selector = @selector(touchAndRedirectToWeb:);
            } break;
            case BLUContentParagraphRedirectTypeTag: {
                selector = @selector(touchAndRedirectToTag:);
            } break;
        }

        if (selector != NULL) {
            [node addTarget:self
                     action:selector
           forControlEvents:ASControlNodeEventTouchUpInside];
        }
    } else {
        return;
    }
}

- (void)addActionToImageNode:(ASNetworkImageNode *)imageNode {

    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:imageNode];

    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);

    SEL selector;

    if (paragraph.type == BLUPostParagraphTypeImage) {
        selector = @selector(touchAndShowImage:);
    } else if (paragraph.type == BLUPostParagraphTypeVideo) {
        selector = @selector(touchAndPlayVideo:);
    } else if (paragraph.type == BLUPostParagraphTypeRedirectImage) {
        switch (paragraph.redirectType) {
            case BLUContentParagraphRedirectTypePost: {
                selector = @selector(touchAndRedirectToPost:);
            } break;
            case BLUContentParagraphRedirectTypeCircle: {
                selector = @selector(touchAndRedirectToCircle:);
            } break;
            case BLUContentParagraphRedirectTypeWeb: {
                selector = @selector(touchAndRedirectToWeb:);
            } break;
            case BLUContentParagraphRedirectTypeTag: {
                selector = @selector(touchAndRedirectToTag:);
            } break;
            default: {
                selector = @selector(touchAndRedirectToOther:);
            } break;
        }
    } else {
        return;
    }
    BLULogDebug(@"selector = %@", NSStringFromSelector(selector));
    [imageNode addTarget:self
                  action:selector
        forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)touchAndRedirectToWeb:(id)sender {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    BLUParameterAssert(paragraph.redirectType ==
                       BLUContentParagraphRedirectTypeWeb);

    NSURL *url = paragraph.pageURL;

    BLUAssertObjectIsKindOfClass(url, [NSURL class]);

    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowWebDetailForURL:from:sender:)]) {
        [self.delegate shouldShowWebDetailForURL:url
                                            from:self
                                          sender:sender];
    }
}

- (void)touchAndRedirectToPost:(id)sender {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    BLUParameterAssert(paragraph.redirectType ==
                       BLUContentParagraphRedirectTypePost);
    NSInteger postID = paragraph.objectID;

    BLUParameterAssert(postID > 0);

    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowPostDetailForPostID:from:sender:)]) {
        [self.delegate shouldShowPostDetailForPostID:postID
                                                from:self
                                              sender:sender];
    }
}

- (void)touchAndRedirectToTag:(id)sender {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    BLUParameterAssert(paragraph.redirectType == BLUContentParagraphRedirectTypeTag);
    NSInteger tagID = paragraph.objectID;

    BLUParameterAssert(tagID > 0);
    if ([self.delegate respondsToSelector:@selector(shouldShowTagDetailWithTagID:from:sender:)]) {
        [self.delegate shouldShowTagDetailWithTagID:tagID from:self sender:sender];
    }
}

- (void)touchAndRedirectToCircle:(id)sender {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    BLUParameterAssert(paragraph.redirectType ==
                       BLUContentParagraphRedirectTypeCircle);

    NSInteger circleID = paragraph.objectID;

    BLUParameterAssert(circleID > 0);

    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowCircleDetailForCircleID:from:sender:)]) {
        [self.delegate shouldShowCircleDetailForCircleID:circleID
                                                    from:self
                                                  sender:sender];
    }
}

- (void)touchAndRedirectToOther:(id)sender{
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    
    BLUContentParagraphRedirectType type = paragraph.redirectType;
    NSInteger objectID = paragraph.objectID;
    
    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowOtherVCWithType:ObjectID:)]) {
        [self.delegate shouldShowOtherVCWithType:type ObjectID:objectID];
    }

}

- (void)touchAndPlayVideo:(id)sender {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    BLUParameterAssert(paragraph.type == BLUPostParagraphTypeVideo);

    NSURL *videoURL = paragraph.videoURL;

    if ([self.delegate
         respondsToSelector:
         @selector(shouldPlayVideoWithURL:from:sender:)]) {
        [self.delegate shouldPlayVideoWithURL:videoURL
                                         from:self
                                       sender:sender];
    }
}

- (void)touchAndChangeLikeStatePost:(id)sender {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldUpdateLikeStateForPost:from:sender:)]) {
        [self.delegate shouldUpdateLikeStateForPost:self.post
                                               from:self
                                             sender:sender];
    }
}

- (void)touchAndShowImage:(id)sender {
    BLUContentParagraph *paragraph = [self retrieveParagraphFromNode:sender];
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    __block NSInteger index = 0;
    [self.post.paragraphs enumerateObjectsUsingBlock:^(BLUContentParagraph * p, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([p.imageURL isEqual:paragraph.imageURL]) {
            index = idx;
        }
    }];

    if ([self.delegate
         respondsToSelector:
         @selector(shouldShowImagesForParagraphs:atIndex:from:sender:)]) {
        [self.delegate shouldShowImagesForParagraphs:self.post.paragraphs
                                             atIndex:index
                                                from:self
                                              sender:sender];
    }

    if ([sender isKindOfClass:[ASNetworkImageNode class]]) {
        UIImage *image = ((ASNetworkImageNode *)sender).image;
        UIView *view = ((ASNetworkImageNode *)sender).view;
        if (image) {
            if ([self.delegate respondsToSelector:@selector(shouldShowImage:from:sender:)]) {
                [self.delegate shouldShowImage:image from:self sender:view];
            }
            if ([self.showImageDelegate respondsToSelector:@selector(showImage:fromSender:)]) {
                [self.showImageDelegate showImage:image fromSender:view];
            }
        }
    }


}

- (void)touchAndShowUserDetails:(id)sender {
    BLUAssertObjectIsKindOfClass(self.post.author, [BLUUser class]);
    if ([self.delegate
         respondsToSelector:@selector(shouldShowUserDetail:from:sender:)]) {
        [self.delegate shouldShowUserDetail:self.post.author
                                       from:self
                                     sender:sender];
    }
}

- (void)touchAndShowLikedUsers:(id)sender {
    if ([self.delegate
         respondsToSelector:@selector(shouldShowLikedUsersForPost:From:sender:)]) {
        [self.delegate shouldShowLikedUsersForPost:self.post
                                              From:self
                                            sender:sender];
    }
}

@end
