//
//  QGActOrderViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGViewController.h"

@interface QGActOrderViewController : QGViewController
/**活动id*/
@property (nonatomic,copy)NSString *activity_id;
@property (nonatomic,strong)QGActlistShopInfoModel *shopInfo;
@property (nonatomic,strong) NSMutableArray *ticketList;
@property (nonatomic,strong) NSArray *applyFieldList;
@property (nonatomic,copy)NSString *name;


@property (nonatomic,strong)QGActlistDetailModel*items;
@end
