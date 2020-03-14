//
//  BLUUserProfit.m
//  Blue
//
//  Created by Bowen on 17/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserProfit.h"

@implementation BLUUserProfit

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":      @"action_title",
             @"coin":       @"coin",
             @"exp":        @"experience",
             };
}

- (NSString *)coinDesc {
    return [self symbleInt:self.coin];
}

- (NSString *)expDesc {
    return [self symbleInt:self.exp];
}

@end
