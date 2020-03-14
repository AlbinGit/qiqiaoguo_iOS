//
//  BLUAddress.m
//  Blue
//
//  Created by Bowen on 26/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUAddress.h"
#import "BLUAddressManager.h"

@implementation BLUAddress

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"addressID":             @"address_id",
      @"provinceID":            @"province",
      @"cityID":                @"city",
      @"countyID":              @"county",
      @"contact":               @"name",
      @"details":               @"detail",
      @"phone":                 @"phone"};
}

@end

@implementation BLUAddress (Desc)

- (NSString *)province {
    return [[self manager] districtWithDistrictID:self.provinceID];
}

- (NSString *)city {
    return [[self manager] districtWithDistrictID:self.cityID];
}

- (NSString *)county {
    return [[self manager] districtWithDistrictID:self.countyID];
}

- (NSString *)fullAddress {
    NSMutableString *address = [NSMutableString string];

    if (self.provinceID.integerValue == self.cityID.integerValue) {
        [address appendFormat:@"%@ %@ ", self.province, self.county];
    } else {
        [address appendFormat:@"%@ %@ %@ ", self.province, self.city, self.county];
    }

    [address appendFormat:@"%@", self.details];

    return address;
}

- (BLUAddressManager *)manager {
    return [BLUAddressManager sharedManager];
}

+ (NSUInteger)districtLevel {
    return 3;
}

@end
