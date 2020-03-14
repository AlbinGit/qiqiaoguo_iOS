//
//  QGCommentInfoModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/14.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGCommentInfoModel : NSObject
/**评论总数*/
@property (nonatomic, copy) NSString *comment_count;
/**评论平均值*/
@property (nonatomic, copy) NSString *comment_avg;
/**描述相符*/
@property (nonatomic, copy) NSString *describe_avg;
/**教学态度*/
@property (nonatomic, copy) NSString *manner_avg;
/**响应速度*/
@property (nonatomic, copy) NSString *speed_avg;
/**好评数目*/
@property (nonatomic, copy) NSString *good_count;
/**中评数目*/
@property (nonatomic, copy) NSString *mid_count;
/**差评数目*/
@property (nonatomic, copy) NSString *bad_count;

@end
