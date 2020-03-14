//
//  QGGetGoodsCategoryHttpDownload.h
//  LongForTianjie
//
//  Created by xiaoliang on 15/6/29.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"
//获取教育分类列表
@interface QGEudCategoryHttpDownload : QGHttpDownload
@property (nonatomic,copy) NSString *platform_id;//商家ID号
@end


//获取商品分类列表
@interface QGMallCategoryHttpDownload : QGHttpDownload
@property (nonatomic,copy) NSString *platform_id;//商家ID号
@end






#pragma mark 返回结果
@interface QGCategroyResultModel : NSObject

@property (nonatomic,strong) NSMutableArray *items;


@end

@interface QGCategroyModel : NSObject
@property (nonatomic,copy) NSString *id;//分类ID
@property (nonatomic,copy) NSString *name;//分类名称
@property (nonatomic,copy) NSString *reid;//分类父ID号

@property (nonatomic,copy) NSString *logo;

@end