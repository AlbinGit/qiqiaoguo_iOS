//
//  BLUTextFieldContainer.h
//  Blue
//
//  Created by Bowen on 15/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLUTextFieldContaienrAccessoryType) {
    BLUTextFieldContainerAccessoryTypeNone = 0,
    BLUTextFieldContainerAccessoryTypeSecurePassword,
    BLUTextFieldContainerAccessoryTypeSecurityCode,
};

@interface BLUTextFieldContainer : UIView

- (instancetype)initWithTitle:(NSString *)title accessoryType:(BLUTextFieldContaienrAccessoryType)type;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *securityPasswordButton;
@property (nonatomic, strong) UIButton *securityCodeButton;
@property (nonatomic, strong) UIView *CodeButtonLine;

@end
