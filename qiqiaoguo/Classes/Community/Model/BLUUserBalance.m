//
//  BLUUserBalance.m
//  Blue
//
//  Created by Bowen on 20/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserBalance.h"

NSString *BLUUserBalanceCoinWarningNotification = @"BLUUserBalanceCoinWarningNotification";

@interface BLUUserBalance ()

@property (nonatomic, assign, readwrite) NSString *coinWarningMessage;

@end

@implementation BLUUserBalance

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"coin":               @"coin",
             @"exp":                @"experience",
             @"level":              @"rank",
             @"coinWarningMessage": @"warning",
             };
}

- (void)checkCoin {
    if (self.coinWarningMessage.length > 0) {
        [self postNotification];
    }
}

- (void)postNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BLUUserBalanceCoinWarningNotification object:self];
}

@end
