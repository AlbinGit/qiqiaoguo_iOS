//
//  BLUBrandCategoryMO.h
//  
//
//  Created by Bowen on 19/1/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "BLUToyHomeGuideItemModel.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const NSInteger BLUBrandCategoryMOTotalRankCategoryID;
UIKIT_EXTERN const NSInteger BLUBrandCategoryMONoParentID;

@class BLUBrandCategory;

@interface BLUBrandCategoryMO : NSManagedObject //<BLUToyHomeGuideItemModel>

- (void)configureWithBrandCategory:(BLUBrandCategory *)category;
- (BLUImageRes *)logo;

@end

NS_ASSUME_NONNULL_END

#import "BLUBrandCategoryMO+CoreDataProperties.h"
