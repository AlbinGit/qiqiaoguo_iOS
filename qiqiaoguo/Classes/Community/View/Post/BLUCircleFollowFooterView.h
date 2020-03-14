//
//  BLUCircleFollowFooterView.h
//  Blue
//
//  Created by Bowen on 11/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUCircleFollowFooterViewDelegate.h"

@interface BLUCircleFollowFooterView : UIView

@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, assign) BOOL didFollow;

@property (nonatomic, weak) id <BLUCircleFollowFooterViewDelegate> delegate;

@end
