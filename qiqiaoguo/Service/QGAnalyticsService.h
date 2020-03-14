//
//  QGAnalyticsService.h
//  qiqiaoguo
//
//  Created by cws on 16/6/6.
//
//

#import <Foundation/Foundation.h>

@interface QGAnalyticsService : NSObject
+ (void)config;

+ (void)beginLogPageViewWithClass:(Class)viewClass name:(NSString *)name;
+ (void)endLogPageViewWithClass:(Class)viewClass name:(NSString *)name;

+ (void)addOnlineConfigObserver:(id)observer selector:(SEL)aSelector;
@end
