//
//  SAAppUtils.h
//  SalesAssistant
//
//  Created by Albin on 15/1/28.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SALabel;
@class SAButton;

// 枚举
typedef NS_ENUM(NSInteger, SAButtonColorType)
{
    SAButtonColorDarkGreenType = 0,
    SAButtonColorLightGreenType,
    SAButtonColorRedType,
    SAButtonColorOrangeType
};



@interface SAAppUtils : NSObject

+ (SALabel *)createGreenLabel;
+ (SALabel *)createBlackLabel;
+ (SALabel *)createGrayDarkLabel;
+ (SALabel *)createGrayLightLabel;
+ (SALabel *)createGreenDarkLabel;
+ (SALabel *)createGreenLightLabel;
+ (SALabel *)createWhiteLabel;
+ (SALabel *)createOrangeLabel;
+ (SALabel *)createRedLabel;

+ (SAButton *)createCornerGreenButton;
+ (SAButton *)createCornerPinkButton;
+ (SAButton *)createCommonButton;

+ (SAButton *)createCornerButtonWithColor:(SAButtonColorType)type;

// 月月-日日 时时-分分
+ (NSString *)getDateStringYMHMwithString:(NSString *)string;

@end
