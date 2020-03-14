//
//  BLUUserCoinViewModel.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserCoinViewModel.h"
#import "BLUApiManager+User.h"

@interface BLUUserCoinViewModel ()

@property (nonatomic, strong) BLUPagination *coinNewbieRulesPagination;
@property (nonatomic, strong) BLUPagination *coinDailyRulesPagination;
@property (nonatomic, strong) BLUPagination *coinLogsPagination;

@property (nonatomic, strong) NSMutableArray *mutableNewbieRules;
@property (nonatomic, strong) NSMutableArray *mutableDailyRules;
@property (nonatomic, strong) NSMutableArray *mutableCoinLogs;

@end

@implementation BLUUserCoinViewModel

- (BLUPagination *)coinNewbieRulesPagination {
    if (_coinNewbieRulesPagination == nil) {
        _coinNewbieRulesPagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _coinNewbieRulesPagination;
}

- (BLUPagination *)coinDailyRulesPagination {
    if (_coinDailyRulesPagination == nil) {
        _coinDailyRulesPagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _coinDailyRulesPagination;
}

- (BLUPagination *)coinLogsPagination {
    if (_coinLogsPagination == nil) {
        _coinLogsPagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _coinLogsPagination;
}

- (NSMutableArray *)mutableNewbieRules {
    if (_mutableNewbieRules == nil) {
        _mutableNewbieRules = [NSMutableArray new];
    }
    return _mutableNewbieRules;
}

- (NSMutableArray *)mutableDailyRules {
    if (_mutableDailyRules == nil) {
        _mutableDailyRules = [NSMutableArray new];
    }
    return _mutableDailyRules;
}

- (NSMutableArray *)mutableCoinLogs {
    if (_mutableCoinLogs == nil) {
        _mutableCoinLogs = [NSMutableArray new];
    }
    return _mutableCoinLogs;
}

- (RACSignal *)fetchCoinNewbieRules {
    self.coinNewbieRulesPagination.page = BLUPaginationPageBase;
    [self.mutableNewbieRules removeAllObjects];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchCoinNewbieRulesWithPagination:self.coinNewbieRulesPagination] doNext:^(NSArray *rules) {
        @strongify(self);
        if (rules.count > 0) {
            [self.mutableNewbieRules addObjectsFromArray:rules];
            self.coinNewbieRules = self.mutableNewbieRules;
            self.coinNewbieRulesPagination.page++;
        }
    }];
}

- (RACSignal *)fetchCoinDailyRules {
    self.coinDailyRulesPagination.page = BLUPaginationPageBase;
    [self.mutableDailyRules removeAllObjects];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchCoinDailyRulesWithPagination:self.coinDailyRulesPagination] doNext:^(NSArray *rules) {
        @strongify(self);
        if (rules.count > 0) {
            [self.mutableDailyRules addObjectsFromArray:rules];
            self.coinDailyRules = self.mutableDailyRules;
            self.coinDailyRulesPagination.page++;
        }
    }];
}

- (RACSignal *)fetchCoinLogs {
    self.coinLogsPagination.page = BLUPaginationPageBase;
    [self.mutableCoinLogs removeAllObjects];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchCoinLogsWithPagination:self.coinLogsPagination] doNext:^(NSArray *logs) {
        @strongify(self);
        if (logs.count > 0) {
            [self.mutableCoinLogs addObjectsFromArray:logs];
            self.coinLogs = self.mutableCoinLogs;
            self.coinLogsPagination.page++;
        }
    }];
}

- (RACSignal *)fetchNextCoinLogs {
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchCoinLogsWithPagination:self.coinLogsPagination] doNext:^(NSArray *logs) {
        @strongify(self);
        if (logs.count > 0) {
            [self.mutableCoinLogs addObjectsFromArray:logs];
            self.coinLogs = self.mutableCoinLogs;
            self.coinLogsPagination.page++;
        }
    }];
}

@end
