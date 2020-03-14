//
//  BLUCoinDailyRule.h
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUCoinDailyRule : BLUObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) BOOL finished;
@property (nonatomic, copy, readonly) NSString *desc;
@property (nonatomic, assign, readonly) NSInteger profit;

- (NSString *)profitDesc;

@end
