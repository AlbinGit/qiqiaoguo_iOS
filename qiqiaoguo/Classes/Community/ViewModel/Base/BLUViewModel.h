//
//  BLUViewModel.h
//  Blue
//
//  Created by Bowen on 1/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPagination.h"
#import "BLUViewModelHeader.h"


@interface BLUViewModel : MTLModel

@property (nonatomic, assign, getter = isActive) BOOL active;

@property (nonatomic, strong, readonly) RACSignal *didBecomeActiveSignal;

@property (nonatomic, strong, readonly) RACSignal *didBecomeInactiveSignal;

- (RACSignal *)sendRACError;

@end

@interface BLUViewModel (Fetch)

- (RACSignal *)makeFetchSignalWithSignal:(RACSignal *)signal
                              disposable:(RACDisposable *)disposable
                              pagination:(BLUPagination *)pagination
                            privateItems:(NSMutableArray *)privateItems
                             publicItems:(NSArray *)publicItems;

- (RACSignal *)makeFetchNextSignalWithSignal:(RACSignal *)signal
                                  disposable:(RACDisposable *)disposable
                                  pagination:(BLUPagination *)pagination
                                privateItems:(NSMutableArray *)privateItems
                                 publicItems:(NSArray *)publicItems;

@end
