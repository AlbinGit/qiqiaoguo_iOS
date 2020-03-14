//
//  BLUDynamicMO.h
//  
//
//  Created by Bowen on 2/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *BLUDynamicMOKeyCreateDate;
UIKIT_EXTERN NSString *BLUDynamicMOKeyDynamicID;

typedef NS_ENUM(NSInteger, BLUDynamicMOType) {
    BLUDynamicMOTypePost = 1,
    BLUDynamicMOTypeCommentPost = 4,
    BLUDynamicMOTypeLikePost,
    BLUDynamicMOTypeLikeComment,
    BLUDynamicMOTypeReplyComment,
    BLUDynamicMOTypeUserFollow,
    BLUDynamicMOTypePrivateMessage,
};

@class BLUDynamic;

@interface BLUDynamicMO : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)configWithDynamic:(BLUDynamic *)dynamic;

- (BLUUser *)toUser;
- (BLUUser *)fromUser;

@end

NS_ASSUME_NONNULL_END

#import "BLUDynamicMO+CoreDataProperties.h"
