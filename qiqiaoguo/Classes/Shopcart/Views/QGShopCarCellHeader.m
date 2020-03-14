//
//  QGShopCarCellHeader.m
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGShopCarCellHeader.h"

@implementation QGShopCarCellHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _contentMargin = BLUThemeMargin * 4;
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell_arrow"]];
        _Clickbutton = [UIButton new];
        _Clickbutton.contentEdgeInsets = UIEdgeInsetsMake(6, 12, 6, 12);
        [_Clickbutton setImage:[UIImage imageNamed:@"toy-deselected"] forState:UIControlStateNormal];
        [_Clickbutton setImage:[UIImage imageNamed:@"toy-selected"] forState:UIControlStateSelected];
        
        [superview addSubview:_Clickbutton];
        [superview addSubview:self.bottomLine];
        [superview addSubview:self.orderIDLabel];
        
        [_Clickbutton sizeToFit];
        [self.Clickbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superview);
            make.left.equalTo(_Clickbutton.mas_right);
        }];
        
        

        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(QGOnePixelLineHeight));
        }];

    }
    return self;
}

+ (CGFloat)userOrderHeaderHeight {
    return 40.0;
}

#pragma mark - UI

- (UIView *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = QGCellbottomLineColor;
    }
    return _bottomLine;
}

- (UILabel *)orderIDLabel {
    if (_orderIDLabel == nil) {
        _orderIDLabel = [UILabel new];
        _orderIDLabel.textColor = [UIColor colorFromHexString:@"333333"];
    }
    return _orderIDLabel;
}

#pragma mark - Model

- (void)setGoods:(QGGoodsMO *)goods {
    _goods = goods;
    _orderIDLabel.text = goods.storeName;
}

- (void)setGoodsArray:(NSArray *)goodsArray{
    _goodsArray = goodsArray;
    BOOL select = YES;
    QGGoodsMO *goodsmo = [goodsArray firstObject];
    _orderIDLabel.text = goodsmo.storeName;
    for (QGGoodsMO *mo in goodsArray) {
        if (mo.selected.integerValue == 0) {
            select = NO;
            break;
        }
    }
    _Clickbutton.selected = select;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
