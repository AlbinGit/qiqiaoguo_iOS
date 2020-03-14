//
//  BLUAdViewModel.m
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAdViewModel.h"
#import "BLUApiManager+Ad.h"
#import "BLUApiManager+Post.h"

@interface BLUAdViewModel ()

@property (nonatomic, strong, readwrite) NSArray *ads;
@property (nonatomic, assign) BLUADFor adFor;

@end

@implementation BLUAdViewModel

#pragma mark - BLUViewModel

- (instancetype)init {
    return [self initWithADFor:BLUADForHome];
}

- (instancetype)initWithADFor:(BLUADFor)adFor {
    if (self = [super init]) {
        _adFor = adFor;
        return self;
    }
    return nil;
}

#pragma mark - Fetch

- (RACSignal *)makeFetchSignal {
    RACSignal *fetchSignal = nil;
    switch (_adFor) {
        case BLUADForHome: {
            fetchSignal = [[BLUApiManager sharedManager] fetchHomeAD];
        } break;
        case BLUADForCircle: {
            fetchSignal = [[BLUApiManager sharedManager] fetchCircleAD];
        } break;
    }
    return fetchSignal;
}

- (RACSignal *)fetch {
    [self.fetchDisposable dispose];
    RACSignal *fetchSignal = [self makeFetchSignal];
    @weakify(self);
    return [fetchSignal doNext:^(NSArray *ads) {
        @strongify(self);
        self.ads = ads;
    }];
}




@end
