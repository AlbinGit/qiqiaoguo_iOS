//
//  QGSeacherTeacherHttpDownload.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/17.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGSeacherTeacherHttpDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy)NSString *platform_id;

/**页数*/
@property (nonatomic, copy)NSString *page;
/**关键字*/
@property (nonatomic, copy)NSString *keyword;

@property (nonatomic, copy)NSString *category_id;

@end
