//
//  QGOrderListFooter.m
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGOrderListFooter.h"

@implementation QGOrderListFooter


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _contentMargin = BLUThemeMargin * 2;
        _separatorHeight = BLUThemeMargin * 1;
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        [superview addSubview:self.amountLabel];
        [superview addSubview:self.deleteButton];
        [superview addSubview:self.cancelButton];
        [superview addSubview:self.submitButton];
        [superview addSubview:self.separator];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superview).offset(self.contentMargin);
            make.centerY.equalTo(superview).offset(-_separatorHeight / 2.0);
        }];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superview).offset(-self.contentMargin);
            make.centerY.equalTo(self.amountLabel);
        }];
        
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superview).offset(-self.contentMargin);
            make.centerY.equalTo(self.amountLabel);
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.submitButton.mas_left).offset(-self.contentMargin);
            make.centerY.equalTo(self.amountLabel);
        }];
        
        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(superview);
            make.height.equalTo(@(_separatorHeight));
        }];
        
    }
    return self;
}

+ (CGFloat)userOrderFooterHeight {
    return 44.0;
}

#pragma mark - UI

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [UILabel new];
        _amountLabel.font = [UIFont systemFontOfSize:15];
        _amountLabel.textColor = [UIColor colorFromHexString:@"666666"];
    }
    return _amountLabel;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        NSString *title =
        NSLocalizedString(@"user-order-footer.delete-button.title",
                          @"Delete order");
        _deleteButton = [self createButtonWithColor:
                         [UIColor colorFromHexString:@"666666"]
                                              title:title];
        
    }
    return _deleteButton;;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        NSString *title =
        NSLocalizedString(@"user-order-footer.cancel-button.title",
                          @"Cancel order");
        _cancelButton = [self createButtonWithColor:
                         [UIColor colorFromHexString:@"c1c1c1"]
                                              title:title];
    }
    return _cancelButton;
}

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        NSString *title =
        NSLocalizedString(@"user-order.footer.submit-button.title",
                          @"Submit");
        _submitButton = [self createButtonWithColor:BLUThemeMainColor
                                              title:title];
    }
    return _submitButton;
}

- (UIButton *)createButtonWithColor:(UIColor *)color title:(NSString *)title{
    UIButton *button = [UIButton new];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    button.borderColor = color;
    button.borderWidth = 1.0;
    button.cornerRadius = BLUThemeNormalActivityCornerRadius;
    [button setTitle:[NSString stringWithFormat:@"  %@  ", title]
            forState:UIControlStateNormal];
    button.titleFont = BLUThemeMainFontWithSize(13);
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0);
    
    return button;
}

- (UIView *)separator {
    if (_separator == nil) {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor colorFromHexString:@"ececec"];
    }
    return _separator;
}

#pragma mark - Model

- (void)setOrder:(QGMallOrderModel *)order {
    _order = order;
    
    self.amountLabel.attributedText = [self amountTextWithOrder:_order];
    
    [self configWithStatus:_order.orderStatus];
}

- (NSAttributedString *)amountTextWithOrder:(QGMallOrderModel *)order {
    NSString *countStr = nil;
    
    NSInteger count =0;
    for (QGMallGoodsModell *model in order.goods) {
        count += model.Quantity;
    }
    
    switch (self.type) {
        case QGOrderFooterTypeMall:
            countStr = [NSString stringWithFormat:@"共%ld件商品 合计:", count];
            break;
        case QGOrderFooterTypeActiv:
            countStr = @"合计:";
            break;
            
        default:
            break;
    }
    
    NSString *amount = [NSString stringWithFormat:@"%@¥%.2f",countStr,order.orderAmount];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:amount];
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"333333"] range:NSMakeRange([countStr length], [amount length]-[countStr length])];
    return attrStr1;
}

- (void)configWithStatus:(QGMallOrderStatus)status {
    
    
    switch (status) {
        case QGMallOrderStatusCancel: {
            self.deleteButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.submitButton.hidden = YES;
        } break;
        case QGMallOrderStatusPayment: {
            self.deleteButton.hidden = YES;
            self.cancelButton.hidden = NO;
            self.submitButton.hidden = NO;
        } break;
        case QGMallOrderStatusComplete: {
            self.deleteButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.submitButton.hidden = YES;
        } break;
        case QGMallOrderStatusSystemGoodsBackFinish: {
            self.deleteButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.submitButton.hidden = YES;
        } break;
        default: {
            self.deleteButton.hidden = YES;
            self.cancelButton.hidden = YES;
            self.submitButton.hidden = YES;
        } break;
    }
}


@end
