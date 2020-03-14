//
//  SAAppUtils.m
//  SalesAssistant
//
//  Created by Albin on 15/1/28.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "SAAppUtils.h"

@implementation SAAppUtils

+ (SALabel *)createGreenLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = GREEN;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

+ (SALabel *)createBlackLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = PL_COLOR_black;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

+ (SALabel *)createGrayDarkLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = GRAYDark;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

+ (SALabel *)createGrayLightLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = GRAYLight;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

+ (SALabel *)createGreenDarkLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = GREENDark;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

+ (SALabel *)createGreenLightLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = GREENLight;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

+ (SALabel *)createWhiteLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

+ (SALabel *)createOrangeLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = PL_COLOR_orange;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

+ (SALabel *)createRedLabel
{
    SALabel *label = [[SALabel alloc]init];
    label.textColor = PL_COLOR_red;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = FONT_SYSTEM(12);
    return label;
}

+ (SAButton *)createCornerGreenButton
{
    SAButton *button = [SAButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = K_ButtonBackColor_LightGreen;
    [button setNormalTitleColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = kCornerRadius;
    return button;
}

+ (SAButton *)createCornerButtonWithColor:(SAButtonColorType)type
{
    SAButton *button = [SAButton buttonWithType:UIButtonTypeCustom];
    if (type == SAButtonColorDarkGreenType)
    {
        button.backgroundColor = K_ButtonBackColor_DarkGreen;
    }else if(type == SAButtonColorLightGreenType){
        button.backgroundColor = K_ButtonBackColor_LightGreen;
    }else if(type == SAButtonColorOrangeType){
        button.backgroundColor = K_ButtonBackColor_Orange;
    }else if(type == SAButtonColorRedType){
        button.backgroundColor = K_ButtonBackColor_Red;
    }
    [button setNormalTitleColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = kCornerRadius;
    return button;
}

+ (SAButton *)createCornerPinkButton
{
    SAButton *button = [SAButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = PL_UTILS_COLORRGB(228, 118, 121);
    [button setNormalTitleColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = kCornerRadius;
    return button;
}

+ (SAButton *)createCommonButton
{
    SAButton *button = [SAButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setNormalTitleColor:kButtonTitleColor];
    PL_ADDCORNER(button)
    return button;
}

// 月月-日日 时时-分分
+ (NSString *)getDateStringYMHMwithString:(NSString *)string
{
    if(string.length > 0)
    {
        NSArray *tempArray = [string componentsSeparatedByString:@" "];
        if([tempArray count] > 1)
        {
            NSString *ymdString = tempArray[0];
            NSString *hmsString = tempArray[1];
            
            NSArray *ymdArray = [ymdString componentsSeparatedByString:@"-"];
            NSArray *hsmArray = [hmsString componentsSeparatedByString:@":"];
            if([ymdArray count] > 2 && [hsmArray count] > 2)
            {
                NSString *resultString = [NSString stringWithFormat:@"%@-%@ %@:%@",ymdArray[1],ymdArray[2],hsmArray[0],hsmArray[1]];
                return resultString;
            }
        }
    }
    return @"";
}

@end
