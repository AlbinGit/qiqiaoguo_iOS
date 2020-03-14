//
//  BLUCircleViewModel.h
//  Blue
//
//  Created by Bowen on 25/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUFetchCircleType) {
    BLUFetchCircleTypeOne = 0,
    BLUFetchCircleTypeRecommended,
    BLUFetchCircleTypeFollowed,
    BLUFetchCircleTypeAll,
};

@class BLUCircle;

@interface BLUCircleViewModel : BLUViewModel

@property (nonatomic, copy, readonly) BLUCircle *circle;
@property (nonatomic, assign) NSInteger circleID;
@property (nonatomic, strong) BLUUser *user;
@property (nonatomic, copy) NSArray *circles;
@property (nonatomic, assign, readonly) BLUFetchCircleType fetchCircleType;

@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, weak) RACDisposable *fetchNextDisposable;

- (instancetype)initWithFetchCircleType:(BLUFetchCircleType)type;

- (RACSignal *)fetch;
- (RACSignal *)fetchNext;

@end
