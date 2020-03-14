//
//  BLUPostDetailActionProtocal.h
//  Blue
//
//  Created by Bowen on 7/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUPostDetailActionDelegate <NSObject>

@optional
- (void)shouldLikePost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldDislikePost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldSharePost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldTriggerOtherActionForPost:(NSDictionary *)post fromView:(UIView *)view sender:(id)sender;
- (void)shouldCommentPost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldCollectPost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldCancelCollectPost:(NSDictionary *)postInfo fromView:(UIView *)view sender:(id)sender;

- (void)shouldPlayVideoForPost:(NSDictionary *)postInfo withVideoURL:(NSURL *)videoURL fromView:(UIView *)view sender:(id)sender;

@end
