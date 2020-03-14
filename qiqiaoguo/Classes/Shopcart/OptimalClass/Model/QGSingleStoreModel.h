//
//  QGSingleStoreModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import <Foundation/Foundation.h>
/**
 *  请求参数
 */
@interface QGSingleStoreDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *page;

@property (nonatomic, copy) NSString *self_support;
@property (nonatomic, copy) NSString *category_id;

@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *keyword;
@end
/**
 *  请求参数
 */
@interface QGSingleShopStoreDownload : QGHttpDownload
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *page;

@property (nonatomic, copy) NSString *self_support;
@property (nonatomic, copy) NSString *category_id;

@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *keyword;
@end


/**
 *  返回参数
 */
@interface QGSingleStoreResult : NSObject
/**item*/
@property (nonatomic, strong) NSArray *items;
@property (nonatomic,copy)NSString *current_page;
@property (nonatomic,copy)NSString *per_page;
@property (nonatomic,copy)NSString *total_page;
@property (nonatomic,copy)NSString *total_count;

@end


@interface QGSingleStoreModel : NSObject

@property (nonatomic, copy) NSString *coverpath;

@property (nonatomic, copy) NSString *sales_price;

@property (nonatomic, copy) NSString *sales_volume;

@property (nonatomic, copy) NSString *delivery_type;

@property (nonatomic, copy) NSString *current_page;

@property (nonatomic, copy) NSString *per_page;

@property (nonatomic, copy) NSString *total_page;

@property (nonatomic, copy) NSString *total_count;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *id;
@end
