//
//  BLUBrandMO.h
//  
//
//  Created by Bowen on 14/1/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "BLUToyHomeGuideItemModel.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const NSInteger BLUBrandMOToyHomeFakeID;
UIKIT_EXTERN NSString *const BLUBrandMOToyHomeFakeInitial;
UIKIT_EXTERN NSString *const BLUBrandMOToyHomeReplaceInitial;
UIKIT_EXTERN const NSInteger BLUBrandMOToyHomeFakeSection;

@class BLUBrand;

@interface BLUBrandMO : NSManagedObject //<BLUToyHomeGuideItemModel>

- (void)configureWithBrand:(BLUBrand *)brand;
+ (void)createFaleBrandForToyHomeIfNeeded;
- (BLUImageRes *)logo;

@end

NS_ASSUME_NONNULL_END

#import "BLUBrandMO+CoreDataProperties.h"
