//
//  QGCourseBadgeCollectionViewCell.m
//  LongForTianjie
//
//  Created by Albin on 15/11/13.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGCourseBadgeCollectionViewCell.h"

@implementation QGCourseBadgeCollectionViewCell

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
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 12, 12)];
    _imageView.image = [UIImage imageNamed:@"icon_authentication"];
    [self.contentView addSubview:_imageView];
    
    _titleLabel = [SAAppUtils createGrayLightLabel];
    _titleLabel.frame = CGRectMake(_imageView.maxX + 3, 10, 60, 20);
    [self.contentView addSubview:_titleLabel];
}



@end
