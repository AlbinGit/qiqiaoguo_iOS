//
//  QGOptimalProductModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import <Foundation/Foundation.h>
#import "QGSeckillinglistModel.h"

/**
 *  请求参数
 */

@interface QGOptimalProductHttpDownload: QGHttpDownload
@property (nonatomic,copy) NSString *platform_id;

@end

/**
 *  返回参数
 */

@interface QGOptimalProductResultModel : NSObject
@property (nonatomic,strong) NSArray *bannerList;


@property (nonatomic,strong) NSArray *cateList;

@property (nonatomic,strong) NSMutableArray *subjectList;

@property (nonatomic,strong)QGSeckillinglistModel *seckillingList;

@end
/**
 *  banner数据
 */
@interface QGOptimalProductBannerListModel : NSObject


/**bannerID号*/
@property (nonatomic, copy) NSString *bannerId;//cateList
/**平台ID号*/
@property (nonatomic, copy) NSString *platform_id;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *channel_id;

@property (nonatomic, copy) NSString *activity_id;
/**活动类型*/
@property (nonatomic, copy) NSString *type;
/**当为自定义ULR时存在*/
@property (nonatomic, copy) NSString *url;
/**Banner图片*/
@property (nonatomic, copy) NSString *cover;
/**状态*/
@property (nonatomic, copy) NSString *status;



@end






