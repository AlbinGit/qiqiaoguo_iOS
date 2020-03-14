//
//  QGHttpDownload+Education.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGHttpDownload+Education.h"

@implementation QGHttpManager (Education)
+ (void)eudactionDataSuccess:(void (^)(QGCategroyResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    QGEudCategoryHttpDownload *param = [[ QGEudCategoryHttpDownload alloc] init];
    
    param.sid =GETSID;
    
    [self getWithUrl:param.path param:param resultClass:[QGCategroyResultModel class] success:success failure:failure];
 
}


+ (void)eudactionListDataWithParam:(QGGetGoodsListByCategoryIdHttpDownload *)param Success:(void (^)(QGCategroyGoodsListResultModel *result))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *params = [param mj_keyValues];
    
    
    [self get:param.path params:params success:^(id responseObj) {
        if (success) {
            id resultobj = [QGCategroyGoodsListResultModel mj_objectWithKeyValues:responseObj[@"content"][@"list"]];
            NSLog(@"ssssre %@ %@",responseObj,resultobj);
            
            success(resultobj);
            [[SAProgressHud sharedInstance] removeHudFromSuperView];
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
            [[SAProgressHud sharedInstance] removeHudFromSuperView];
        }
    }];
}


+ (void)courseInfoWithParam:(QGSeacherCourseHttpDownload *)param success:(void (^)(QGCourseInfoResultModel *result))success failure:(void (^)(NSError *error))failure{
 
    
    [self postWithUrl:param.path param:param resultClass:[QGCourseInfoResultModel class] success:success failure:failure];
 
}






@end
