//
//  QGAddressModel.m
//  qiqiaoguo
//
//  Created by cws on 16/7/27.
//
//

#import "QGAddressModel.h"
#import "BLUAddressManager.h"

@implementation QGAddressModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{@"province":              @"province",
      @"city":                  @"city",
      @"area":                  @"area",
      @"addressID":             @"id",
      @"phone":                 @"tel",
      @"details":               @"address",
      @"contact":               @"username",
      @"idCard":                @"card_number",
      };
}



- (NSString *)provinceDetail {
    return [[self manager] districtWithDistrictID:self.provinceID];
}

- (NSString *)cityDetail {
    return [[self manager] districtWithDistrictID:self.cityID];
}

- (NSString *)areaDetail {
    return [[self manager] districtWithDistrictID:self.countyID];
}

- (NSString *)fullAddress {
    NSMutableString *address = [NSMutableString string];
    
//    if (self.provinceID.integerValue == self.cityID.integerValue) {
//        [address appendFormat:@"%@ %@ ", self.province, self.county];
//    } else {
    if (self.provinceDetail == nil) {
        [address appendFormat:@"%@ %@ %@ ", self.province, self.city, self.area];
    }else{
        [address appendFormat:@"%@ %@ %@ ", self.provinceDetail, self.cityDetail, self.areaDetail];
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
