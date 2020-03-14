//
//  QGEduClassModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGEduClassModel : NSObject
/**班课id*/
@property (nonatomic, copy) NSString *course_class_id;
/**价格*/
@property (nonatomic, copy) NSString *price;
/**是否公开*/
@property (nonatomic, copy) NSString *is_publish;
/**课程id*/
@property (nonatomic, copy) NSString *course_id;
/**分类ID*/
@property (nonatomic, copy) NSString *category_id;
/**分类名称*/
@property (nonatomic, copy) NSString *category_name;
/**课程标题*/
@property (nonatomic, copy) NSString *cover_path;
/**创建日期*/
@property (nonatomic, copy) NSString *createdate;
/**课程标题*/
@property (nonatomic, copy) NSString *title;
/**授课地址*/
@property (nonatomic, copy) NSString *address;
/**地址经纬度*/
@property (nonatomic, copy) NSString *longlat;
/**报名人数*/
@property (nonatomic, copy) NSString *sign_count;
/**老师姓名*/
@property (nonatomic, copy) NSString *teacher_name;
/**机构ID*/
@property (nonatomic, copy) NSString *org_id;
/**机构简称*/
@property (nonatomic, copy) NSString *org_name_short;
/**机构名称*/
@property (nonatomic, copy) NSString *org_name;
/**课程类型*/
@property (nonatomic, copy) NSString *type;
/**类型名称*/
@property (nonatomic, copy) NSString *type_name;
/**一对一课程id*/
@property (nonatomic, copy) NSString *biunique_id;
/**一对一课程价格*/
@property (nonatomic, copy) NSString *biunique_price;
/**背景介绍*/
@property (nonatomic, copy) NSString *biunique_description;
/**课程id*/
@property (nonatomic, copy) NSString *class_id;
/**开课时间*/
@property (nonatomic, copy) NSString *class_start_date;
/**结课时间*/
@property (nonatomic, copy) NSString *class_end_date;
/**课程价格*/
@property (nonatomic, copy) NSString *class_price;
/**班课已报名人数*/
@property (nonatomic, copy) NSString *class_sign_count;
/**插班规则*/
@property (nonatomic, copy) NSString *class_late_enrollment_rule;
/**插班费用*/
@property (nonatomic, copy) NSString *class_late_enrollment_price;
/**班课最大报名人数*/
@property (nonatomic, copy) NSString *class_max_student_number;
/**显示“立即插片”或“立即报名”按钮状态(1=立即插班/0=立即报名/-1=立即插班按钮为灰色)*/
@property (nonatomic, copy) NSString *is_insert_class;

@end
