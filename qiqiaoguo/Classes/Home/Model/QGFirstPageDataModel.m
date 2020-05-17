//
//  MQFirstPageDataModel.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/24.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGFirstPageDataModel.h"
#import "QGPostListModel.h"


@implementation QGFirstPageDataModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"bannerList":@"QGBannerModel",
             @"postList":@"QGPostListModel",
             @"activityList":@"QGEduActivityListModel",
             @"cateList":@"QGEducateListtModel",
             @"courseList":@"QGCourseInfoModel",
             @"videoList":@"QGEduVideoListModel",
             @"teacherList":@"QQGTeacherListModel",
    };
}
@end


@implementation QGBannerModel

@end

@implementation QQGTeacherListModel

@end
