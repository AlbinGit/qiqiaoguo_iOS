//
//  QGSortModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/25.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGSortModel : NSObject
/**key值*/
@property (nonatomic, copy) NSString * key;
/**名字*/
@property (nonatomic, copy) NSString * name;
/**标题*/
@property (nonatomic, copy) NSString * title;
/**排序数组*/
@property (nonatomic, strong) NSArray * list;

@end
