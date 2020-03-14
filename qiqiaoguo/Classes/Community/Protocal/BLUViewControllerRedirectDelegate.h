//
//  BLUViewControllerRedirectDelegate.h
//  Blue
//
//  Created by Bowen on 30/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@protocol BLUCircleTransitionDelegate <NSObject>
//
//@optional
//- (void)shouldTransitToCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender;
//
//@end

#import <UIKit/UIKit.h>

@class BLUPost, BLUCircle;

@protocol BLUViewControllerRedirectDelegate <NSObject>

@optional

- (void)shouldRedirectToPost:(BLUPost *)post fromView:(UIView *)view sender:(id)sender;
- (void)shouldRedirectToPostWithPostID:(NSInteger)postID fromView:(UIView *)view sender:(id)sender;

- (void)shouldRedirectToCircle:(BLUCircle *)circle fromView:(UIView *)view sender:(id)sender;
- (void)shouldRedirectToCircleWithCircleID:(NSInteger)circleID fromView:(UIView *)view sender:(id)sender;

- (void)shouldRedirectToWebWithURL:(NSURL *)url fromView:(UIView *)view sender:(id)sender;
- (void)shouldRedirectToWebWithURL:(NSURL *)url title:(NSString *)title fromView:(UIView *)view sender:(id)sender;

@end

