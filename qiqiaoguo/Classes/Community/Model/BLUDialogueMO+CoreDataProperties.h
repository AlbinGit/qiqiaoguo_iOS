//
//  BLUDialogueMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 1/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUDialogueMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUDialogueMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *dialogueID;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSDate *lastTime;
@property (nullable, nonatomic, retain) NSNumber *unreadCount;
@property (nullable, nonatomic, retain) NSString *lastMessage;
@property (nullable, nonatomic, retain) NSNumber *fromUserID;
@property (nullable, nonatomic, retain) NSString *fromUserNickname;
@property (nullable, nonatomic, retain) NSNumber *fromUserGender;
@property (nullable, nonatomic, retain) NSString *fromUserThumbnailAvatarURL;
@property (nullable, nonatomic, retain) NSNumber *masterUserID;

@end

NS_ASSUME_NONNULL_END
