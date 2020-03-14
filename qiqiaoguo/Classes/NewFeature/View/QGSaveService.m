//
//  QGSaveService.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/26.
//
//

#import "QGSaveService.h"



@implementation QGSaveService

+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}

@end
