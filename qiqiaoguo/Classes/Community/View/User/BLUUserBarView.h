//
//  BLUUserBarView.h
//  Blue
//
//  Created by Bowen on 13/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUUserBarView : UIView

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) CGFloat totalOffset;
@property (nonatomic, assign) CGFloat currentOffset;
@property (nonatomic, strong) BLUUser *user;

@end
