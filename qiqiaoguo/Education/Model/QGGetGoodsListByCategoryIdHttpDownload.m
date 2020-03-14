//
//  QGGetGoodsListByCategoryIdHttpDownload.m
//  LongForTianjie
//
//  Created by xiaoliang on 15/6/29.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "QGGetGoodsListByCategoryIdHttpDownload.h"

@implementation QGGetGoodsListByCategoryIdHttpDownload
-(NSString *)path
{
    return QGGetGoodsListByCategoryId;
}

@end

@implementation QGGetMallByCategoryIdHttpDownload
-(NSString *)path
{
    return QGGetMallListByCategoryId;
}



@end

@implementation QGCategroyGoodsListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"categroyId":@"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"sublist":@"QGSublistModel" };
}
@end
@implementation QGBrandGoodsListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"brandId":@"id"};
}
@end


@implementation QGCategroyGoodsListResultModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"items":@"QGCategroyGoodsListModel",@"brandList":@"QGCategroyGoodsListModel"};
}


@end
@implementation QGSublistModel





@end

