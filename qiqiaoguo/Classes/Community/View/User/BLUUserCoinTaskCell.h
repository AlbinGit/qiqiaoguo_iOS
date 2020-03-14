//
//  BLUUserCoinTaskCell.h
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"

@interface BLUUserCoinTaskCell : BLUCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *coinIcon;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) BLUSolidLine *topLine;
@property (nonatomic, strong) BLUSolidLine *bottomLine;

@end
