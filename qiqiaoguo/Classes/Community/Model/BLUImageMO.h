//
//  BLUImageMO.h
//  
//
//  Created by Bowen on 22/1/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLUImageMO : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)configureWithImageRes:(BLUImageRes *)imageRes;

@end

NS_ASSUME_NONNULL_END

#import "BLUImageMO+CoreDataProperties.h"
