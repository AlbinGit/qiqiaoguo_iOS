//
//  QGSwitchCityViewController.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/22.
//  Copyright © 2016年 MQ. All rights reserved.
//
#import "QGShopCityModel.h"
typedef void(^QGSwitchCityViewControllerBlock)(QGShopCityModel * shopCityModel);
#import "QGViewController.h"

@interface QGSwitchCityViewController : QGViewController
/**城市名数组*/
@property (nonatomic,strong)QGShopCityModel *result;
@property (nonatomic,strong)NSMutableArray *cityNames;
- (void)setCityBlock:(QGSwitchCityViewControllerBlock)cityBlock;
@property (nonatomic,copy) NSString *cityTitle;
@end
