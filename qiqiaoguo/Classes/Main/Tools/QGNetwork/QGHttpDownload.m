//
//  SAHttpDownload.m
//  AFNetworkingTestDemo
//
//  Created by Albin on 14-8-18.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"
#import "NSObject+Log.h"
#import "SAUserDefaults.h"
#import "NSString+Hashing.h"

@implementation QGHttpDownload

- (id)init
{
    self = [super init];
    if(self)
    {
        _mapDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSString *)method
{
    return @"GET";
}

- (NSString *)path
{
    return nil;
}

- (NSMutableDictionary *)params
{
    //获取网络请求的属性
    NSArray *array = [self getPropertyNameArray];
    if([array count] == 0)
    {
        return nil;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *sessionId =[SAUserDefaults getValueWithKey:USERDEFAULTS_SESSIONId];
    // 本项目请求网络用参数
    NSString *version = PL_UTILS_VERSION;
    [dict setObject:version forKey:@"version"];
    [dict setObject:@"ios" forKey:@"client_type"];
    // 本项目请求网络用参数
       if(sessionId.length > 0)
    {
        [dict setObject:sessionId forKey:@"sessionId"];

    }
    for (NSString *propertyName in array)
    {
        NSString *paramValue = [self valueForKey:propertyName];
        paramValue = [QGCommon isNumber:paramValue];
        if(paramValue.length > 0)
        {
            if([_mapDict objectForKey:propertyName])
            {
                [dict setObject:paramValue forKey:[_mapDict objectForKey:propertyName]];
            }
            else
            {
                [dict setObject:paramValue forKey:propertyName];
            }
            NSLog(@"key-->%@",propertyName);
            NSLog(@"value-->%@",[self valueForKey:propertyName]);
        }
    }
    return dict;
}

- (NSMutableDictionary *)paramsDic
{
    //获取网络请求的属性
    NSArray *array = [self getPropertyNameArray];
    if([array count] == 0){
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSString *propertyName in array){
        NSString *paramValue = [self valueForKey:propertyName];
        if(paramValue.length > 0){
            if([_mapDict objectForKey:propertyName]){
                [dict setObject:paramValue forKey:[_mapDict objectForKey:propertyName]];
            }else{
                [dict setObject:paramValue forKey:propertyName];
            }
        }
    }
    return dict;
}

@end

@implementation SAUploadModel

@end

