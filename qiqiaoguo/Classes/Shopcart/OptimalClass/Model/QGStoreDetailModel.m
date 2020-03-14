//
//  QGStoreDetailModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import "QGStoreDetailModel.h"
/**
 *  返回
 */
@implementation QGStoreDetailModel


@end



@implementation QGStoreDetailShopInfoModel


+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"tagList":@"QGTagListModel"};
}



@end
@implementation QGStoreDetailImageListModel



@end

@implementation QGStoreDetailItemModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"priceList":@"QGStoreDetailPriceListModel",
             @"attrList":@"QGStoreAttrListModel",
             @"imageList":@"QGStoreDetailImageListModel",
           };
}


- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return @"我在七巧国发现了一个不错的宝贝:";
}

- (NSString *)shareContent {
    return self.title;
}

- (NSURL *)shareImageURL {
    return [NSURL URLWithString:self.coverpath];
}

- (NSURL *)shareRedirectURL {
    
    return [NSURL URLWithString:self.sharUrl];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}


@end

/**
 *  请求
 */
@implementation QGStoreDetailDownload

- (NSString *)path {
    return QGSingleStoreDetailList;
}


@end

@implementation  QGSkillDetailDownload
- (NSString *)path {
    return QGSkillStoreDetailList;
}


@end