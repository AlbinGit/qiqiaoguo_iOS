//
//  BLUCoinNewBieRule.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCoinNewBieRule.h"

@implementation BLUCoinNewBieRule

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":      @"action_title",
             @"finished":   @"finished",
             @"desc":       @"description",
             @"profit":   @"quantity",
             };
}

@end
