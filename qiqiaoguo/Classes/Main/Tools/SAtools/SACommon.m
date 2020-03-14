//
//  SACommon.m
//  SalesAssistant
//
//  Created by 杨常勇 on 15/5/11.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "SACommon.h"

@implementation SACommon
+ (CGRect)rectForString:(NSString *)aStr
{
    CGRect rect = [aStr boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil];
    
    return rect;
}
//根据字号计算字体高度
+ (CGRect)rectForString:(NSString *)bStr withFont:(int)font
{
    CGRect rect = [bStr boundingRectWithSize:CGSizeMake(1000, 200) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}
+ (BOOL)propertyForString:(NSString *)str
{
    if(str)
    {
        for (int i=0; i<str.length; i++)
        {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[str substringWithRange:range];
            const char *cString=[subString UTF8String];
            if (strlen(cString)==3)
            {
               return YES;
            }
        }
    }
    return NO;
}
+ (BOOL)checkUpTheStringLength:(NSString *)str
{
    if(str.length<2||str.length>8)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"不要输入低于2个或者高于8个" message:@"您输入的格式有误，请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}
//转换成字母
+ (NSString *)conversionFirstChar:(NSString *)charName
{
    if ([self propertyForString:charName])
    {
        //转换字符串
        CFStringRef aCFString = (__bridge CFStringRef)charName;
        //copy 一下，另外改为可变的
        CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, aCFString);
        //翻译一下，改为拼音（带音调的）：shí jiā zhuāng shì
        CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
        //去声调！！！：shi jia zhuang shi
        CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
        
        //转化为oc：NSString
        NSString *str = (__bridge NSString *)string;
        
        NSString *str2=[str uppercaseString];
        NSString *str3=[str2 substringToIndex:1];
        return str3;
    }
    return @"#";
}



//创建头像存储文件件
+ (void)createHeaderImageCachePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/headerImage/",[self getDocumentPath]];
   
    if(![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentPath = [paths objectAtIndex:0];
    return documentPath;
}

+ (NSString *)getHeaderImageCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentPath = [paths objectAtIndex:0];

    NSString *path = [NSString stringWithFormat:@"%@/headerImage/",documentPath];
    return path;
}

@end
