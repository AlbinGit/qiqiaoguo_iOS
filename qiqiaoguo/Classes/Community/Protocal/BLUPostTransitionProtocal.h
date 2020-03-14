//
//  BLUPostTransitionProtocal.h
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

@protocol BLUPostTransitionDelegate <NSObject>

@optional
- (void)shouldTransitToPost:(NSDictionary *)userInfo fromView:(UIView *)view sender:(id)sender;

@end