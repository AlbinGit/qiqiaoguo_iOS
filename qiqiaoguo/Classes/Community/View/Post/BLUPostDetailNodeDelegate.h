//
//  ASPostDetailNodeDelegate.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BLUContentParagraph.h"

@class BLUPost;
@class BLUPostDetailNode;
@class BLUPostTag;
@class BLUCircle;
@class BLUUser;


@protocol BLUPostDetailNodeDelegate <NSObject>

@optional

- (void)shouldUpdateLikeStateForPost:(BLUPost *)post
                                from:(BLUPostDetailNode *)node
                              sender:(id)sender;

- (void)shouldShowTagDetailForTag:(BLUPostTag *)tag
                             from:(BLUPostDetailNode *)node
                           sender:(id)sender;

- (void)shouldShowImagesForParagraphs:(NSArray *)paragraphs
                              atIndex:(NSInteger)index
                                 from:(BLUPostDetailNode *)node
                               sender:(id)sender;

- (void)shouldShowImage:(UIImage *)image
                   from:(BLUPostDetailNode *)node
                 sender:(id)sender;

- (void)shouldShowUserDetail:(BLUUser *)user
                        from:(BLUPostDetailNode *)node
                      sender:(id)sender;

- (void)shouldShowLikedUsersForPost:(BLUPost *)post
                               From:(BLUPostDetailNode *)node
                             sender:(id)sender;

- (void)shouldShowWebDetailForURL:(NSURL *)url
                             from:(BLUPostDetailNode *)node
                           sender:(id)sender;

- (void)shouldShowTagDetailWithTagID:(NSInteger)tagID
                                from:(BLUPostDetailNode *)node
                              sender:(id)sender;

- (void)shouldShowCircleDetailForCircleID:(NSInteger)circleID
                                   from:(BLUPostDetailNode *)node
                                 sender:(id)sender;

- (void)shouldShowPostDetailForPostID:(NSInteger)postID
                               from:(BLUPostDetailNode *)node
                             sender:(id)sender;

- (void)shouldPlayVideoWithURL:(NSURL *)URL
                          from:(BLUPostDetailNode *)node
                        sender:(id)sender;

- (void)shouldShowOtherVCWithType:(BLUContentParagraphRedirectType)type ObjectID:(NSInteger)objectID;

@end
