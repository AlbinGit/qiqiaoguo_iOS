//
//  BLUPostTagSearchViewModel.m
//  Blue
//
//  Created by Bowen on 4/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagSearchViewModel.h"
#import "BLUApiManager+Post.h"

@interface BLUPostTagSearchViewModel ()

@property (nonatomic, strong, readwrite) NSArray *tags;

@end

@implementation BLUPostTagSearchViewModel

- (RACSignal *)searchKeyword:(NSString *)keyword {
    @weakify(self);
    return [[[[BLUApiManager sharedManager] searchTagWithKeyword:keyword] throttle:0.5] doNext:^(id x) {
        @strongify(self);
        self.tags = x;
    }];
}

@end
