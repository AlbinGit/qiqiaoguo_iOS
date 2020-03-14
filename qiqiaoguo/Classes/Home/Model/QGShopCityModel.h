//
//  QGShopCityModelModel.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/22.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGShopCityModel : NSObject
/**ID号*/
@property (nonatomic,copy)NSString *id;
/**是否为默认(1=默认)，主要是在定位找不到城市时选用*/
@property (nonatomic,copy)NSString *is_default;

/**城市名称*/
@property (nonatomic,copy)NSString *name;
/**平台ID*/
@property (nonatomic,copy)NSString *platform_id;
/**店铺ID*/
@property (nonatomic,copy)NSString *sid;

@end
