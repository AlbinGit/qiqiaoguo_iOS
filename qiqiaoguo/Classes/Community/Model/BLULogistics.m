//
//  BLULogistics.m
//  Blue
//
//  Created by Bowen on 7/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLULogistics.h"
#import "BLULogisticsDetails.h"

@implementation BLULogistics

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"name":      @"express_name",
      @"details":   @"logistics_detail",
      @"logo":      @"logo",
      @"code":      @"logistics_number",
      @"imageCover":@"cover"};
}

+ (NSValueTransformer *)logoJSONTransformer {
    return [self imageResJSONTransformer];
}

+ (NSValueTransformer *)detailsJSONTransformer {
    return [MTLValueTransformer
            transformerUsingForwardBlock:^id(NSArray *contents,
                                             BOOL *success,
                                             NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[BLULogisticsDetails class]
                               fromJSONArray:contents
                                       error:nil];
    } reverseBlock:^id(NSArray *paragraphs ,
                       BOOL *success,
                       NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:paragraphs
                                             error:nil];
    }];
}

@end
