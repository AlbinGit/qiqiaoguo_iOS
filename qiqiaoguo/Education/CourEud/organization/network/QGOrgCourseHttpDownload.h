//
//  QGOrgCourseHttpDownload.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/2.
//
//
#import "QGHttpDownload.h"

@interface QGOrgCourseHttpDownload : QGHttpDownload

/**机构ID*/
@property (nonatomic,copy)NSString *platform_id ;
/**机构ID*/
@property (nonatomic,copy)NSString *org_id;
/**当前页码默认为1*/
@property (nonatomic,copy)NSString *page;

@end
