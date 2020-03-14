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

#import "QGCourseInfoModel.h"

#import "QGSeacherCourseHttpDownload.h"
#import "QGCoursDetailModel.h"
#import "QGEducationMainHttpDownload.h"
#import "QGEduHomeResult.h"
#import "QGCourseDetailHttpDownload.h"

#import "QGOrgInfoModel.h"

#import "QGQrgHttpDownload.h"
#import "QGTeacherHttpDownload.h"
#import "QGOrgTeacherHttpDownload.h"
#import "QGEduTeacherModel.h"
#import "QGOrgCourseHttpDownload.h"
#import "QGOrgAllCourseModel.h"
#import "QGSearchOrgModel.h"


#define QGUserCollectionCourse         (BLUApiString(@"/Phone/User/getFollowingCourseList"))
#define QGUserCollectionTeacher         (BLUApiString(@"/Phone/User/getFollowingTeacherList"))
#define QGUserCollectionOrg         (BLUApiString(@"/Phone/User/getFollowingOrgList"))

@interface QGHttpManager (Education)

+ (void)eudactionDataSuccess:(void (^)(QGCategroyResultModel *result))success failure:(void (^)(NSError *error))failure;//教育分类首页
+ (void)eudactionListDataWithParam:(QGGetGoodsListByCategoryIdHttpDownload *)param Success:(void (^)(QGCategroyGoodsListResultModel *result))success failure:(void (^)(NSError *error))failure;//教育分类列表
+ (void)courseDetailInfoWithParam:(QGCourseDetailHttpDownload  *)param success:(void (^)(QGCourseDetaiResultModel *result))success failure:(void (^)(NSError *error))failure;//课程详情
+ (void)courseInfoWithParam:(QGHttpDownload *)param success:(void (^)(QGCourseInfoResultModel *result))success failure:(void (^)(NSError *error))failure;//搜索
+ (void)courseTeatherInfoWithParam:(QGOrgTeacherHttpDownload  *)param success:(void (^)(QGOrgTeacherListResultModel *result))success failure:(void (^)(NSError *error))failure;//全部老师
+ (void)courseAllCourseInfoWithParam:(QGOrgCourseHttpDownload  *)param success:(void (^)( QGOrgAllCourseModel *result))success failure:(void (^)(NSError *error))failure;//全部课程
+ (void)eudhomeDataSuccess:(void (^)(QGEduHomeResult *result))success failure:(void (^)(NSError *error))failure;//教育首页


+ (void)getUserCourseListWithURL:(NSString *)url Page:(NSInteger)page  success:(void (^)( QGOrgAllCourseModel *result))success failure:(void (^)(NSError *error))failure;// 用户收藏的课程

+ (void)getUserTeacherListWithURL:(NSString *)url Page:(NSInteger)page  success:(void (^)( QGOrgTeacherListResultModel *result))success failure:(void (^)(NSError *error))failure;// 用户关注的老师

+ (void)getUserOrganizaListWithURL:(NSString *)url Page:(NSInteger)page  success:(void (^)(NSDictionary *result))success failure:(void (^)(NSError *error))failure; //用户关注的机构

+ (void)courseOrgFirstWithParam:(QGQrgHttpDownload *)param success:(void (^)(QGOrgfirstResultModel *result))success failure:(void (^)(NSError *error))failure;//机构

+ (void)teacherDetailsWithParam:(QGTeacherHttpDownload *)param success:(void (^)(QGEduTeacherDetailResultModel *result))success failure:(void (^)(NSError *error))failure;//老师详情
@end
