//
//  QGEduTeacherModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QGEduTeacherModel;
@interface QGEduTeacherDetailResultModel : NSObject

@property (nonatomic,strong) QGEduTeacherModel *item;
@property (nonatomic,strong) NSArray *courseList;

@end




@interface QGEduCoursedeilModel : NSObject
/**机构ID*/
@property (nonatomic,copy)NSString *org_id;
@property (nonatomic, copy) NSString *title;
/**老师姓名*/
@property (nonatomic, copy) NSString *class_price;
/**老师头像*/
@property (nonatomic,copy) NSString *cover_path;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *type;

@end









@interface QGEduTeacherModel : NSObject <BLUShareObject>
/**教师ID*/
@property (nonatomic, copy) NSString *teacher_id;
/**老师姓名*/
@property (nonatomic, copy) NSString *name;
/**老师头像*/
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *bg_img;
@property (nonatomic,copy) NSString *sex;
/**老师头像*/
@property (nonatomic, copy) NSString *head_img;
/**相当于自定义域名，如果没有用ID号传递*/
@property (nonatomic, copy) NSString *teacher_url;
/**分类名称*/
@property (nonatomic, copy) NSString *category_name;
/**分类id*/
@property (nonatomic, copy) NSString *category_id;
/**城市*/
@property (nonatomic, copy) NSString *city;
/**签名*/
@property (nonatomic, copy) NSString *signature;
/**机构ID*/
@property (nonatomic, copy) NSString *org_id;
/**学生总数*/
@property (nonatomic, copy) NSString *student_num;
/**护照认证(1:认证/0:未认证)*/
@property (nonatomic, copy) NSString *is_passport;
/**课程总数*/
@property (nonatomic, copy) NSString *courese_num;
/**老师教龄*/
@property (nonatomic, copy) NSString *teach_experience;
/**地区*/
@property (nonatomic, copy) NSString *area;
/**机构名称*/
@property (nonatomic, copy) NSString *org_name;
/**身份认证(1:认证/0:未认证1)*/
@property (nonatomic, copy) NSString *is_identity;
/**学历认证*/
@property (nonatomic, copy) NSString *is_education;
/**地址*/
@property (nonatomic, copy) NSString *address;
/**评论总数*/
@property (nonatomic, copy) NSString *comment_num;
/**省份*/
@property (nonatomic, copy) NSString *province;
/**好评率*/
@property (nonatomic, copy) NSString *comment_rate;
/**经纬度*/
@property (nonatomic, copy) NSString *longlat;
/**课程时长*/
@property (nonatomic, copy) NSString *class_length;
/**介绍*/
@property (nonatomic, copy) NSString *intro;
/**是否收藏 1=收藏/0=未收藏*/
@property (nonatomic, copy) NSString *isFollowed;
/**分享URL地址*/
@property (nonatomic, copy) NSString *sharUrl;
/**价格*/
@property (nonatomic, copy) NSString *price; 
@property (nonatomic,strong) NSArray *tagList;
/**教师总数*/
@property (nonatomic,copy)NSString *teacher_count;
@property (nonatomic, copy) NSString *service_id;
@end
