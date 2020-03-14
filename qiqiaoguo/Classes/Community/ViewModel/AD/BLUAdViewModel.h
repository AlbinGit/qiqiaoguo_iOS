//
//  BLUAdViewModel.h
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUADFor) {
    BLUADForHome = 1,
    BLUADForCircle,
};

@interface BLUAdViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSArray *ads;
@property (nonatomic, weak) RACDisposable *fetchDisposable;

- (instancetype)initWithADFor:(BLUADFor)adFor;

- (RACSignal *)fetch;



@end
