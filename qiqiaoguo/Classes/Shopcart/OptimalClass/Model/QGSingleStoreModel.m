//
//  QGSingleStoreModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import "QGSingleStoreModel.h"

@implementation QGSingleStoreModel

@end



@implementation QGSingleStoreResult

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"items":@"QGSingleStoreModel"};
    
    
}

@end




@implementation QGSingleStoreDownload

- (NSString *)path {
    return QGSingleStoreList;
}


@end
@implementation QGSingleShopStoreDownload

- (NSString *)path {
    return QGSingleshopStoreList;
}


@end