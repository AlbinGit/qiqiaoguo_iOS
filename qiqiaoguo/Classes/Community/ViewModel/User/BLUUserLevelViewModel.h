//
//  BLUUserLevelViewModel.h
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUUserLevelViewModel : BLUViewModel

@property (nonatomic, strong) NSArray *levelRules;
@property (nonatomic, strong) NSArray *levelLogs;
@property (nonatomic, strong) NSArray *levelSpecs;

- (RACSignal *)fetchLevelRules;
- (RACSignal *)fetchLevelSpecs;

- (RACSignal *)fetchLevelLogs;
- (RACSignal *)fetchNextLevelLogs;

@end
