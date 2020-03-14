//
//  QGorderListHeader.m
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGorderListHeader.h"

@implementation QGorderListHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _contentMargin = BLUThemeMargin * 4;
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell_arrow"]];
        _Clickbutton = [UIButton new];
        
        [superview addSubview:_Clickbutton];
        [superview addSubview:_arrowImage];
        [superview addSubview:self.bottomLine];
        [superview addSubview:self.orderIDLabel];
        [superview addSubview:self.stateLabel];
        
        [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superview);
            make.left.equalTo(superview).offset(self.contentMargin);
        }];
        
        [_arrowImage sizeToFit];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_orderIDLabel);
            make.left.equalTo(_orderIDLabel.mas_right).offset(4);
        }];
        
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superview);
            make.right.equalTo(superview).offset(-self.contentMargin);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(QGOnePixelLineHeight));
        }];
        
        [self.Clickbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.equalTo(self);
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

- (UILabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [UILabel new];
        _stateLabel.textColor = [UIColor colorFromHexString:@"99999"];
    }
    return _stateLabel;
}

#pragma mark - Model

- (void)setOrder:(QGMallOrderModel *)order {
    _order = order;
    self.orderIDLabel.text = order.shopName;
    self.stateLabel.text = order.orderStatusName;
    switch (order.orderStatus) {
        case QGMallOrderStatusPayment: {
//            self.stateLabel.text = @"待支付";
            self.stateLabel.textColor = [UIColor colorFromHexString:@"ffb400"];
            break;
        }
        case QGMallOrderStatusSend: {
//            self.stateLabel.text = @"正在备货";
            self.stateLabel.textColor = [UIColor colorFromHexString:@"ffb400"];
            break;
        }
        case QGMallOrderStatusDidSend: {
//            self.stateLabel.text = @"已发货";
            self.stateLabel.textColor = [UIColor colorFromHexString:@"ffb400"];
            break;
        }
        case QGMallOrderStatusComplete: {
//            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = [UIColor colorFromHexString:@"999999"];
            break;
        }
        case QGMallOrderStatusCancel: {
//            self.stateLabel.text = @"已取消";
            self.stateLabel.textColor = [UIColor colorFromHexString:@"999999"];
            break;
        }
        default:{
            self.stateLabel.textColor = [UIColor colorFromHexString:@"ffb400"];
            break;
        }
    }
}


@end
