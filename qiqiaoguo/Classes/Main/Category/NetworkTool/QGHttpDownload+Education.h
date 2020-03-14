//
//  QGHttpDownload+Education.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGHttpManager.h"
#import "QGEudCategoryHttpDownload.h"
#import "QGGetGoodsListByCategoryIdHttpDownload.h"
#import "QGSeacherCourseHttpDownload.h"

#import "QGCourseInfoResultModel.h"

@interface QGHttpManager (Education)

+ (void)eudactionDataSuccess:(void (^)(QGCategroyResultModel *result))success failure:(void (^)(NSError *error))failure;
+ (void)eudactionListDataWithParam:(QGGetGoodsListByCategoryIdHttpDownload *)param Success:(void (^)(QGCategroyGoodsListResultModel *result))success failure:(void (^)(NSError *error))failure;


+ (void)courseInfoWithParam:(QGSeacherCourseHttpDownload *)param success:(void (^)(QGCourseInfoResultModel *result))success failure:(void (^)(NSError *error))failure;


@end
