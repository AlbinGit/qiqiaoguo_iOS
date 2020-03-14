//
//  QGSeacherOrgHttpDownload.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/17.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGSeacherOrgHttpDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy)NSString *platform_id;
/**经度*/
@property (nonatomic, copy)NSString *lon;
@property (nonatomic, copy)NSString *longitude;
/**纬度*/
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *latitude;
/**数量限制*/
@property (nonatomic, copy)NSString *limit;
/**页数*/
@property (nonatomic, copy)NSString *page;
/**搜索关键字*/
@property (nonatomic, copy)NSString *keyword;
/**分类id*/
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *area_id; // 区域id
@property (nonatomic, copy)NSString *sort_id; //排序id
/**排序(智能排序=date/人气最高=hits/评价最好=comment) 智能排序=>date 最新注册的机构 人气最高=>hits collect收藏关注次数最多 评价最好=>comment 课程评论次数最多*/
@property (nonatomic, copy)NSString *sort;

@end
