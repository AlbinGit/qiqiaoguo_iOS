//
//  BLUAnalyticsService.h
//  Blue
//
//  Created by Bowen on 20/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUService.h"

@interface BLUAnalyticsService : BLUService

+ (void)config;

+ (void)beginLogPageViewWithClass:(Class)viewClass name:(NSString *)name;
+ (void)endLogPageViewWithClass:(Class)viewClass name:(NSString *)name;

+ (void)addOnlineConfigObserver:(id)observer selector:(SEL)aSelector;

@end