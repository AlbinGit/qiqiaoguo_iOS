//
//  BLUDynamicMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 7/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUDynamicMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUDynamicMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *anonymous;
@property (nullable, nonatomic, retain) NSNumber *commentID;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *dynamicID;
@property (nullable, nonatomic, retain) NSNumber *fromUserGender;
@property (nullable, nonatomic, retain) NSNumber *fromUserID;
@property (nullable, nonatomic, retain) NSString *fromUserNickname;
@property (nullable, nonatomic, retain) NSString *fromUserThumbnailAvatarURL;
@property (nullable, nonatomic, retain) NSNumber *masterUserID;
@property (nullable, nonatomic, retain) NSNumber *postID;
@property (nullable, nonatomic, retain) NSNumber *toUserID;
@property (nullable, nonatomic, retain) NSString *toUserNickname;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *targetUserID;

@end

NS_ASSUME_NONNULL_END
