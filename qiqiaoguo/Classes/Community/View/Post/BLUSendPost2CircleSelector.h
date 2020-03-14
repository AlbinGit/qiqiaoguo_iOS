//
//  BLUSendPost2CircleSelector.h
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUSendPost2CircleSelectorDelegate.h"

@interface BLUSendPost2CircleSelector : UIButton

@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UILabel *circleLabel;
@property (nonatomic, strong) UIImageView *indicator;
@property (nonatomic, strong) NSString *circleTitle;

@property (nonatomic, weak) id <BLUSendPost2CircleSelectorDelegate> delegate;

@end

