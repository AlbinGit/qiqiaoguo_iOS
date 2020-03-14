//
//  QGSeckillResultModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/13.
//
//

#import "QGSeckillResultModel.h"

@implementation QGSeckillResultModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"seckillingList":@"QGSeckillListModel"};
}


@end
@implementation QGSeckillListModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"items":@"QGSeckillListItemModel"};
    
}

@end
@implementation QGSeckillListItemModel



@end