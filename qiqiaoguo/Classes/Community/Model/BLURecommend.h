//
//  BLURecommend.h
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//


#import "BLUObject.h"
#import "BLUPageRedirection.h"
#import "BLURedirectObject.h"

@class BLURecommendData;

@interface BLURecommend : BLURedirectObject

@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, strong, readonly) BLURecommendData *data;

@end

#ifdef BLUDebug

@interface BLURecommend (Test)

+ (BLURecommend *)testRecommend;

@end

#endif
