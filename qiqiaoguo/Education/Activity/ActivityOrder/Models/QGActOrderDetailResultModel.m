//
//  QGActOrderDetailResultModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGActOrderDetailResultModel.h"

@implementation QGActOrderDetailResultModel
+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"activityInfo":@"QGActOrderDetailActivityModel"};
}
@end


@implementation QGActOrderDetailItemModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"goodsList":@"QGActOrderDetailGoodsListModel"};
}


@end
@implementation QGActOrderDetailActivityModel



@end
@implementation QGActOrderDetailGoodsListModel



@end