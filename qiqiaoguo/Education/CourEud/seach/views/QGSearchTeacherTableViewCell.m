//
//  QGSearchTeacherTableViewCell.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/17.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGSearchTeacherTableViewCell.h"


@interface QGSearchTeacherTableViewCell ()
/**老师头像*/
@property (nonatomic, strong) UIImageView * headImageView;
/**老师名字*/
@property (nonatomic, strong) UILabel * nameLabel;
/**老师教龄*/
@property (nonatomic, strong) UILabel * yearsLabel;
/**老师介绍*/
@property (nonatomic, strong) UILabel * introLabel;
/**老师签名*/
@property (nonatomic, strong) UILabel * signLabel;
/**价格*/
@property (nonatomic, strong) UILabel * priceLabel;
/**所属机构*/
@property (nonatomic, strong) UILabel * orgLabel;
/**身份认证*/
@property (nonatomic, strong) SAButton * idenBtn;
/**学历认证*/
@property (nonatomic, strong) SAButton * expBtn;
/**距离*/
@property (nonatomic, strong) SAButton * distance;
@property (nonatomic,assign)CLLocationCoordinate2D myLc;

@end
@implementation QGSearchTeacherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI {
    // 老师头像
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 60, 60)];
    [self.contentView addSubview:_headImageView];
    // 名字
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.maxX + 10, _headImageView.minY, 100, 15)];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_CUSTOM(13);
    // 价格
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 10, 100, 20)];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = COLOR(255, 98, 7, 1);
    _priceLabel.font = FONT_CUSTOM(17);
    _priceLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:_priceLabel];
    // 教龄
    _yearsLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.minX, _nameLabel.maxY + 5, 100, 15)];
    [self.contentView addSubview:_yearsLabel];
    _yearsLabel.font = FONT_CUSTOM(12);
    _yearsLabel.textColor = COLOR(255, 98, 7, 1);
    // 介绍
    _introLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.minX, _yearsLabel.maxY, SCREEN_WIDTH - _headImageView.maxY, 15)];
    [self.contentView addSubview:_introLabel];
    _introLabel.font = FONT_CUSTOM(11);
    // 签名
    _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.minX, _introLabel.maxY, _introLabel.width, 15)];
    [self.contentView addSubview:_signLabel];
    _signLabel.font = FONT_CUSTOM(11);
    _signLabel.textColor = COLOR(153, 153, 153, 1);
    // 线
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.minX, _headImageView.maxY + 10, SCREEN_WIDTH - 20, 1)];
    line.backgroundColor = COLOR(245, 245, 245, 1);
    [self.contentView addSubview:line];
    // 底部空隙
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 10)];
    label.backgroundColor = APPBackgroundColor;
    [self.contentView addSubview:label];
    _idenBtn = [SAButton createBtnWithRect:CGRectMake(line.minX, line.maxY + 7, 70, 20) andWithImg:[UIImage imageNamed:@"radio_btn"] andWithTag:0 andWithBg:nil andWithTitle:@"身份认证" andWithColor:COLOR(255, 98, 7, 1)];
    _idenBtn.layer.borderWidth = 1;
    _idenBtn.titleLabel.font = FONT_CUSTOM(11);
    _idenBtn.layer.borderColor = COLOR(255, 98, 7, 1).CGColor;
    [_idenBtn setNormalImage:@"icon_authentication"];
    [_idenBtn addCorner];
    [self.contentView addSubview:_idenBtn];
    _expBtn = [SAButton createBtnWithRect:CGRectMake(_idenBtn.maxX + 5, _idenBtn.minY, 70, 20) andWithImg:[UIImage imageNamed:@"radio_btn"] andWithTag:0 andWithBg:nil andWithTitle:@"学历认证" andWithColor:COLOR(255, 98, 7, 1)];
    _expBtn.layer.borderWidth = 1;
    _expBtn.titleLabel.font = FONT_CUSTOM(11);
    [_expBtn setNormalImage:@"icon_authentication"];
    _expBtn.layer.borderColor = COLOR(255, 98, 7, 1).CGColor;
    [_expBtn addCorner];
    [self.contentView addSubview:_expBtn];
    // 机构
    _orgLabel = [[UILabel alloc]initWithFrame:CGRectMake(_expBtn.maxX + 5, _idenBtn.minY, SCREEN_WIDTH - 150, 20)];
    _orgLabel.textColor = COLOR(153, 153, 153, 1);
    _orgLabel.font = FONT_CUSTOM(11);
    [self.contentView addSubview:_orgLabel];
}
/**
 *  根据model给cell上的控件赋值
 *
 *  @param model 老师模型
 */
- (void)setModel:(QGEduTeacherModel *)model {
    _model = model;
    // 老师头像
     [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:LOADING_200];
    // 姓名
    _nameLabel.text = model.name;
    // 教龄
    _yearsLabel.text = [NSString stringWithFormat:@"%@年教龄",model.teach_experience];
    // 介绍
    _introLabel.text = model.intro;
    // 签名
    _signLabel.text = model.signature;
    // 判断是否认证
    if ([model.is_identity integerValue] == 1)
        _idenBtn.width = 70;
    else
        _idenBtn.width = 0;
    if ([model.is_education integerValue] == 1) {
        _expBtn.width = 70;
        _expBtn.X = _idenBtn.maxX + 5;
        _orgLabel.X = _expBtn.maxX + 5;
    }
    else {
        _expBtn.width = 0;
        _expBtn.X = _idenBtn.maxX;
        _orgLabel.X = _expBtn.maxX;
    } // 机构
    _orgLabel.text = model.org_name;
    // 价格
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@起",model.price]];
    [textStr addAttribute:NSForegroundColorAttributeName value:COLOR(153, 153, 153, 1) range:NSMakeRange(textStr.length - 1, 1)];
    [textStr addAttribute:NSFontAttributeName value:FONT_CUSTOM(11) range:NSMakeRange(textStr.length - 1, 1)];
    _priceLabel.attributedText = textStr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
