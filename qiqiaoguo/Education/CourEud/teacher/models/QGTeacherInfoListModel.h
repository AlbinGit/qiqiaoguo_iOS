//
//  QGTeacherInfoListModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 5/1/16.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGTeacherInfoListModel : NSObject
/**用于cell分区标识*/
@property (nonatomic, copy) NSString * keyName;
/**cell每个分区的数据源*/
@property (nonatomic, strong) NSArray * valueArray;

@end
