//
//  QGGetLocationCityModel.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/27.
//
//

#import <Foundation/Foundation.h>

@interface QGGetLocationCityModel : QGHttpDownload
@property (nonatomic,copy) NSString *platform_id;
@property (nonatomic) CLLocationDegrees longitude ;
@property (nonatomic)CLLocationDegrees latitude;
@end
