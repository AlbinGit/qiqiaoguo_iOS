//
//  QGGoodsMO+CoreDataProperties.h
//  qiqiaoguo
//
//  Created by cws on 16/8/4.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QGGoodsMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGGoodsMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *deliveryType;
@property (nullable, nonatomic, retain) NSNumber *goodID;
@property (nullable, nonatomic, retain) NSNumber *goodsCount;
@property (nullable, nonatomic, retain) NSString *goodsImage;
@property (nullable, nonatomic, retain) NSNumber *inventory;
@property (nullable, nonatomic, retain) NSNumber *isSeckilling;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSString *seckillingNO;
@property (nullable, nonatomic, retain) NSNumber *selected;
@property (nullable, nonatomic, retain) NSNumber *storeID;
@property (nullable, nonatomic, retain) NSString *storeName;
@property (nullable, nonatomic, retain) NSNumber *isBuyNow;

@end

NS_ASSUME_NONNULL_END
