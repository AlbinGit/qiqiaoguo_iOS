//
//  QGOrgAllCourseModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import "QGOrgAllCourseModel.h"
#import "QGCourseInfoModel.h"
@implementation QGOrgAllCourseModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"items":@"QGCourseInfoModel"};
}

@end

