//
//  QGSwitchCityCollectionViewCell.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/22.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGSwitchCityCollectionViewCell.h"
@interface QGSwitchCityCollectionViewCell()

@end
@implementation QGSwitchCityCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
}
- (void)createUI
{   float width = (SCREEN_WIDTH - 35)/4;
    self.contentView.backgroundColor=[UIColor whiteColor];
    _cityName=[[UILabel alloc]init];
    _cityName.font=FONT_SYSTEM(16);
    _cityName.textColor= QGMainContentColor;
    _cityName.layer.borderWidth=1.0;
    _cityName.layer.borderColor=[UIColor colorFromHexString:@"e1e1e1"].CGColor;
    _cityName.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_cityName];
    [_cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
         make.size.mas_equalTo(CGSizeMake(width, 29));
    }];
}
@end
@implementation QGSwitchCityHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _headerName=[[UILabel alloc]init];
    _headerName.font=FONT_SYSTEM(16);
    _headerName.textColor=QGMainContentColor;

    _headerName.textAlignment=NSTextAlignmentLeft;
    [self addSubview:_headerName];
    [_headerName mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(@10);
         make.top.equalTo(@20);
    }];
}
@end