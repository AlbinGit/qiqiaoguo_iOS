//
//  QGGetGoodsCategoryHttpDownload.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGEudCategoryHttpDownload.h"

@implementation QGEudCategoryHttpDownload
-(NSString *)path
{
    return QGGetGoodsCategory;//QGMallGoodsCategory
}
-(NSString *)method
{
    return @"GET";
}
@end


@implementation QGMallCategoryHttpDownload

-(NSString *)path
{
    return QGMallGoodsCategory;//QGMallGoodsCategory
}
-(NSString *)method
{
    return @"GET";
}

@end

@implementation QGCategroyModel

@end
@implementation QGCategroyResultModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"items":@"QGCategroyModel"};
}
@end