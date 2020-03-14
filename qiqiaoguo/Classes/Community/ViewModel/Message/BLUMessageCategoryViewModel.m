//
//  BLUMessageCategoryViewModel.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUMessageCategoryViewModel.h"
#import "BLUApiManager+MessageCategory.h"
#import "BLUMessageCategory.h"
#import "BLUMessageCategoryMO.h"

@interface BLUMessageCategoryViewModel ()

@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, strong) BLUPagination *pagination;
@property (nonatomic, assign, readwrite) BLUMessageCategoryViewModelState state;

@end

@implementation BLUMessageCategoryViewModel

- (instancetype)init{
    if (self = [super init]) {
//        _fetchedResultsControllerDelegate = delegate;
        _state = BLUMessageCategoryViewModelStateNormal;
        return self;
    }
    return nil;
}

- (void)fetch {
    [self.fetchDisposable dispose];
    self.state = BLUMessageCategoryViewModelStateFetching;
    @weakify(self);
        self.fetchDisposable = [[[[BLUApiManager sharedManager] fetchMessageCategories] retry:3]
         subscribeNext:^(NSArray *categories) {
            @strongify(self);
            self.state = BLUMessageCategoryViewModelStateNormal;
            self.MessageArray = categories;
             if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextComplete:)]) {
                 [self.delegate viewModelDidFetchNextComplete:self];
             }
         } error:^(NSError *error) {
            @strongify(self);
            BLULogError(@"Error = %@", error);
            self.state = BLUMessageCategoryViewModelStateFetchFailed;
             if ([self.delegate respondsToSelector:@selector(viewModelDidFetchNextFailed:error:)]) {
                 [self.delegate viewModelDidFetchNextFailed:self error:error];
             }
             
        }];

}



@end
