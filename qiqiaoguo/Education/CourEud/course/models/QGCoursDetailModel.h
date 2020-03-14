//
//  QGCoursDetailModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/28.
//
//

#import <Foundation/Foundation.h>

@interface QGCoursDetailModel : NSObject <BLUShareObject>
@property (nonatomic,copy) NSString *org_head_img;
@property (nonatomic,copy) NSString *student_range;

@property (nonatomic,copy) NSString *max_student_number ; //最多学生数
@property (nonatomic,copy) NSString *apply_student_number ;//已报名人数
@property (nonatomic,copy) NSString *avilibale_student_number ; //可报名数
@property (nonatomic,copy) NSString *sign_status_text;//立即报名 按钮显示文字
@property (nonatomic,copy) NSString *sign_status;// 报名状态，1=可报名，其它状态为为可报名，显示灰色
@property (nonatomic,copy)NSString *category_name ;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *org_id;
@property (nonatomic,copy) NSString *sharUrl;
@property (nonatomic,copy)NSString *teacher_name;
@property (nonatomic,copy)NSString *teacher_experience;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *isFollowed  ;
@property (nonatomic,copy) NSString *org_name ;//机构名称
@property (nonatomic,strong) NSMutableArray *tagList;
@property (nonatomic,copy) NSString *org_signature ;
@property (nonatomic,copy) NSString *class_price;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString  *section;
@property (nonatomic,strong) NSArray *sectionList;
@property (nonatomic,copy) NSString *cover_path ;
@property (nonatomic,copy) NSString *service_id;

@property (nonatomic,copy)NSString *org_address;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *teacher_id;//course_desc
@property (nonatomic,copy) NSString *course_desc;//cover_path
@end


@interface QGCourseDetSectionListModel : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy)NSString *start_time;
@property (nonatomic,copy)NSString *begin_date;
@property (nonatomic,copy)NSString *end_time;
@property (nonatomic,copy) NSString *content ;

@end
@interface QGCourseDetaiResultModel : NSObject

//@property (nonatomic,strong) NSMutableArray *item;

@property (nonatomic,strong) QGCoursDetailModel *item;

//id = 22,
//begin_date = 2016-10-01,
//content = 让孩子更加健康、开朗、聪明的成长。,
//start_time = 15:00:00,
//end_time = 17:00:00

@end
@interface QGCourseDeilTag : NSObject
@property (nonatomic,copy) NSString *tag_name ;
@property (nonatomic,copy) NSString *tag_id ;
@end