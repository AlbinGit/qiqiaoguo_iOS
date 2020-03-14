//
//  QGCourseTeacherCollectionViewCell.m
//  LongForTianjie
//
//  Created by Albin on 15/11/13.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGCourseTeacherCollectionViewCell.h"

@implementation QGCourseTeacherCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI
{
    self.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = _imageView.width / 2;
    [self.contentView addSubview:_imageView];
    
    _nameLabel = [SAAppUtils createGrayLightLabel];
    _nameLabel.frame = CGRectMake(-5, _imageView.maxY, 60, 20);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
}

- (void)setModel:(QGCourseTeacherImageModel *)model
{
  
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:@"icon_head"]];
    _nameLabel.text = model.teacher_name;
}


@end
