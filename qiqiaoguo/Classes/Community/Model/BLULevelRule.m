//
//  BLULevelRules.m
//  Blue
//
//  Created by Bowen on 16/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLULevelRule.h"

@implementation BLULevelRule

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":      @"action_title",
             @"desc":       @"description",
             @"exp":        @"quantity",
             };
}

- (NSString *)expDesc {
    return [self symbleInt:self.exp];
}

@end
