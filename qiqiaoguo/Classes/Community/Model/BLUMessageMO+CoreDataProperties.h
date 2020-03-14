//
//  BLUMessageMO+CoreDataProperties.h
//  qiqiaoguo
//
//  Created by cws on 16/7/31.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUMessageMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUMessageMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *audioURL;
@property (nullable, nonatomic, retain) NSString *audioUUID;
@property (nullable, nonatomic, retain) NSNumber *contentType;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *fromUserGender;
@property (nullable, nonatomic, retain) NSNumber *fromUserID;
@property (nullable, nonatomic, retain) NSString *fromUserNickname;
@property (nullable, nonatomic, retain) NSString *fromUserThumbnailAvatarURL;
@property (nullable, nonatomic, retain) NSNumber *imageHeight;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *imageUUID;
@property (nullable, nonatomic, retain) NSNumber *imageWidth;
@property (nullable, nonatomic, retain) NSNumber *messageID;
@property (nullable, nonatomic, retain) NSNumber *orderIndex;
@property (nullable, nonatomic, retain) NSNumber *redirectID;
@property (nullable, nonatomic, retain) NSNumber *redirectType;
@property (nullable, nonatomic, retain) NSNumber *remoteState;
@property (nullable, nonatomic, retain) NSNumber *showSendTime;
@property (nullable, nonatomic, retain) NSNumber *styleType;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *toUserID;
@property (nullable, nonatomic, retain) NSString *videoURL;
@property (nullable, nonatomic, retain) NSString *videoUUID;
@property (nullable, nonatomic, retain) NSString *idTitle;

@end

NS_ASSUME_NONNULL_END
