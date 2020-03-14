//
//  QGAttrPriceListModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//


#import <Foundation/Foundation.h>
//影响商品价格属性
@interface QGAttrPriceListModel : NSObject
@property(nonatomic,strong)NSString *attribute_id;//属性id
@property(nonatomic,strong)NSArray *attribute_value;//属性里装价格属性
@property(nonatomic,strong)NSString *attribute_name;//属性名字
@end
