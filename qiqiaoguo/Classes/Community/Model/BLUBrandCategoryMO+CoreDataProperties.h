//
//  BLUBrandCategoryMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 17/2/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUBrandCategoryMO.h"

NS_ASSUME_NONNULL_BEGIN

@class BLUBrandMO;

@interface BLUBrandCategoryMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *categoryID;
@property (nullable, nonatomic, retain) NSNumber *hot;
@property (nullable, nonatomic, retain) NSNumber *logoHeight;
@property (nullable, nonatomic, retain) NSString *logoOriginURL;
@property (nullable, nonatomic, retain) NSString *logoThumbURL;
@property (nullable, nonatomic, retain) NSNumber *logoWidth;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *parentID;
@property (nullable, nonatomic, retain) NSSet<BLUBrandMO *> *brands;

@end

@interface BLUBrandCategoryMO (CoreDataGeneratedAccessors)

- (void)addBrandsObject:(BLUBrandMO *)value;
- (void)removeBrandsObject:(BLUBrandMO *)value;
- (void)addBrands:(NSSet<BLUBrandMO *> *)values;
- (void)removeBrands:(NSSet<BLUBrandMO *> *)values;

@end

NS_ASSUME_NONNULL_END
