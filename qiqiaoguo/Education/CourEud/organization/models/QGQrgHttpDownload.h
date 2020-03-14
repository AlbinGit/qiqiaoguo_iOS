//
//  QGQrgHttpDownload.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/4.
//
//

#import "QGHttpDownload.h"

@interface QGQrgHttpDownload : QGHttpDownload

/**机构ID号*/
@property (nonatomic,copy)NSString *org_id;
/**标签显示数量默认值为5*/
@property (nonatomic,copy)NSString *tag_limit;
/**课程显示数量默认值为2*/
@property (nonatomic,copy)NSString *course_limit;
/**教师显示数量默认值为3*/
@property (nonatomic,copy)NSString *teacher_limit;
/**评论显示数量默认值为10*/
@property (nonatomic,copy)NSString *comment_limit;
/**用户ID*/
@property (nonatomic,copy)NSString *user_id;

@end
