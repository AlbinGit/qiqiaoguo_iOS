//
//  BLUUserTransitionProtocal.h
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUUserTransitionDelegate <NSObject>

@optional
- (void)shouldTransitToUser:(NSDictionary *)userInfo fromView:(UIView *)view sender:(id)sender;

@end
