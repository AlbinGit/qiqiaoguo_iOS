//
//  QGSubjectCollectionViewCell.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGSubjectCollectionViewCell.h"

@implementation QGSubjectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI {
    _imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView];
    
    _nameLable = [[UILabel alloc]init];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLable];

    
    
    _imageView =[[UIImageView alloc]init];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_imageView];
    
    _nameLable =[[UILabel alloc]init];
    _nameLable.font=[UIFont systemFontOfSize:13];
    _nameLable.textColor=[UIColor grayColor];
    _nameLable.textAlignment=NSTextAlignmentCenter;
    
    [self.contentView addSubview: _nameLable ];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.width.mas_equalTo(self.contentView.width);
        
    }];
}
/**
 *  为cell上的控件填充内容
 *
 *  @param model 分类模型
 */
- (void)setModelListModel:(QGEducateListtModel *)model item:(NSInteger)index {
 
    
//    if (index == 0) {
//        [_imageView setImage:[UIImage imageNamed:@"ic_yuweng"]];
//           _nameLable.text = @"语文";
//    } else if(index == 1)  {
//        [_imageView setImage:[UIImage imageNamed:@"ic_shuxue"]];
//         _nameLable.text = @"数学";
//    } else if(index == 2)  {
//        [_imageView setImage:[UIImage imageNamed:@"ic_yingyu"]];
//          _nameLable.text = @"英语";
//    } else {
//        [_imageView setImage:[UIImage imageNamed:@"ic_zonghe"]];
//         _nameLable.text = @"综合";
//    }
    _nameLable.text = model.name;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:nil];
 
 
    _nameLable.textColor = QGMainContentColor;
}


@end
