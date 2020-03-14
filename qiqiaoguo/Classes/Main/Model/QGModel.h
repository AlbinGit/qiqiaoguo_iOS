//
//  QGModel.h
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface QGModel : MTLModel <MTLJSONSerializing>

/** 将字典转为模型*/
+ (NSValueTransformer *)makeDicModelTransformer:(Class)aClass;

/** 将数组转为模型，数组每一个对象都是一个模型*/
+ (NSValueTransformer *)makeArrayModelTransformer:(Class)aClass;

/** 将number类型转换为字符串类型*/
+ (NSValueTransformer *)makeNumberConvertToString;

+ (NSValueTransformer *)createDateJSONTransformer;

@end
