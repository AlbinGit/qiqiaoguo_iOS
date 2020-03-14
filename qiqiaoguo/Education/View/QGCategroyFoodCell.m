
//
//  QGCategroyFoodCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//


#import "QGCategroyFoodCell.h"

@implementation QGCategroyFoodCell

- (void)awakeFromNib
{
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}
-(void)createUI
{

    _foodImv =[[UIImageView alloc]init];
    _foodImv.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_foodImv];

    _foodName =[[UILabel alloc]init];
    _foodName.font=FONT_CUSTOM(12);
    _foodName.numberOfLines = 2;
    _foodName.textColor=QGCellContentColor;
    _foodName.textAlignment=NSTextAlignmentCenter;   
  
    [self.contentView addSubview:_foodName];
    [_foodImv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
         make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    [_foodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(70);
        make.width.mas_equalTo(self.contentView.width);
       
    }];
}
-(void)setModel:(QGSublistModel *)model
{

    [_foodImv sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:LOADING_200];
    _foodName.text = model.name;

}
- (void)setBrandModel:(QGBrandGoodsListModel *)brand
{
    
    [_foodImv sd_setImageWithURL:[NSURL URLWithString:brand.logo] placeholderImage:LOADING_200];
    _foodName.text = brand.name;
}
@end
