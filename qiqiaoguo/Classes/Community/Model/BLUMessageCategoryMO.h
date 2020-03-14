//
//  BLUMessageCategoryMO.h
//  
//
//  Created by Bowen on 1/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * BLUMessageCategoryMOKeyType;
UIKIT_EXTERN NSString * BLUMessageCategoryMOKeyMasterUserID;

@class BLUMessageCategory;

@interface BLUMessageCategoryMO : NSManagedObject

- (void)configWithMessageCategory:(BLUMessageCategory *)messageCategory;
- (void)configForDefaultWithType:(NSInteger)type;
- (BLUUser *)targetUser;

@end

NS_ASSUME_NONNULL_END

#import "BLUMessageCategoryMO+CoreDataProperties.h"
