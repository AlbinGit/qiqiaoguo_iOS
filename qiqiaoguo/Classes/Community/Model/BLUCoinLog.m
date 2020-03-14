//
//  BLUCoinLog.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCoinLog.h"

@implementation BLUCoinLog

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":      @"action_title",
             @"createDate":       @"create_date",
             @"profit":   @"quantity",
             };
}

- (NSString *)profitDesc {
    return [self symbleInt:self.profit];
}

@end
