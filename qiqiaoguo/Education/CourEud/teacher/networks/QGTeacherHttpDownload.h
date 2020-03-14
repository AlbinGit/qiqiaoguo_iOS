//
//  QGTeacherHttpDownload.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGTeacherHttpDownload : QGHttpDownload
/**教师ID*/
@property (nonatomic, copy)NSString *teacher_id;
/**标签显示数量*/
@property (nonatomic, copy)NSString *tag_limit;
/**课程显示数量*/
@property (nonatomic, copy)NSString *course_limit;
/**图片展示数量*/
@property (nonatomic, copy)NSString *photo_limit;
/**评论显示数量*/
@property (nonatomic, copy)NSString *comment_limit;
/**当前登录用户ID*/
@property (nonatomic, copy)NSString *user_id;

@end
