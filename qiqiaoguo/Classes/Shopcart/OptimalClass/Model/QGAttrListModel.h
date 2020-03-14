//
//  QGAttrListModel.h
//  LongForTianjie
//
//  Created by xiaoliang on 15/8/12.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>
//不影响商品价格属性
@interface QGAttrListModel : NSObject
@property(nonatomic,strong)NSString *attribute_id;//属性id
@property(nonatomic,strong)NSString *attribute_value;//属性里装价格属性
@property(nonatomic,strong)NSString *attribute_name;//属性名字

@end
