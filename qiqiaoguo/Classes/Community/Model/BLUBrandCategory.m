//
//  BLUBrandCategory.m
//  Blue
//
//  Created by Bowen on 19/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUBrandCategory.h"

@implementation BLUBrandCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"parentID":          @"parent_id",
      @"categoryID":        @"category_id",
      @"name":              @"title",
      @"logo":              @"logo",
      @"subCategories":     @"sub"};
}

+ (NSValueTransformer *)logoJSONTransformer {
    return [self imageResJSONTransformer];
}

+ (NSValueTransformer *)subCategoriesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *dicts, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[BLUBrandCategory class] fromJSONArray:dicts error:nil];
    } reverseBlock:^id(NSArray *categories, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:categories error:nil];
    }];
}

- (NSNumber *)logoHeight {
    return self.logo ? @(self.logo.height) : nil;
}

- (NSNumber *)logoWidth {
    return self.logo ? @(self.logo.width) : nil;
}

- (NSString *)logoOriginURL {
    return self.logo ? self.logo.originURL.absoluteString : nil;
}

- (NSString *)logoThumbURL {
    return self.logo ? self.logo.thumbnailURL.absoluteString : nil;
}

@end
