//
//  QGGetCityDownload.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/25.
//
//

#import "QGGetCityDownload.h"

@implementation QGGetCityDownload
- (NSString *)path {
    return QGGetCityPath;
}

@end
@implementation QGGetCityResultModel

+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"items":@"QGShopCityModel"};
}

@end