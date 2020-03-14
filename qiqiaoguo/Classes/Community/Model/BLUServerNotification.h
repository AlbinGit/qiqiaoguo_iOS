//
//  BLUServerNotification.h
//  Blue
//
//  Created by Bowen on 30/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

typedef NS_ENUM(NSInteger, BLUServerNotificationType) {
    BLUServerNotificationTypeItem = 1,
    QGServerNotificationTypePackage,
    QGServerNotificationTypeBrandSale,
    QGServerNotificationTypeBrand,
    QGServerNotificationTypeClassification = 6,
    QGServerNotificationTypeEducation,
    QGServerNotificationTypeAgency,
    QGServerNotificationTypeTeacher,
    QGServerNotificationTypeCourse,
    QGServerNotificationTypeEduClassification,
    QGServerNotificationTypeActivity,
    QGServerNotificationTypeActivityDetail,
    QGServerNotificationTypeAgencydDetail = 18,
    QGServerNotificationTypeTeacherDetail,
    QGServerNotificationTypeCourseDetail,
    BLUServerNotificationTypePost = 101,
    BLUServerNotificationTypeCircle,
    BLUServerNotificationTypeWeb = 5,
    BLUServerNotificationTypeTag = 111,
};

@interface BLUServerNotification : BLUObject

@property (nonatomic, assign, readonly) NSInteger notificationID;
@property (nonatomic, assign, readonly) NSInteger objectID;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSURL *webURL;
@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) BLUImageRes *photo;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat width;

@property (nonatomic, assign, readonly) BLUServerNotificationType type;

@end
