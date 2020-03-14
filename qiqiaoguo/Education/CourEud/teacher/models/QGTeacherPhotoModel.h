//
//  QGTeacherPhotoModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGTeacherPhotoModel : NSObject
/**照片id*/
@property (nonatomic, copy) NSString *photoId;
/**老师id*/
@property (nonatomic, copy) NSString *teacher_id;
/**课程id*/
@property (nonatomic, copy) NSString *course_id;
/**照片url*/
@property (nonatomic, copy) NSString *path;
/**照片描述*/
@property (nonatomic, copy) NSString *describe;

@end
