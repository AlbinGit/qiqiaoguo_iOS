//
//  QGRemoteNotiModel.h
//  qiqiaoguo
//
//  Created by cws on 16/6/7.
//
//
typedef NS_ENUM(NSInteger, QGRemoteNotificationTypes) {
    QGRemoteNotificationTypeGoods = 1, // 商品详情
    QGRemoteNotificationTypeCostom = 5, // 自定义的url
    QGRemoteNotificationTypeEdu = 7,    // 教育首页
    QGRemoteNotificationTypeOrgList,    // 机构列表
    QGRemoteNotificationTypeTeacherList, // 老师列表
    QGRemoteNotificationTypeCourseList,  // 课程列表
    QGRemoteNotificationTypeOrgDetail = 18, // 机构详情
    QGRemoteNotificationTypeTeacherDetail = 19, // 老师详情
    QGRemoteNotificationTypeCourseDetail = 20, // 课程详情
    QGRemoteNotificationTypeActiv = 12,        // 活动首页
    QGRemoteNotificationTypeActivDetail = 13, // 活动详情
    QGRemoteNotificationTypeCircle = 100, //  巧妈帮首页
    QGRemoteNotificationTypePost, //  帖子详情
    QGRemoteNotificationTypeCircleDetail, //  某一个圈子
    QGRemoteNotificationTypePostTag = 111, //  话题标签
    QGRemoteNotificationTypeChatMeassage = 201, //  私信消息列表
    QGRemoteNotificationTypeCardMeassage, //  卡券消息列表页
    QGRemoteNotificationTypePostMeassage, //  社区动态
    QGRemoteNotificationTypeActivMeassage, //  活动消息
    QGRemoteNotificationTypeOrderMeassage, //  订单助手
    QGRemoteNotificationTypeEduOrderMeassage, //  教育订单助手
    
};

#import "QGModel.h"

@interface QGRemoteNotiModel : QGModel

@property (nonatomic, assign, readonly) NSInteger objectID;
@property (nonatomic, assign, readonly) QGRemoteNotificationTypes type;
@property (nonatomic, copy, readonly) NSURL *url;
//@property (nonatomic, copy, readonly) NSString *alert;
//@property (nonatomic, copy, readonly) NSString *sound;
@property (nonatomic, assign) BOOL showInfoDirectly;

@end

