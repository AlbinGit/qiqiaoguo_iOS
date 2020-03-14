//
//  QGCourseTeacherImageModel.h
//  LongForTianjie
//
//  Created by Albin on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGCourseTeacherImageModel : NSObject
/**老师头像*/
@property(nonatomic,copy)NSString *head_img;
/**老师ID*/
@property(nonatomic,copy)NSString *teacher_id;
/**老师名字*/
@property(nonatomic,copy)NSString *teacher_name;
/**是否认证*/
@property(nonatomic,copy)NSString *is_identity;

@end
