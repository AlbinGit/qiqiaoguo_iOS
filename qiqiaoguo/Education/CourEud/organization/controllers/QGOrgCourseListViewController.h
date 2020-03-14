//
//  QGOrgListViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/17.
//
//

#import "QGViewController.h"

typedef NS_ENUM(NSUInteger, QGCourseListType) {
    QGCourseListTypeCollection,
    QGCourseListTypeParticipate,
};

@interface QGOrgCourseListViewController : QGViewController

@property (nonatomic ,assign)QGCourseListType type;

@end
