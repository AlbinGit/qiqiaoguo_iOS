//
//  BLUMessageCategoryMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 23/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUMessageCategoryMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUMessageCategoryMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *lastTime;
@property (nullable, nonatomic, retain) NSNumber *masterUserID;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *unreadCount;
@property (nullable, nonatomic, retain) NSNumber *targetUserID;
@property (nullable, nonatomic, retain) NSString *targetUserNickname;
@property (nullable, nonatomic, retain) NSNumber *targetUserGender;
@property (nullable, nonatomic, retain) NSString *targetUserThumbnailAvatar;

@end

NS_ASSUME_NONNULL_END
