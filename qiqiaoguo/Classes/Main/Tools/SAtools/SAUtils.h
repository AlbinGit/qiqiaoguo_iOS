//
//  SAUtils.h
//  SaleAssistant
//
//  Created by Albin on 14-8-27.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SAUtils : NSObject

// 数字月份转汉字
+ (NSString *)monthNumToText:(NSInteger)num;

// 获取对象下的所有属性和属性内容
+ (NSDictionary *)getModelAllAttr:(id)obj;
// 获取对象下的所有属性
+ (NSArray *)getModelAllAttrName:(id)obj;

+ (CGSize)getCGSzieWithText:(NSString *)text width:(float)maxwidth height:(float)maxheight font:(UIFont *)font;

// 获得该实例来获取年月日信息
+ (NSDateComponents *)getDateCompontents:(NSString *)date;

// 缩略大图
+ (UIImage *)scaleImage:(UIImage *)image;
// 按照短边压缩占满屏幕
+ (UIImage *)scaleImage:(UIImage *)image shortSide:(CGFloat)shortSide;

+ (NSString *)JsonObjectToString:(id)obj;

+ (NSString *)durationStringWithSeconds:(int)seconds;


// 邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;
// 手机号码验证
+ (BOOL)isValidateMobile:(NSString *)mobile;
//邮编验证
+ (BOOL)isPostCode:(NSString *)postcode;
////身份证验证
//+ (BOOL)isValidateIDCard:(NSString *)IDCard;
//+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+ (BOOL)checkUserIdCard: (NSString *) idCard;


// 得到当前时间戳
+ (NSString *)getTimeInterval;

// 得到view所属viewController
+ (UIViewController *)findViewControllerWithView:(UIView *)view;


// xxxx-xx-xx转成年月日
+ (NSString *)getYearMonthDayWithString:(NSString *)str;
+(NSString *)getYearMonthDayTimeCountWithString:(NSString *)str;
+(NSString *)getYearMonthDayCountWithString:(NSString *)str;
@end
