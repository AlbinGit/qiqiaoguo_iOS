//
//  BLUPostTagDetailBarView.h
//  Blue
//
//  Created by Bowen on 10/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUPostTag;

@interface BLUPostTagDetailBarView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) BLUPostTag *postTag;
@property (nonatomic, assign) CGFloat displayProgress;
@property (nonatomic, assign) CGFloat statusBarOffset;

@end
