//
//  BLUMessageMO.h
//  
//
//  Created by Bowen on 30/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BLUMessageHeader.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * BLUMessageMOEntityName;
UIKIT_EXTERN NSString * BLUMessageMOKeyOrderIndex;

@class BLUUser, BLUMessage;

@interface BLUMessageMO : NSManagedObject

- (void)configMessageMOWithMessage:(BLUMessage *)message;
- (BLUUser *)fromUser;
- (BLUUser *)toUser;

@end

NS_ASSUME_NONNULL_END

#import "BLUMessageMO+CoreDataProperties.h"
