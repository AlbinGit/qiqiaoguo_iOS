//
//  QGShopDetailsModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/20.
//
//

#import <Foundation/Foundation.h>
@class QGShopDetailsResultModel ;
@interface QGShopDetailsDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *shop_id;

@end




@interface QGShopDetailsModel : NSObject

@property (nonatomic,strong) QGShopDetailsResultModel  *item;
@end


@interface QGShopDetailsResultModel : NSObject <BLUShareObject>
@property (nonatomic, copy) NSString *cover_photo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *service_id;

@property (nonatomic,strong) NSArray *tagList;

@property (nonatomic,copy) NSString *sharUrl;

@property (nonatomic,copy) NSString *id;
@end