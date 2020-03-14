//
//  BLUDialogueMO.h
//  
//
//  Created by Bowen on 1/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * BLUDialogueMOKeyLastTime;
UIKIT_EXTERN NSString * BLUDialogueMOKeyFromUserID;

@class BLUDialogue;

@interface BLUDialogueMO : NSManagedObject

- (BLUUser *)fromUser;
- (void)configWithDialogue:(BLUDialogue *)dialogue;
- (BOOL)isEqualToDialogue:(BLUDialogue *)dialogue;

@end

NS_ASSUME_NONNULL_END

#import "BLUDialogueMO+CoreDataProperties.h"
