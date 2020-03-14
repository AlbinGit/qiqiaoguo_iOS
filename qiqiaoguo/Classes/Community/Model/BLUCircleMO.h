//
//  BLUCircleMO.h
//  
//
//  Created by Bowen on 24/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * BLUCircleMOKeyDidFollowCircle;
UIKIT_EXTERN NSString * BLUCircleMOKeyPriority;
UIKIT_EXTERN NSString * BLUCircleMOKeyCircleID;

@class BLUCircle;

@interface BLUCircleMO : NSManagedObject

- (void)configCircleMOWithCircle:(BLUCircle *)circle;
- (void)updateFromCircle:(BLUCircle *)circle;
- (void)resetUnreadPostCount;
//+ (BLUCircleMO *)savetyInsertCircle:(BLUCircle *)circle withUserID:(NSInteger)userID;
+ (BLUCircleMO *)circleMOFromCircleID:(NSInteger)circleID userID:(NSInteger)userID;
+ (BLUCircleMO *)circleMOFromCircle:(BLUCircle *)circle userID:(NSInteger)userID;

@end

NS_ASSUME_NONNULL_END

#import "BLUCircleMO+CoreDataProperties.h"
