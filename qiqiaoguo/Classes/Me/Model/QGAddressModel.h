//
//  QGAddressModel.h
//  qiqiaoguo
//
//  Created by cws on 16/7/27.
//
//

#import "QGModel.h"

@interface QGAddressModel : QGModel

@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *area;
@property (nonatomic ,copy) NSString *provinceDetail;
@property (nonatomic ,copy) NSString *cityDetail;
@property (nonatomic ,copy) NSString *areaDetail;
@property (nonatomic, strong) NSNumber *provinceID;
@property (nonatomic, strong) NSNumber *cityID;
@property (nonatomic, strong) NSNumber *countyID;

@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSNumber *addressID;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *fullAddress;
@property (nonatomic, copy) NSString *idCard;

+ (NSUInteger)districtLevel;

@end
