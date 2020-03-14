//
//  BLUImageMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 2/2/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUImageMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUImageMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) id image;
@property (nullable, nonatomic, retain) NSNumber *imageID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) id originURL;
@property (nullable, nonatomic, retain) id thumbnailURL;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSNumber *order;

@end

NS_ASSUME_NONNULL_END
