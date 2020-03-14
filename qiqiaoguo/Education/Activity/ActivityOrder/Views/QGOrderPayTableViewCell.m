//
//  QGOrderPayTableViewCell.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/28.
//
//

#import "QGOrderPayTableViewCell.h"

@implementation QGOrderPayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _picImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_picImageView];

    _name=[[UILabel alloc]init];
    _name.font=FONT_CUSTOM(14);
    _name.textColor=PL_COLOR_30;
    [self.contentView addSubview:_name];
    _Triangle=[[UIButton alloc]init];
    [self.contentView addSubview:_Triangle];
    PL_CODE_WEAK(weakSelf);
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = APPBackgroundColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
   make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.left.width.bottom.equalTo(self);
     make.size.mas_equalTo(CGSizeMake(MQScreenW, 1));

    }];

    [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.picImageView.mas_right).offset(10);
    }];


    [_Triangle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-14);
        //        make.size.mas_equalTo(CGSizeMake(6, 11));
    }];


    
}
@end
