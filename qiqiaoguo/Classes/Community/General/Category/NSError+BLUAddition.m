//
//  NSError+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "NSError+BLUAddition.h"

@implementation NSError (BLUAddition)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason {
    NSMutableDictionary *info = nil;
    if ([description length] > 0 || [reason length] > 0) {
        info = [NSMutableDictionary dictionaryWithCapacity:2];
        if ([description length] > 0) [info setObject:description forKey:NSLocalizedDescriptionKey];
        if ([reason length] > 0) [info setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    }
    return [self errorWithDomain:domain code:code userInfo:info];
}

@end
