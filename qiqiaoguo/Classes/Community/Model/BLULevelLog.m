//
//  BLUExpLog.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLULevelLog.h"

@implementation BLULevelLog

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":      @"action_title",
             @"createDate": @"create_date",
             @"exp":        @"quantity",
             };
}

@end
