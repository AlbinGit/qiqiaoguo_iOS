//
//  BLUPostDetailViewModel.h
//  Blue
//
//  Created by Bowen on 25/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@class BLUPost;

@interface BLUPostDetailViewModel : BLUViewModel

@property (nonatomic, copy) BLUPost *post;
@property (nonatomic, assign) NSInteger postID;

@property (nonatomic, weak) RACDisposable *fetchDisposable;

- (RACSignal *)fetch;

@end
