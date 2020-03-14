//
//  QGActivityListViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/17.
//
//

#import "QGViewController.h"

typedef NS_ENUM(NSUInteger, QGActivityType) {
    QGActivityTypeCollection,
    QGActivityTypeParticipate,
};

@interface QGActivityListViewController : QGViewController

@property (nonatomic ,assign)QGActivityType type;

@end
