//
//  QGEduHomeResult.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/23.
//
//

#import <Foundation/Foundation.h>

@interface QGEduHomeResult : NSObject
@property (nonatomic,strong)NSArray *cateList;


/**banner*/
@property (nonatomic,strong)NSArray *videoList;
@property (nonatomic,strong)NSArray *modelList;
/**子导航*/
@property (nonatomic,strong)NSArray *courseList;
/**专题活动*/
@property (nonatomic,strong)NSMutableArray  *bannerList;
/**活动列表*/
@property (nonatomic,strong)NSArray *activityList;
@property (nonatomic,strong)NSDictionary *more;

@end



@interface QGEduBannerListModel : NSObject

/**bannerID号*/
@property (nonatomic, copy) NSString *bannerId;//cateList
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *sid;
/**频道ID号*/
@property (nonatomic, copy) NSString *channel_id;
/**活动ID号*/
@property (nonatomic, copy) NSString *activity_id;
/**活动类型*/
@property (nonatomic, copy) NSString *type;
/**当为自定义ULR时存在*/
@property (nonatomic, copy) NSString *url;
/**Banner图片*/
@property (nonatomic, copy) NSString *cover;
/**状态*/
@property (nonatomic, copy) NSString *status;

@end

@interface QGEducateListtModel : NSObject

/**标题*/
@property (nonatomic,copy)NSString *name;

/**id*/
@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *reid;

@property (nonatomic,copy)NSString *logo;

@end


@interface QGEduActivityListModel : NSObject

/**标题*/
@property (nonatomic,copy)NSString *title;

/**id*/
@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *coverPicOrg;

@property (nonatomic,copy)NSString *coverPicPop;

@end

@interface QGEduVideoListModel : NSObject

/**标题*/
@property (nonatomic,copy)NSString *title;

/**id*/
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy) NSString *access_count;

@property (nonatomic,copy)NSString *coverPicPop;

@end

@interface QGEduCourseListModel : NSObject

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
@property(nonatomic,copy)NSString *sign_count;

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

@property (nonatomic,copy)NSString *exit_rule_value;

/**插班状态*/
@property(nonatomic,copy)NSString *late_enrollment_ruL_value;
/**名称*/
@property(nonatomic,copy)NSString *title;

@end

//class_end_date = 2016-06-07,
//sign_count = 4,
//title = 乐高机器人课程,
//exit_rule_value = 随时可退,
//course_id = 199,
//class_id = 183,
//longlat = ,
//min_student_number = -1,
//late_enrollment_ruL_value = 随时插班,
//class_start_date = 2016-03-04,
//type = 1,
//late_enrollment_rule = -1,
//is_insert_class = 1,
//cover_path = http://file.qqg.blue69.cn/Public/Uploads/User/394/2016/0304/56d938be06873_360x360.jpg,
//max_student_number = 8,
//student_range = 2.5-12,
//class_price = 10.00,
//createdate = 2016-03-04 15:29:37,
//exit_rule = -1,
//address = 深圳市前海振业大厦天虹商场2楼,
//is_publish = 1
