//
//  MQFirstPageDataModel.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/24.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <Foundation/Foundation.h>



@class QGSeckillinglistModel ;
@interface QGFirstPageDataModel : NSObject

@property (nonatomic,strong)NSDictionary *status;

@property (nonatomic,strong) NSArray *activityList;

@property (nonatomic,strong)QGSeckillinglistModel *seckillingList;
@property (nonatomic,strong)NSDictionary *more;
/**通知计数*/
@property (nonatomic,strong)NSString *notifyCount;
/**banner*/
@property (nonatomic,strong)NSArray *bannerList;
/**子导航*/
@property (nonatomic,strong)NSMutableArray *postList;
/**专题活动*/
@property (nonatomic,strong)NSArray *subject;
/**频道列表*/
@property (nonatomic,strong)NSArray *channel_list;

@property (nonatomic,strong)NSArray *cateList;//videoList
@property (nonatomic,strong)NSMutableArray *videoList;//courseList
@property (nonatomic,strong)NSArray *courseList;

@property (nonatomic,strong)NSArray *teacherList;//名师风采
@end



@interface QGBannerModel : NSObject
/**活动id*/
@property (nonatomic,copy)NSString* activity_id;
/**类型*/
@property (nonatomic,copy)NSString *type;
/**图片*/
@property (nonatomic,copy)NSString *cover;
/**自定义地址*/
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy) NSString *platform_id;

@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *sid;
@end

@interface QQGTeacherListModel : NSObject

@property (nonatomic,copy)NSString *teacher_id;
@property (nonatomic,copy)NSString *headimg;
@property (nonatomic,copy)NSString *teacher_name;

@end





