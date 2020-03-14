//
//  BLUCoinDailyRule.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCoinDailyRule.h"

@implementation BLUCoinDailyRule

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":      @"action_title",
             @"finished":   @"finished",
             @"desc":       @"description",
             @"profit":   @"quantity",
             };
}

- (NSString *)profitDesc {
    return [self symbleInt:self.profit];
}

@end
