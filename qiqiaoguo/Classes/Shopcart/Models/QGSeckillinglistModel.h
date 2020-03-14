//
//  QGSeckillinglistModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import <Foundation/Foundation.h>

@interface QGSeckillinglistModel : NSObject
/**开始时间*/
@property (nonatomic,copy)NSString *start_time;
/**结束时间*/
@property (nonatomic,copy)NSString *end_time;

@property (nonatomic,copy) NSArray *items;
@end
@interface QGSeckillinglistItemModel : NSObject
/**秒杀图片*/
@property (nonatomic,copy)NSString *coverpath;

@property (nonatomic,copy) NSString *sales_price;

@end