//
//  QGHttpDownload+Education.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGHttpDownload+Education.h"
#import "QGSearchOrgModel.h"


@implementation QGHttpManager (Education)
+ (void)eudactionDataSuccess:(void (^)(QGCategroyResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    QGEudCategoryHttpDownload *param = [[ QGEudCategoryHttpDownload alloc] init];
    
    param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    
    [self getWithUrl:param.path param:param resultClass:[QGCategroyResultModel class] success:success failure:failure];
 
}


+ (void)courseInfoWithParam:(QGHttpDownload *)param success:(void (^)(QGCourseInfoResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:param.path param:param resultClass:[QGCourseInfoResultModel class] success:success failure:failure];
    
}
+ (void)courseTeatherInfoWithParam:(QGOrgTeacherHttpDownload  *)param success:(void (^)(QGOrgTeacherListResultModel *result))success failure:(void (^)(NSError *error))failure{
  [self getWithUrl:param.path param:param resultClass:[QGOrgTeacherListResultModel class] success:success failure:failure];
  }

/**
 * 全部课程
 */
+ (void)courseAllCourseInfoWithParam:(QGOrgCourseHttpDownload  *)param success:(void (^)( QGOrgAllCourseModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:param.path param:param resultClass:[QGOrgAllCourseModel class] success:success failure:failure];
    
}

+ (void)courseDetailInfoWithParam:(QGCourseDetailHttpDownload  *)param success:(void (^)(QGCourseDetaiResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    
    [self getWithUrl:param.path param:param resultClass:[QGCourseDetaiResultModel  class] success:success failure:failure];
    
}

+ (void)eudactionListDataWithParam:(QGGetGoodsListByCategoryIdHttpDownload *)param Success:(void (^)(QGCategroyGoodsListResultModel *result))success failure:(void (^)(NSError *error))failure{
    
 [self getWithUrl:param.path param:param resultClass:[QGCategroyGoodsListResultModel class] success:success failure:failure];
}



+(void)eudhomeDataSuccess:(void (^)(QGEduHomeResult *result))success failure:(void (^)(NSError *error))failure{
       QGEducationMainHttpDownload *param = [[QGEducationMainHttpDownload alloc] init];
    param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
      [self getWithUrl:param.path param:param resultClass:[QGEduHomeResult class] success:success failure:failure];
}


+ (void)courseOrgFirstWithParam:(QGQrgHttpDownload *)param success:(void (^)(QGOrgfirstResultModel *result))success failure:(void (^)(NSError *error))failure{
    
     [self getWithUrl:param.path param:param resultClass:[QGOrgfirstResultModel class] success:success failure:failure];
}

+ (void)teacherDetailsWithParam:(QGTeacherHttpDownload *)param success:(void (^)(QGEduTeacherDetailResultModel *result))success failure:(void (^)(NSError *error))failure{
    [self getWithUrl:param.path param:param resultClass:[QGEduTeacherDetailResultModel class] success:success failure:failure];
}

// 用户关注的课程
+ (void)getUserCourseListWithURL:(NSString *)url Page:(NSInteger)page success:(void (^)( QGOrgAllCourseModel *result))success failure:(void (^)(NSError *error))failure{
    
    [self getWithUrl:url param:@{@"page":@(page)} resultClass:[QGOrgAllCourseModel class] success:success failure:failure];
    
}

// 用户关注的老师
+ (void)getUserTeacherListWithURL:(NSString *)url Page:(NSInteger)page  success:(void (^)( QGOrgTeacherListResultModel *result))success failure:(void (^)(NSError *error))failure{
        [self getWithUrl:url param:@{@"page":@(page)} resultClass:[QGOrgTeacherListResultModel class] success:success failure:failure];
}

// 用户关注的机构
+ (void)getUserOrganizaListWithURL:(NSString *)url Page:(NSInteger)page  success:(void (^)(NSDictionary *result))success failure:(void (^)(NSError *error))failure{
    [self get:url params:@{@"page":@(page)} success:^(id responseObj) {
        success(responseObj);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
