//
//  QGTeacherViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import "QGViewController.h"
#import "QGEduTeacherModel.h"

@interface QGTeacherViewController :QGViewController
/**教师模型*/ 
@property (nonatomic, strong) QGEduTeacherModel * teacherModel;
@property (nonatomic, copy) NSString * teacher_id;
@end
