//
//  BLUBrand.m
//  Blue
//
//  Created by Bowen on 14/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUBrand.h"

@implementation BLUBrand

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"brandID":    @"brand_id",
      @"name":       @"title",
      @"initials":   @"pinyin",
      @"logo":       @"logo"};
}

+ (NSValueTransformer *)logoJSONTransformer {
    return [self imageResJSONTransformer];
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
