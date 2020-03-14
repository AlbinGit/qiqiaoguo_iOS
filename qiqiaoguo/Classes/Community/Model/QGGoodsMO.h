//
//  QGGoodsMO.h
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN
@class QGShopCarModel;
@interface QGGoodsMO : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)configureWithGood:(QGShopCarModel *)CarModel;

@end

NS_ASSUME_NONNULL_END

#import "QGGoodsMO+CoreDataProperties.h"
#import "QGShopCarModel.h"
