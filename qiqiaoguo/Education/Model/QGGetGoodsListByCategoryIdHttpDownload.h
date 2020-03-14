//
//  QGGetGoodsListByCategoryIdHttpDownload.h
//  LongForTianjie
//
//  Created by xiaoliang on 15/6/29.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "QGHttpDownload.h"
//获取分类下的子分类及商品列表
@interface QGGetGoodsListByCategoryIdHttpDownload : QGHttpDownload
@property (nonatomic,copy)NSString *platform_id;//商家ID号
@property (nonatomic,copy)NSString *reid;//二级分类ID号

@end

@interface QGGetMallByCategoryIdHttpDownload : QGHttpDownload
@property (nonatomic,copy)NSString *platform_id;//商家ID号
@property (nonatomic,copy)NSString *reid;//二级分类ID号

@end


@interface QGCategroyGoodsListResultModel : NSObject
@property (nonatomic,strong)NSMutableArray *items;
@property (nonatomic,strong)NSMutableArray *brandList;


@end
//分类列表
@interface QGCategroyGoodsListModel : NSObject

@property (nonatomic,strong) NSMutableArray *sublist;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *reid;
@property (nonatomic,copy)NSString *logo;

@end


@interface QGBrandGoodsListModel : NSObject
@property (nonatomic,copy)NSString *brandId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *logo;

@end

@interface QGSublistModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *reid;
@property (nonatomic,copy)NSString *logo;

@end
