//
//  BLUPostActionViewModel.h
//  Blue
//
//  Created by Bowen on 26/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUPostActionViewModel : BLUViewModel

@property (nonatomic, assign) NSInteger postID;

- (RACSignal *)like;
- (RACSignal *)disLike;
- (RACSignal *)collect;
- (RACSignal *)cancelCollect;
- (RACSignal *)comment:(NSString *)comment;

//- (RACSignal *)shareToWechat;
//- (RACSignal *)shareToQQ;
//- (RACSignal *)shareToWeibo;

@end
