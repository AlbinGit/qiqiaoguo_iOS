//
//  BLUUserLevelViewModel.m
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserLevelViewModel.h"
#import "BLUApiManager+User.h"

@interface BLUUserLevelViewModel ()

@property (nonatomic, strong) NSMutableArray *mutableLevelLogs;
@property (nonatomic, strong) NSMutableArray *mutableLevelRules;
@property (nonatomic, strong) NSMutableArray *mutableLevelSpecs;

@property (nonatomic, strong) BLUPagination *levelLogsPagination;
@property (nonatomic, strong) BLUPagination *levelRulesPagination;
@property (nonatomic, strong) BLUPagination *levelSpecsPagination;

@end

@implementation BLUUserLevelViewModel

- (BLUPagination *)levelLogsPagination {
    if (_levelLogsPagination == nil) {
        _levelLogsPagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _levelLogsPagination;
}

- (BLUPagination *)levelRulesPagination {
    if (_levelRulesPagination == nil) {
        _levelRulesPagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _levelRulesPagination;
}

- (BLUPagination *)levelSpecsPagination {
    if (_levelSpecsPagination == nil) {
        _levelSpecsPagination = [[BLUPagination alloc] initWithPerpage:10 group:nil order:BLUPaginationOrderNone];
    }
    return _levelSpecsPagination;
}

- (NSMutableArray *)mutableLevelLogs {
    if (_mutableLevelLogs == nil) {
        _mutableLevelLogs = [NSMutableArray new];
    }
    return _mutableLevelLogs;
}

- (NSMutableArray *)mutableLevelRules {
    if (_mutableLevelRules == nil) {
        _mutableLevelRules = [NSMutableArray new];
    }
    return _mutableLevelRules;
}

- (NSMutableArray *)mutableLevelSpecs {
    if (_mutableLevelSpecs == nil) {
        _mutableLevelSpecs = [NSMutableArray new];
    }
    return _mutableLevelSpecs;
}

- (RACSignal *)fetchLevelLogs {
    self.levelLogsPagination.page = BLUPaginationPageBase;
    [self.mutableLevelLogs removeAllObjects];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchLevelLogsWithPagination:self.levelLogsPagination] doNext:^(NSArray *logs) {
        @strongify(self);
        if (logs.count > 0) {
            [self.mutableLevelLogs addObjectsFromArray:logs];
            self.levelLogs = self.mutableLevelLogs;
            self.levelLogsPagination.page++;
        }
    }];
}

- (RACSignal *)fetchNextLevelLogs {
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchLevelLogsWithPagination:self.levelLogsPagination] doNext:^(NSArray *logs) {
        @strongify(self);
        if (logs.count > 0) {
            [self.mutableLevelLogs addObjectsFromArray:logs];
            self.levelLogs = self.mutableLevelLogs;
            self.levelLogsPagination.page++;
        }
    }];
}

- (RACSignal *)fetchLevelSpecs {
    self.levelSpecsPagination.page = BLUPaginationPageBase;
    [self.mutableLevelSpecs removeAllObjects];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchLevelSpecsWithPagination:self.levelSpecsPagination] doNext:^(NSArray *specs) {
        @strongify(self);
        if (specs.count > 0) {
            [self.mutableLevelSpecs addObjectsFromArray:specs];
            self.levelSpecs = self.mutableLevelSpecs;
            self.levelSpecsPagination.page++;
        }
    }];
}

- (RACSignal *)fetchLevelRules {
    self.levelRulesPagination.page = BLUPaginationPageBase;
    [self.mutableLevelRules removeAllObjects];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchLevelRulesWithPagination:self.levelRulesPagination] doNext:^(NSArray *rules) {
        @strongify(self);
        if (rules.count > 0) {
            [self.mutableLevelRules addObjectsFromArray:rules];
            self.levelRules = self.mutableLevelRules;
            self.levelRulesPagination.page++;
        }
    }];
}



@end
