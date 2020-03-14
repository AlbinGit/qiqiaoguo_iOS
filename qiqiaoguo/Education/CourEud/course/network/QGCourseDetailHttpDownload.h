//
//  QGCourseDetailHttpDownload.h
//  LongForTianjie
//
//  Created by Albin on 15/11/11.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGCourseDetailHttpDownload : QGHttpDownload

@property (nonatomic,copy)NSString *course_id;

@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *user_id;

@end
