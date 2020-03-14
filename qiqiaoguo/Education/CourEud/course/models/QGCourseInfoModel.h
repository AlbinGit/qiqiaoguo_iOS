//
//  QGCourseInfoModel.h
//  LongForTianjie
//
//  Created by Albin on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QGCourseInfoResultModel : NSObject

@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,copy)NSString *per_page;
@property (nonatomic,copy)NSString *current_page;
@property (nonatomic,copy)NSString *total_page;

@property (nonatomic,copy)NSString *total_count;

@end
@interface QGCourseInfoModel : NSObject

/**班课ID号*/
@property(nonatomic,copy)NSString *id;


/**课程ID号*/
@property(nonatomic,copy)NSString *course_id;
/**课程标题*/
@property(nonatomic,copy)NSString *org_name;
/**
 *  老师名字
 */
@property(nonatomic,copy)NSString *teacher_name;
/**授课地址经纬度*/
@property(nonatomic,copy)NSString *longlat;
/**适学人群*/
@property(nonatomic,copy)NSString *student_range;

/**教年*/
@property(nonatomic,copy)NSString *teacher_experience;

/**保底开班人数限制*/
@property(nonatomic,copy)NSString *min_student_number;
/**退班规则（-1随时可退，开班前1小时可退，第N节课后不可退）*/
@property(nonatomic,copy)NSString *exit_rule;
/**插班价格*/
@property(nonatomic,copy)NSString *late_enrollment_price;
/**插班规则,(-1:随时插班，2:第N节课前可插班，3:不可插班*/
@property(nonatomic,copy)NSString *tag_name;
/**课程图文详情*/
@property(nonatomic,copy)NSString *course_desc;
/**授课地址*/
@property(nonatomic,copy)NSString *address;
/**课程安排标题*/
@property(nonatomic,copy)NSString *syllabus_title;
/**教学目标*/
@property(nonatomic,copy)NSString *teach_goal;
/**封面*/
@property(nonatomic,copy)NSString *cover_path;
/**价格*/
@property(nonatomic,copy)NSString *price;
/**tag名字*/
@property(nonatomic,copy)NSArray *tagList;
/**授课方式(1:线下授课/2=在线授课)*/
@property(nonatomic,copy)NSString *teach_way;
/**授课方式显示标题*/
@property (nonatomic, copy) NSString *teach_way_name;
/**是否收藏 1=收藏/0=未收藏*/
@property (nonatomic,copy)NSString *isExitsCollect;
/**分享ULR*/
@property (nonatomic,copy)NSString *sharUrl;
/**开始日期*/
@property (nonatomic, copy) NSString *begin_date;
/**开始时间*/
@property (nonatomic, copy) NSString *start_time;
/**显示“立即插班”或“立即报名”按钮状态(1=立即插班/0=立即报名/-1=立即插班按钮为灰色)*/
@property(nonatomic,copy)NSString *is_insert_class;

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *is_publish;
@property(nonatomic,copy)NSString *createdate;
@property(nonatomic,copy)NSString *class_price;
@property(nonatomic,copy)NSString *section;
@property(nonatomic,copy)NSString *class_end_date;


/**插班状态*/
@property(nonatomic,copy)NSString *late_enrollment_ruL_value;
/**名称*/
@property(nonatomic,copy)NSString *title;



@end



@interface QGCourseTagModel : NSObject
@property (nonatomic,strong) NSString *tag_id;
@property (nonatomic,strong) NSString *tag_name;


@end
