//
//  QGOrgInfoModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import <Foundation/Foundation.h>
#import "BLUShareObject.h"

@class QGOrgInfoModel ;
@interface QGOrgfirstResultModel : NSObject


@property (nonatomic,strong) QGOrgInfoModel *item;

@property (nonatomic,strong) NSArray *teacherList;
@property (nonatomic,strong) NSArray *courseList;


@end






@interface QGOrgInfoModel : NSObject <BLUShareObject>

/**机构ID*/
@property (nonatomic,copy)NSString *org_id;
/**机构名称*/
@property (nonatomic,copy)NSString *name;
/**机构简称*/
@property (nonatomic,copy)NSString *name_short;
/**头像*/
@property (nonatomic,copy)NSString *head_img;
@property (nonatomic,copy)NSString *bg_img ;
@property (nonatomic,strong) NSArray *tagList;
/**省*/
@property (nonatomic,copy)NSString *province;
/**城市*/
@property (nonatomic,copy)NSString *city;
/**区*/
@property (nonatomic,copy)NSString *area;
/**地址*/
@property (nonatomic,copy)NSString *address;

@property (nonatomic,copy) NSString *org_address;
/**经纬度*/
@property (nonatomic,copy)NSString *longlat;
@property (nonatomic,copy)NSString *licence_number;
/**签名*/
@property (nonatomic,copy)NSString *signature;
/**介绍*/
@property (nonatomic,copy)NSString *intro;
@property (nonatomic,copy)NSString *note;
/**1认证，0无认证*/
@property (nonatomic,copy)NSString *licence_audit;
/**课程总数*/
@property (nonatomic,copy)NSString *course_count;
/**教师总数*/
@property (nonatomic,copy)NSString *teacher_count;
/**评论总数*/
@property (nonatomic,copy)NSString *follower_count;
/**分享url*/
@property (nonatomic,copy)NSString *sharUrl;
/**是否收藏 1=收藏/0=未收藏*/
@property (nonatomic,copy)NSString *isFollowed;
/**机构是否有分店地址列表，1=存在/0=不存在*/
@property (nonatomic, copy) NSString *is_branch;
// 客服ID
@property (nonatomic, assign) NSInteger service_id;

@end
