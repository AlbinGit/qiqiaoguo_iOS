//
//  BLUServerNotificationMO.h
//  
//
//  Created by Bowen on 3/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *BLUServerNotificationMOKeyCreateDate;
UIKIT_EXTERN NSString *BLUServerNotificationMOKeyNotificationID;

@class BLUServerNotification;

@interface BLUServerNotificationMO : NSManagedObject

- (void)configWithServerNotification:(BLUServerNotification *)serverNotification;

@end

NS_ASSUME_NONNULL_END

#import "BLUServerNotificationMO+CoreDataProperties.h"
