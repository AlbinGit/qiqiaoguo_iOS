//
//  QGShopDetailsModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/20.
//
//

#import "QGShopDetailsModel.h"


@implementation QGShopDetailsDownload

- (NSString *)path {
    return QGShopDetailsDetailList;
}

@end



@implementation QGShopDetailsModel

@end
@implementation QGShopDetailsResultModel

- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return @"我在七巧国发现了一个不错的店铺:";
}

- (NSString *)shareContent {
    return self.name;
}

- (NSURL *)shareImageURL {
    return [NSURL URLWithString:self.cover_photo];
}

- (NSURL *)shareRedirectURL {
    
    return [NSURL URLWithString:self.sharUrl];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}


@end