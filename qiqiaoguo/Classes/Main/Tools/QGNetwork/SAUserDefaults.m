//
//  SAUserDefaults.m
//  SaleAssistant
//
//  Created by Albin on 14-10-30.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAUserDefaults.h"

@implementation SAUserDefaults

+ (void)saveValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
    [userDefaults synchronize];
}

+ (id)getValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+ (void)removeWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
}

+ (void)removeAllKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USERDEFAULTS_USERNAME];
}


@end
