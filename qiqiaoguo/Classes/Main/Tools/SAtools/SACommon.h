//
//  SACommon.h
//  SalesAssistant
//
//  Created by 杨常勇 on 15/5/11.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SACommon : NSObject
+ (CGRect)rectForString:(NSString *)aStr;
+ (CGRect)rectForString:(NSString *)bStr withFont:(int)font;
+ (BOOL)propertyForString:(NSString *)str;
+ (BOOL)checkUpTheStringLength:(NSString *)str;
+ (void)createHeaderImageCachePath;
+ (NSString *)getDocumentPath;
+ (NSString *)getHeaderImageCachePath;
+ (NSString *)conversionFirstChar:(NSString *)charName;//获取首字母

@end
