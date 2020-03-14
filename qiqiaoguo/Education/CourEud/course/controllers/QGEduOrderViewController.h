//
//  QGActOrderViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGViewController.h"

@interface QGEduOrderViewController : QGViewController
/**活动id*/
@property (nonatomic,copy)NSString *activity_id;
@property (nonatomic,strong)QGActlistShopInfoModel *shopInfo;
@property (nonatomic,strong) NSMutableArray *ticketList;
@property (nonatomic,strong) NSArray *applyFieldList;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy) NSString *max_student_number ; //最多学生数
@property (nonatomic,copy) NSString *apply_student_number ;//已报名人数
@property (nonatomic,copy) NSString *avilibale_student_number ; //可报名数
@property (nonatomic,copy) NSString *cover_path ;
@property (nonatomic,copy) NSString *org_name ;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,strong)QGActlistDetailModel*items;
@property (nonatomic,copy) NSString *class_price;
@property (nonatomic,copy) NSString *eduId;
@property (nonatomic,copy) NSString *eduSid;
@property (nonatomic,copy) NSString *type;
@end
