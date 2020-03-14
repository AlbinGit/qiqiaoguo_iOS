//
//  QGMessageTypeModel.h
//  qiqiaoguo
//
//  Created by cws on 16/6/30.
//
//

#import "BLUObject.h"

typedef NS_ENUM(NSInteger, QGMessageType) {
    
    QGMessageTypeCard = 2,      // 卡券
    QGMessageTypeOrder = 3,     // 订单
    QGMessageTypeActiv = 6,     // 活动
    QGMessageTypeEdu = 7,     // 教育
    QGMessageTypeDynamic = 101, // 社区动态
    QGMessageTypePrivate = 102, // 私信
    QGMessageTypeSecretary = 110// 客服
};


@interface QGMessageTypeModel : BLUObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, assign) NSInteger kefuUserID;
@property (nonatomic, copy) NSDate *createDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;

@end
