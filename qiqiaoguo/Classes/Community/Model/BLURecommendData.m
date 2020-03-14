//
//  BLURecommendData.m
//  Blue
//
//  Created by Bowen on 3/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLURecommendData.h"

@implementation BLURecommendData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"collectionCount":       @"collection_count",
      @"accessCount":           @"access_count",
      @"postCount":             @"post_count",
      @"heat":                  @"heat",
      @"commentCount":          @"comment_count",
      @"likeCount":             @"like_count",
      @"isVideo":               @"is_video"};
}

@end
