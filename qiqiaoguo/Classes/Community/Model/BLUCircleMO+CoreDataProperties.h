//
//  BLUCircleMO+CoreDataProperties.h
//  
//
//  Created by Bowen on 25/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BLUCircleMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLUCircleMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *circleDescription;
@property (nullable, nonatomic, retain) NSNumber *circleID;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSNumber *didFollowCircle;
@property (nullable, nonatomic, retain) NSNumber *followedUserCount;
@property (nullable, nonatomic, retain) NSNumber *isFollowRequesting;
@property (nullable, nonatomic, retain) NSString *logoThumb;
@property (nullable, nonatomic, retain) NSNumber *masterUserID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *postCount;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nullable, nonatomic, retain) NSNumber *shouldVisible;
@property (nullable, nonatomic, retain) NSString *slogan;
@property (nullable, nonatomic, retain) NSNumber *unreadPostCount;

@end

NS_ASSUME_NONNULL_END
