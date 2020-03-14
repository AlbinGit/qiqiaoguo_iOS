//
//  BLUVideoIndicatorImageView.h
//  Blue
//
//  Created by Bowen on 4/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUVideoIndicatorImageView : UIImageView

@property (nonatomic, strong) UIImageView *videoIndicator;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) BOOL showVideoIndicator;

@end
