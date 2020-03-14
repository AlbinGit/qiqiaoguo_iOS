//
//  BLURecommendData.h
//  Blue
//
//  Created by Bowen on 3/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLURecommendData : BLUObject

@property (nonatomic, strong, readonly) NSNumber *collectionCount;
@property (nonatomic, strong, readonly) NSNumber *accessCount;
@property (nonatomic, strong, readonly) NSNumber *postCount;
@property (nonatomic, strong, readonly) NSNumber *heat;
@property (nonatomic, strong, readonly) NSNumber *commentCount;
@property (nonatomic, strong, readonly) NSNumber *likeCount;
@property (nonatomic, strong, readonly) NSNumber *isVideo;

@end
