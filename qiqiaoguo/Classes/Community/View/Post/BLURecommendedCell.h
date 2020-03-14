//
//  BLURecommendedCell.h
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"

@class BLURecommend;

@interface BLURecommendedCell : BLUCell

@property (nonatomic, strong) UIImageView *poster;
@property (nonatomic, strong) BLURecommend *recommend;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, assign) CGFloat verticalRatio1;
@property (nonatomic, assign) CGFloat verticalRatio2;
@property (nonatomic, assign) CGFloat elementSpacing;

@end
