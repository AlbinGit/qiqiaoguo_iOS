//
//  BLUContentParagraphMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 2/2/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUContentParagraphMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUContentParagraphMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *contentID;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) id imageURL;
@property (nullable, nonatomic, retain) id pageURL;
@property (nullable, nonatomic, retain) NSNumber *redirectType;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) id videoURL;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSNumber *order;

@end

NS_ASSUME_NONNULL_END
