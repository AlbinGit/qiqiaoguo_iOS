//
//  QGHttpManager+Search.m
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGHttpManager+Search.h"
#import "QGSearchScreeningModel.h"

#define QGHotCourseTag      (BLUApiString(@"/Phone/Search/getHotCourse"))
#define QGHotOrgTag         (BLUApiString(@"/Phone/Search/getHotOrg"))
#define QGHotGoodsTag       (BLUApiString(@"/Phone/Search/getHotGoods"))
//#define QGHotTeacherTag       (BLUApiString(@"/Phone/Search/getHotTeacher"))

#define QGCourseScreening      (BLUApiString(@"/Phone/Edu/getCourseFilter"))
#define QGOrgScreening        (BLUApiString(@"/Phone/Edu/getOrgFilter"))

#define QGCourseList        (BLUApiString(@"/Phone/Edu/getCourseList"))
#define QGOrgList           (BLUApiString(@"/Phone/Edu/getOrgList"))
#define QGGoodsList         (BLUApiString(@"/Phone/Mall/getMallIndex"))
//#define QGTeacherList           (BLUApiString(@"/Phone/Edu/getOrgTeacher"))

@implementation QGHttpManager (Search)

+ (void)getSearchHotTagWithSearchOptionType:(QGSearchOptionType)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSString *URL = nil;
    if (type == QGSearchOptionTypeCourse) {
        URL = QGHotCourseTag;
    }else if (type == QGSearchOptionTypeInstitution){
        URL = QGHotOrgTag;//机构
//        URL = QGTeacherList;

    }else{
        URL = QGHotGoodsTag;
    }
    
    [self GET:URL params:@{@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}

+ (void)getScreeningDataWithSearchOptionType:(QGSearchOptionType)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSString *URL = nil;
    if (type == QGSearchOptionTypeCourse) {
        URL = QGCourseScreening;
    }else{
        URL = QGOrgScreening;
    }
    
    [self GET:URL params:@{@"platform_id":PLATFORMID} resultClass:[QGSearchScreeningModel class] objectKeyPath:QGApiObjectKeyExtra success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
}

+ (void)getSearchResultsWithSearchOptionType:(QGSearchOptionType)type keyword:(NSString *)keyword page:(NSInteger)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSString *URL = nil;
    if (type == QGSearchOptionTypeCourse) {
        URL = QGCourseList;
    }else if (type == QGSearchOptionTypeInstitution){
        URL = QGOrgList;
    }else{
        URL = QGGoodsList;
    }
    if (page < 1) {
        page = 1;
    }
    
    [self GET:URL params:@{@"platform_id":PLATFORMID,@"page":@(page),@"keyword":keyword} resultClass:nil objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
        
    }];
    
}


@end
