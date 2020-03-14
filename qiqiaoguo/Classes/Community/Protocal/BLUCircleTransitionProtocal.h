//
//  BLUCircleTransitionProtocal.h
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUCircleTransitionDelegate <NSObject>

@optional
- (void)shouldTransitToCircle:(NSDictionary *)circleInfo fromView:(UIView *)view sender:(id)sender;

@end
