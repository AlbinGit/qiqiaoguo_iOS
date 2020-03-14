//
//  NSNotification+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "NSNotification+BLUAddition.h"

@implementation NSNotification (BLUAddition)

+ (NSString *)notificationName:(NSString *)name forClass:(Class)cls {
    return [NSString stringWithFormat:@"name-%@", NSStringFromClass(cls)];
}

@end
