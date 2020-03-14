//
//  BLUBrandMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 15/1/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUBrandMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUBrandMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *brandID;
@property (nullable, nonatomic, retain) NSNumber *fake;
@property (nullable, nonatomic, retain) NSString *initials;
@property (nullable, nonatomic, retain) NSNumber *logoHeight;
@property (nullable, nonatomic, retain) NSString *logoOriginURL;
@property (nullable, nonatomic, retain) NSString *logoThumbURL;
@property (nullable, nonatomic, retain) NSNumber *logoWidth;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *hot;

@end

NS_ASSUME_NONNULL_END
