//
//  BLUAdTransitionProtocal.h
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUAd;
@class BLUPostTag;

@protocol BLUAdTransitionDelegate <NSObject>

@optional
- (void)shouldTransitWithAd:(BLUAd *)ad fromView:(UIView *)view sender:(id)sender;

- (void)shouldTransitWithPostTag:(BLUPostTag *)ptag fromView:(UIView *)view sender:(id)sender;

- (void)shouldTransMoreTagFromView:(UIView *)view sender:(id)sender;

@end
