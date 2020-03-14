//
//  BLUServerNotificationMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 5/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUServerNotificationMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUServerNotificationMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *didRead;
@property (nullable, nonatomic, retain) NSNumber *masterUserID;
@property (nullable, nonatomic, retain) NSNumber *notificationID;
@property (nullable, nonatomic, retain) NSNumber *objID;
@property (nullable, nonatomic, retain) NSNumber *photoHeight;
@property (nullable, nonatomic, retain) NSString *photoOriginURL;
@property (nullable, nonatomic, retain) NSString *photoThumbnailURL;
@property (nullable, nonatomic, retain) NSNumber *photoWidth;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *webURL;
@property (nullable, nonatomic, retain) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
