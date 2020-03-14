//
//  QGEduHomeResult.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/23.
//
//

#import "QGCourseInfoModel.h"

@implementation QGEduHomeResult


+ (NSDictionary *)objectClassInArray
{
    return @{@"bannerList":@"QGEduBannerListModel",@"cateList":@"QGEducateListtModel",@"activityList":@"QGEduActivityListModel",@"videoList":@"QGEduVideoListModel",@"courseList":@"QGCourseInfoModel"};
}


@end
@implementation QGEduBannerListModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"bannerId":@"id"};
}

@end
@implementation QGEducateListtModel


@end

@implementation QGEduActivityListModel



@end
@implementation QGEduVideoListModel



@end

@implementation QGEduCourseListModel



@end