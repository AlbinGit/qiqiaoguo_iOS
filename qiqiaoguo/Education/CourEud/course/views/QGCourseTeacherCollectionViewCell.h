//
//  QGCourseTeacherCollectionViewCell.h
//  LongForTianjie
//
//  Created by Albin on 15/11/13.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGCourseTeacherImageModel.h"

@interface QGCourseTeacherCollectionViewCell : UICollectionViewCell

/**教师头像*/
@property(nonatomic,strong)UIImageView *imageView;
/**名称*/
@property(nonatomic,strong)UILabel *nameLabel;
/**教师模型*/
@property(nonatomic,strong)QGCourseTeacherImageModel *model;

@end
