//
//  QGCoursDetailModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/28.
//
//

#import "QGCoursDetailModel.h"

@implementation QGCoursDetailModel

+ (NSDictionary *)mj_objectClassInArray {


    return @{@"tagList":@"QGCourseDeilTag",@"sectionList":@"QGCourseDetSectionListModel"};

}

- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return @"我在七巧国发现了一个不错的课程，感兴趣的朋友快来报名吧！";
}

- (NSString *)shareContent {
    return self.title;
}

- (NSURL *)shareImageURL {
    return [NSURL URLWithString:self.cover_path];
}

- (NSURL *)shareRedirectURL {
    
    return [NSURL URLWithString:self.sharUrl];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}






@end
@implementation QGCourseDetaiResultModel

//
//+ (NSDictionary *)mj_objectClassInArray {
//    
//    
//    
//    
//}

@end

@implementation QGCourseDeilTag



@end
@implementation QGCourseDetSectionListModel



@end