//
//  BLUUserCoinViewModel.h
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUUserCoinViewModel : BLUViewModel

@property (nonatomic, strong) NSArray *coinNewbieRules;
@property (nonatomic, strong) NSArray *coinDailyRules;
@property (nonatomic, strong) NSArray *coinLogs;

- (RACSignal *)fetchCoinNewbieRules;
- (RACSignal *)fetchCoinDailyRules;

- (RACSignal *)fetchCoinLogs;
- (RACSignal *)fetchNextCoinLogs;

@end
