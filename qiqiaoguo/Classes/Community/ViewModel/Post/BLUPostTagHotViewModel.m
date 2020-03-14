//
//  BLUTagHotViewModel.m
//  Blue
//
//  Created by Bowen on 4/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagHotViewModel.h"
#import "BLUApiManager+Post.h"

@interface BLUPostTagHotViewModel ()

@property (nonatomic, strong, readwrite) NSArray *tags;

@end

@implementation BLUPostTagHotViewModel

- (RACSignal *)fetch {
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchHotTags] doNext:^(id x) {
        @strongify(self);
        self.tags = x;
    }];
}

@end
