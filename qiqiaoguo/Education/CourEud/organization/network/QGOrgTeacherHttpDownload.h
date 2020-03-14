//
//  QGOrgTeacherHttpDownload.h
//  LongForTianjie
//
//  Created by Albin on 15/11/19.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"
#import "QGTeacherListModel.h"

@interface QGOrgTeacherHttpDownload : QGHttpDownload
@property (nonatomic,copy) NSString *platform_id;
/**机构ID*/
@property (nonatomic,copy)NSString *org_id;

/**当前页码默认为1*/
@property (nonatomic,copy)NSString *page;

@end
@interface QGOrgTeacherListResultModel : NSObject
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,copy)NSString *per_page;
@property (nonatomic,copy)NSString *current_page;
@property (nonatomic,copy)NSString *total_page;

@property (nonatomic,copy)NSString *total_count;
@end
