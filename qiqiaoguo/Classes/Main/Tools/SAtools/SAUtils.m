//
//  SAUtils.m
//  SaleAssistant
//
//  Created by Albin on 14-8-27.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAUtils.h"
#import <objc/runtime.h>

@implementation SAUtils

// 数字月份转汉字
+ (NSString *)monthNumToText:(NSInteger)num
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月", nil];
    return [array objectAtIndex:num - 1];
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date
{
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",    @"丁卯",    @"戊辰",    @"己巳",    @"庚午",    @"辛未",    @"壬申",    @"癸酉",
                             @"甲戌",    @"乙亥",    @"丙子",    @"丁丑", @"戊寅",    @"己卯",    @"庚辰",    @"辛己",    @"壬午",    @"癸未",
                             @"甲申",    @"乙酉",    @"丙戌",    @"丁亥",    @"戊子",    @"己丑",    @"庚寅",    @"辛卯",    @"壬辰",    @"癸巳",
                             @"甲午",    @"乙未",    @"丙申",    @"丁酉",    @"戊戌",    @"己亥",    @"庚子",    @"辛丑",    @"壬寅",    @"癸丑",
                             @"甲辰",    @"乙巳",    @"丙午",    @"丁未",    @"戊申",    @"己酉",    @"庚戌",    @"辛亥",    @"壬子",    @"癸丑",
                             @"甲寅",    @"乙卯",    @"丙辰",    @"丁巳",    @"戊午",    @"己未",    @"庚申",    @"辛酉",    @"壬戌",    @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |   NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%ld_%ld_%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    return chineseCal_str;
}

//获取对象下的所有属性和属性内容
+ (NSDictionary *)getModelAllAttr:(id)obj {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        //获取属性名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [obj valueForKey:(NSString *)propertyName];
        if (propertyValue) [d setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return d;
}

//获取对象下的所有属性
+ (NSArray *)getModelAllAttrName:(id)obj {
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([obj class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    return propertiesArray;
}

+ (NSDateComponents *)getDateCompontents:(NSString *)date
{
    // 2014-08-25 17:39:50
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [dateFormatter dateFromString:date];
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:d];
    return component;
}

// 根据大小算控件宽高
+ (CGSize)getCGSzieWithText:(NSString *)text width:(float)maxwidth height:(float)maxheight font:(UIFont *)font
{
  
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(maxwidth,maxheight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
  

    return textRect.size;
}

// 缩略大图
+ (UIImage *)scaleImage:(UIImage *)image
{
    CGFloat factor;
    if(PL_UTILS_RETAINA4)
    {
        factor = (CGFloat)image.size.width / (CGFloat)(SCREEN_WIDTH * 1.5);
    }
    else
    {
        factor = (CGFloat)image.size.width / (CGFloat)SCREEN_WIDTH;
    }
    CGSize size = CGSizeMake(PL_UTILS_RETAINA4 ? (CGFloat)(SCREEN_WIDTH * 1.5) : (CGFloat)SCREEN_WIDTH, (CGFloat)image.size.height / factor);
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


// 按照短边压缩占满屏幕(缩略图)
+ (UIImage *)scaleImage:(UIImage *)image shortSide:(CGFloat)shortSide
{
    CGSize size;
    if(image.size.width > image.size.height)
    {
        CGFloat factor = image.size.width / shortSide;
        size = CGSizeMake(shortSide, image.size.height / factor);
    }
    else
    {
        CGFloat factor = image.size.height / shortSide;
        size = CGSizeMake(image.size.width / factor, shortSide);
    }
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSString *)JsonObjectToString:(id)obj
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSString *)durationStringWithSeconds:(int)seconds
{
    int degree, minute, second;
    second = (int)seconds % 60;
    minute = ((int)seconds / 60) % 60;
    degree = ((int)seconds / 60 / 60) % 60;
    if(degree > 0)
        return [NSString stringWithFormat:@"%02d:%02d:%02d", degree, minute, second];
    else
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//+ (BOOL)isValidateIDCard:(NSString *)IDCard
//{
//    NSString *Regex = @"^d{15}|d{}18$";
//    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//    return [Test evaluateWithObject:IDCard];
//}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
// 手机号码验证
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
   NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//邮编验证
+ (BOOL)isPostCode:(NSString *)postcode
{
    NSString *phoneRegex = @"^\\d{6}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:postcode];
}
// 得到当前时间戳
+ (NSString *)getTimeInterval
{
    NSDate *date = [NSDate date];
    NSString *time = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];    
    return time;
}

// 得到view所属viewController
+ (UIViewController *)findViewControllerWithView:(UIView *)view
{
    UIView *currentView = view.superview;
    while(currentView)
    {
        UIResponder *responder = [currentView nextResponder];
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
        currentView = currentView.superview;
    }
    return nil;
}


// xxxx-xx-xx转成年月日
+ (NSString *)getYearMonthDayWithString:(NSString *)str {
    if (str.length > 9) {
    //    NSString * year = [str substringWithRange:NSMakeRange(0, 4)];
        NSString * month = [str substringWithRange:NSMakeRange(5, 2)];
        NSString * day = [str substringWithRange:NSMakeRange(8, 2)];
        NSString * newStr = [NSString stringWithFormat:@"%@月%@日",month,day];
        return newStr;
    }
    return nil;
}
// xxxx-xx-xx转成年月日
+ (NSString *)getYearMonthDayCountWithString:(NSString *)str {
    if (str.length > 9) {
         NSString * year = [str substringWithRange:NSMakeRange(0, 4)];
        NSString * month = [str substringWithRange:NSMakeRange(5, 2)];
        NSString * day = [str substringWithRange:NSMakeRange(8, 2)];
        NSString * newStr = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        return newStr;
    }
    return nil;
}
+ (NSString *)getYearMonthDayTimeCountWithString:(NSString *)str {
    if (str.length > 9) {
        NSString * year = [str substringWithRange:NSMakeRange(0, 4)];
        NSString * month = [str substringWithRange:NSMakeRange(5, 2)];
        NSString * day = [str substringWithRange:NSMakeRange(8, 2)];
         NSString *time = [str substringWithRange:NSMakeRange(10, 9)];
        NSString * newStr = [NSString stringWithFormat:@"%@年%@月%@日%@",year,month,day,time];
        return newStr;
    }
    return nil;
}
@end
