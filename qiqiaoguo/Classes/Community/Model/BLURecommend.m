//
//  BLURecommend.m
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLURecommend.h"
#import "BLURecommendData.h"

@implementation BLURecommend

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"imageURL":  @"image_url",
        @"width":     @"width",
        @"height":    @"height",

        @"redirectID": @"id",
        @"redirectType": @"type",
        @"redirectURL": @"page_url",
        @"data": @"datas",
    };
}

+ (NSValueTransformer *)dataJSONTransformer {
    return [self makeModelTransformer:[BLURecommendData class]];
}

@end

#ifdef BLUDebug

@implementation BLURecommend (Test)

+ (BLURecommend *)testRecommend {
    return [BLURecommend new];
}

@end

#endif
