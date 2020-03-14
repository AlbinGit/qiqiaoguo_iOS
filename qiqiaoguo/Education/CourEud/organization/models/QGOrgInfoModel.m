//
//  QGOrgInfoModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import "QGOrgInfoModel.h"
#import "QGEduTeacherModel.h"
@implementation QGOrgInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tagList":@"QGsearchOrgTagmodel"};
}
- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return @"我在七巧国发现了一个不错的机构:";
}

- (NSString *)shareContent {
    return self.name;
}

- (NSURL *)shareImageURL {
    return [NSURL URLWithString:self.head_img];
}

- (NSURL *)shareRedirectURL {
    
    return [NSURL URLWithString:self.sharUrl];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}

@end
@implementation QGOrgfirstResultModel

+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"courseList":@"QGEduCoursedeilModel",@"teacherList":@"QGTeacherListModel"};
}

@end