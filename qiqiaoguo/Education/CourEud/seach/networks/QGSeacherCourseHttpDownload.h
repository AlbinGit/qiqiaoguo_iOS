//
//  QGSeacherCourseHttpDownload.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/16.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"

@interface QGSeacherCourseHttpDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy)NSString *platform_id;
/**经度*/
@property (nonatomic, copy)NSString *lon;
/**纬度*/
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *latitude;
/**数量限制*/
@property (nonatomic, copy)NSString *limit;
/**页数*/
@property (nonatomic, copy)NSString *page;
/**搜索关键字*/
@property (nonatomic, copy)NSString *keyword;
/**最低价格*/
@property (nonatomic, copy)NSString *min_price;
/**最高价格*/
@property (nonatomic, copy)NSString *max_price;
/**上课开始日期*/
@property (nonatomic, copy)NSString *start_date;
/**上课结束日期*/
@property (nonatomic, copy)NSString *end_date;
/**排序方式(智能排序=date/人气最高=hits/价格最低=price_a/价格最高=price_d) 智能排序=>date 按课程创建时间顺序展示 人气最高=>hits comment按评论总数排序展示 价格最低=>price_a 价格最高=>price_d*/
@property (nonatomic, copy)NSString *sort;
/**课程分类ID号*/
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *area_id; // 区域id
@property (nonatomic, copy)NSString *sort_id; //排序id
@property (nonatomic, copy)NSString *brand_id; 

@end
