//
//  QGGetCityDownload.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/25.
//
//

#import <Foundation/Foundation.h>
#import "QGShopCityModel.h"
@interface QGGetCityDownload  : QGHttpDownload
@property (nonatomic,copy)NSString *platform_id;
@end
@interface QGGetCityResultModel : NSObject
@property (nonatomic,strong)NSMutableArray *items;
@property (nonatomic,strong) QGShopCityModel *item;

@end