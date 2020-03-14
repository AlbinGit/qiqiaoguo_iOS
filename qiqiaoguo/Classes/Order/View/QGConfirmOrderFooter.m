//
//  QGConfirmOrderFooter.m
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGConfirmOrderFooter.h"
#import "QGGoodsMO.h"

@interface QGConfirmOrderFooter () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *logisticsLabel;
@property (nonatomic, strong) UILabel *logisticsDetailLabel;
@property (nonatomic, strong) UILabel *userMessageLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *goodsPriceDetailLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView2;

@end

@implementation QGConfirmOrderFooter


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _logisticsLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsLabel.text = @"运费";
        
        _logisticsDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        
        _userMessageLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _userMessageLabel.text = @"买家留言:";
        
        _userMessageTextField = [UITextField new];
        _userMessageTextField.delegate = self;
        _userMessageTextField.font = [UIFont systemFontOfSize:15];
        _userMessageTextField.placeholder = @"选填,可填写您的特殊要求";
        _userMessageTextField.returnKeyType = UIReturnKeyDone;
        
        
        _goodsPriceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        
        _goodsPriceDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _goodsPriceDetailLabel.textColor = QGMainRedColor;
        _goodsPriceDetailLabel.text = @" ";
        
        _lineView = [UIView new];
        _lineView.backgroundColor = QGCellbottomLineColor;
        
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = QGCellbottomLineColor;
        
        [self addSubview:_logisticsLabel];
        [self addSubview:_logisticsDetailLabel];
        [self addSubview:_userMessageLabel];
        [self addSubview:_userMessageTextField];
        [self addSubview:_goodsPriceLabel];
        [self addSubview:_goodsPriceDetailLabel];
        [self addSubview:_lineView];
        [self addSubview:_lineView2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_logisticsLabel sizeToFit];
    _logisticsLabel.X = BLUThemeMargin * 4;
    _logisticsLabel.Y = BLUThemeMargin * 3;
    
    [_logisticsDetailLabel sizeToFit];
    _logisticsDetailLabel.X = self.width - _logisticsDetailLabel.width - BLUThemeMargin * 4;
    _logisticsDetailLabel.centerY = _logisticsLabel.centerY;
    
    _lineView.X = 0;
    _lineView.Y = _logisticsLabel.maxY + BLUThemeMargin * 3;
    _lineView.width = self.width;
    _lineView.height = QGOnePixelLineHeight;
    
    [_userMessageLabel sizeToFit];
    _userMessageLabel.X = _logisticsLabel.X;
    _userMessageLabel.Y = _lineView.maxY  + BLUThemeMargin * 3;
    
    [_userMessageTextField sizeToFit];
    _userMessageTextField.X = _userMessageLabel.maxX + BLUThemeMargin;
    _userMessageTextField.centerY = _userMessageLabel.centerY;
    _userMessageTextField.width = self.width - _userMessageLabel.maxX - BLUThemeMargin *4;
    
    _lineView2.X = 0;
    _lineView2.Y = _userMessageLabel.maxY + BLUThemeMargin * 3;
    _lineView2.width = self.width;
    _lineView2.height = QGOnePixelLineHeight;
    
    [_goodsPriceDetailLabel sizeToFit];
    _goodsPriceDetailLabel.X = self.width - _goodsPriceDetailLabel.width - BLUThemeMargin * 4;
    _goodsPriceDetailLabel.Y = _lineView2.maxY  + BLUThemeMargin * 3;
    
    [_goodsPriceLabel sizeToFit];
    _goodsPriceLabel.X = _goodsPriceDetailLabel.X - _goodsPriceLabel.width - BLUThemeMargin ;
    _goodsPriceLabel.centerY = _goodsPriceDetailLabel.centerY;
    
    self.cellSize = CGSizeMake(self.width, _goodsPriceLabel.maxY + BLUThemeMargin * 3);
    
}

- (void)setGoodsArray:(NSArray *)goodsArray{
    
    int count = 0;
    for (QGGoodsMO *good in goodsArray) {
        count += good.goodsCount.integerValue;
    }
    
    _goodsArray = goodsArray;
    _goodsPriceLabel.text = [NSString stringWithFormat:@"共有%d件商品 合计:",count];
    QGGoodsMO * goods = [goodsArray firstObject];
    _userMessageTextField.text = goods.remark;
    if (self.dic) {
        self.logisticsDetailLabel.text = @"¥0";
        self.logisticsDetailLabel.textColor= QGMainRedColor;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setDic:(NSDictionary *)dic{
    
    if (dic) {
        CGFloat goodsAmount = [dic[@"goodsAmount"] floatValue];
        CGFloat deliverFee = [dic[@"deliverFee"] floatValue];
        self.goodsPriceDetailLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsAmount+deliverFee];
        if (deliverFee == 0) {
            self.logisticsDetailLabel.text = dic[@"deliverFeeTip"];
            self.logisticsDetailLabel.textColor= QGMainContentColor;
        }else{
            self.logisticsDetailLabel.text = [NSString stringWithFormat:@"¥%.2f",deliverFee];
            self.logisticsDetailLabel.textColor= QGMainRedColor;
        }
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.userMessageTextField resignFirstResponder];
    
    return YES;
}


@end
