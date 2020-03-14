//
//  BLUSwitchSettingCell.h
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"

@class  BLUSettingSwitchCell;

@protocol BLUSettingSwitchCellDelegate <NSObject>

- (void)settingSwitchCell:(BLUSettingSwitchCell *)settingSwitchCell didChangeSwitchValue:(UISwitch *)settingSwitch;

@end

@interface BLUSettingSwitchCell : BLUCell

@property (nonatomic, weak) id <BLUSettingSwitchCellDelegate> delegate;
@property (nonatomic, strong) UISwitch *passcodeSwitch;
@property (nonatomic, assign) BOOL showSolidLine;

@end
