//
//  QGActHomeModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import <Foundation/Foundation.h>

#import "QGHttpDownload.h"
@interface QGActHomeHttpDownload : QGHttpDownload


@property (nonatomic,copy)NSString *platform_id;

@end








@interface QGActHomeResultModel : NSObject
@property (nonatomic,strong) NSArray *items;

@end

@interface QGActHomeModel : NSObject
@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *platform_id;
@property (nonatomic,copy)NSString *sid;
@property (nonatomic,copy)NSString *channel_id;
@property (nonatomic,copy)NSString *activity_id;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *status;

//bannrList:
//type 目标的类型，
//单品＝1 ，套餐＝2，品牌特卖 ＝3，品牌 ＝4， 自定义url＝5，商品分类 ＝6，教育频道首页 ＝7， 机构首页 ＝8，教师首页 ＝9，课程首页 ＝10， 机构详情 ＝18，教师详情 ＝19，课程详情＝20， 教育分类 ＝11，活动首页 ＝12，活动详情＝13， 巧妈帮首页 ＝100，帖子详情 ＝101，某一个圈子＝102，话题标签＝111
//activity_id 根据type 的类型对应 的id, 如帖子ID、圈子ID、
//url type＝ 5 时，对应的 url
@end
