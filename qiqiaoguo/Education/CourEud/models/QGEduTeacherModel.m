//
//  QGEduTeacherModel.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGEduTeacherModel.h"

@implementation QGEduTeacherModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tagList":@"QGsearchOrgTagmodel"};
}

- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return [NSString stringWithFormat:@"我在七巧国发现了一位好老师：%@",self.name];
}

- (NSString *)shareContent {
    return self.signature;
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



@implementation QGEduTeacherDetailResultModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"courseList":@"QGEduCoursedeilModel"};
    
}

@end
@implementation QGEduCoursedeilModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tagList":@"QGsearchOrgTagmodel"};
}

@end