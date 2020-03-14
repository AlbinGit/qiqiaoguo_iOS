//
//  QGEducationMainHttpDownload.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGEducationMainHttpDownload : QGHttpDownload
/**平台ID*/
@property (nonatomic, copy)NSString *platform_id;
/**频道唯一标记*/
@property (nonatomic, copy)NSString *sign;
/**Banner显示数量默认为5*/
@property (nonatomic, copy)NSString *banner_limit;
/**推荐模块显示数量默认为8*/
@property (nonatomic, copy)NSString *model_limit;
/**专题活动显示数量默认为10*/
@property (nonatomic, copy)NSString *subject_limit;
/**老师推荐显示数量默认为4*/
@property (nonatomic, copy)NSString *teacher_limit;
/**推荐课程显示数量默认为10*/
@property (nonatomic, copy)NSString *course_limit;
/**推荐课程显示页码默认为1*/
@property (nonatomic, copy)NSString *course_page; 

@end





