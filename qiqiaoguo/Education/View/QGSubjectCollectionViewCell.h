//
//  QGSubjectCollectionViewCell.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGEduHomeResult.h"
#import "QGEduTeacherModel.h"

@interface QGSubjectCollectionViewCell : UICollectionViewCell
/**图片*/
@property (nonatomic, strong) UIImageView *imageView;
/**姓名*/
@property (nonatomic, strong) UILabel *nameLable;
/**课程名称*/
@property (nonatomic, strong) UILabel *courseLabel;

- (void)setModelListModel:(QGEducateListtModel *)model item:(NSInteger)index;


@end
