//
//  BLUContentParagraphMO.h
//  
//
//  Created by Bowen on 22/1/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class BLUContentParagraph;

@interface BLUContentParagraphMO : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)configureWithContentParagraph:(BLUContentParagraph *)paragraph;

@end

NS_ASSUME_NONNULL_END

#import "BLUContentParagraphMO+CoreDataProperties.h"
