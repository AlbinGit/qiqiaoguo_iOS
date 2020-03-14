//
//  BLUAddress.h
//  Blue
//
//  Created by Bowen on 26/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUAddress : BLUObject

@property (nonatomic, strong) NSNumber *addressID;
@property (nonatomic, strong) NSNumber *provinceID;
@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSNumber *countyID;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *details;

+ (NSUInteger)districtLevel;

@end

@interface BLUAddress (Desc)

@property (nonatomic, strong, readonly) NSString *province;
@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *county;
@property (nonatomic, strong, readonly) NSString *fullAddress;

@end
