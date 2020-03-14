//
//  QGActlistDetailModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/7.
//
//
/**
 *ticketList 活动票务信息 ,price = 价格,quantity= 总票数, sale_quantity=已售票数,sale_status 0=未开始，1=销售中，2＝暂停，3=售罄
 applyFieldList 报名联系信息字段列表
 */
#import <Foundation/Foundation.h>
#import "BLUShareObject.h"

@class QGActlistDetailModel,QGActlistShopInfoModel;
@interface QGActlistDetailDownload :QGHttpDownload

@property (nonatomic,copy) NSString *activity_id;

@end




@interface QGActlistDetailResultModel : NSObject

@property (nonatomic,strong)NSArray *ticketList;
@property (nonatomic,strong)QGActlistShopInfoModel *shopInfo;

@property (nonatomic,strong)QGActlistDetailModel*item;

@property (nonatomic,strong)NSDictionary *more;



@end

@interface QGActlistDetailModel : NSObject <BLUShareObject>
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *note;
@property (nonatomic,copy)NSString *coverPicPop;
@property (nonatomic,copy)NSString *coverPicOrg;
@property (nonatomic,copy)NSString *apply_begin_date;
@property (nonatomic,copy)NSString *apply_end_date;
@property (nonatomic,copy)NSString *valid_begin_date;
@property (nonatomic,copy)NSString *valid_end_date;
@property (nonatomic,copy)NSString *user_count;
@property (nonatomic,copy)NSString *apply_count;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *active_address;
@property (nonatomic,copy)NSString *user_range;
@property (nonatomic,copy)NSString *following_count;
@property (nonatomic,copy)NSString *isFollowed;
@property (nonatomic,copy)NSString *sharUrl;
@property (nonatomic,strong) NSMutableArray *ticketList;
@property (nonatomic,strong) NSArray *applyFieldList;
@property (nonatomic,copy) NSString *sign_status;
@property (nonatomic,copy) NSString *sign_status_text;
@property (nonatomic,copy) NSString *price_tail;
@property (nonatomic,copy) NSString *type_name;

@end

@interface QGActlistApplyFieldListModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;

@end
@interface QGActlistQuantityModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *value;

@end


@interface QGActlistTicketListModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *note;
@property (nonatomic,copy)NSString *quantity;
@property (nonatomic,copy)NSString *quantitycCount;
@property (nonatomic,copy)NSString *sale_quantity;
@property (nonatomic,copy)NSString *sale_status;
@property (nonatomic,copy)NSString *price;
/** 购买数 */
@property (nonatomic, assign) int pricecount;
/** 限制 */
@property (nonatomic, assign) int limitquantity;

@end



@interface QGActlistShopInfoModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *cover_photo;
@property (nonatomic,copy)NSString *service_id;
@property (nonatomic,copy)NSString *signature ;
@property (nonatomic,strong)NSArray *tagList;

@end
