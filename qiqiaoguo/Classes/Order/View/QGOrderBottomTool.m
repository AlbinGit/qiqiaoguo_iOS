//
//  QGQGOrderBottomTool.m
//  qiqiaoguo
//
//  Created by cws on 16/7/20.
//
//

#import "QGOrderBottomTool.h"
#import "QGTimerLabel.h"
#import "QGCommon.h"

@interface QGOrderBottomTool ()

@property (nonatomic, strong)UILabel *timeHoursLabel;
@property (nonatomic, strong)UILabel *timeMinuteLabel;
@property (nonatomic, strong)UILabel *timeSecondLabel;

@property (nonatomic, strong)UILabel *colonLabel;
@property (nonatomic, strong)UILabel *colonLabel2;

@property (nonatomic,strong )QGTimerLabel *timeLabel;
@property (nonatomic,strong )QGTimerLabel *timeLabel2;
@property (nonatomic,strong )QGTimerLabel *timeLabel3;

@property (nonatomic, assign)BOOL isTimeDwon;

@end

@implementation QGOrderBottomTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superview = self;
        superview.backgroundColor = [UIColor whiteColor];
        self.width = SCREEN_WIDTH;
        self.height = 44;
        
        _timeHoursLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _timeHoursLabel.backgroundColor = [UIColor blackColor];
        _timeHoursLabel.textColor = [UIColor whiteColor];
        _timeHoursLabel.cornerRadius = 3;
        
        _timeMinuteLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _timeMinuteLabel.backgroundColor = [UIColor blackColor];
        _timeMinuteLabel.textColor = [UIColor whiteColor];
        _timeMinuteLabel.cornerRadius = 3;
        
        _timeSecondLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _timeSecondLabel.backgroundColor = [UIColor blackColor];
        _timeSecondLabel.textColor = [UIColor whiteColor];
        _timeSecondLabel.cornerRadius = 3;
        
        _colonLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _colonLabel.text = @":";
        _colonLabel.textColor = [UIColor blackColor];
        
        _colonLabel2 = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _colonLabel2.text = @":";
        _colonLabel2.textColor = [UIColor blackColor];
        
        _amountLabel = [UILabel new];
        _amountLabel.text = @"付款剩余时间";
        _amountLabel.font = [UIFont systemFontOfSize:15];
        _amountLabel.textColor = [UIColor colorFromHexString:@"666666"];
        
        
        _timeHoursLabel.hidden = YES;
        _timeMinuteLabel.hidden = YES;
        _timeSecondLabel.hidden = YES;
        _colonLabel.hidden = YES;
        _colonLabel2.hidden = YES;
        
        [self addSubview:_colonLabel];
        [self addSubview:_colonLabel2];
        [self addSubview:_timeSecondLabel];
        [self addSubview:_timeMinuteLabel];
        [self addSubview:_timeHoursLabel];
        [self addSubview:_amountLabel];
        
        
        _courierButton = [self createButtonWithColor:
                          [UIColor colorFromHexString:@"c1c1c1"]
                                               title:@"查看物流"];
        _afterSalesButton = [self createButtonWithColor:QGMainRedColor
                                                  title:@"申请售后"];
        
        
        _confirmGoodsButton = [self createButtonWithColor:QGMainRedColor
                                                  title:@"确认收货"];
        
        _refundButton = [self createButtonWithColor:QGMainRedColor title:@"申请退款"];
        
        
        
        
        [self addSubview:_refundButton];
        [self addSubview:_confirmGoodsButton];
        [self addSubview:_afterSalesButton];
        [self addSubview:_courierButton];
        [self addSubview:self.deleteButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.submitButton];
        [self addSubview:self.separator];

        for (UIView *view in self.subviews) {
            view.hidden = YES;
        }
    }
    return self;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        NSString *title =@"删除订单";
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
        _submitButton = [self createButtonWithColor:QGMainRedColor
                                              title:title];
    }
    return _submitButton;
}

- (UIButton *)createButtonWithColor:(UIColor *)color title:(NSString *)title{
    UIButton *button = [UIButton new];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:QGMainContentColor forState:UIControlStateDisabled];
    button.borderColor = color;
    button.borderWidth = 1.0;
    button.cornerRadius = BLUThemeNormalActivityCornerRadius;
    [button setTitle:[NSString stringWithFormat:@"%@", title]
            forState:UIControlStateNormal];
    button.titleFont = BLUThemeMainFontWithSize(13);
    button.contentEdgeInsets = UIEdgeInsetsMake(6, 12, 6, 12);
    
    return button;
}

- (UIView *)separator {
    if (_separator == nil) {
        _separator = [UIView new];
        _separator.backgroundColor = QGCellbottomLineColor;
    }
    return _separator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _contentMargin = BLUThemeMargin * 2;
    _separatorHeight = BLUThemeMargin * 1;
    
    [_amountLabel sizeToFit];
    self.amountLabel.X = _contentMargin;
    self.amountLabel.centerY = self.height/2;
    
//    [_timeHoursLabel sizeToFit];
    _timeHoursLabel.width = self.amountLabel.height;
    _timeHoursLabel.height = self.amountLabel.height;
    _timeHoursLabel.X = _amountLabel.maxX + 4;
    _timeHoursLabel.centerY = _amountLabel.centerY;
    
    [_colonLabel sizeToFit];
    _colonLabel.X = _timeHoursLabel.maxX;
    _colonLabel.centerY = _timeHoursLabel.centerY;
    
    _timeMinuteLabel.width = self.amountLabel.height;
    _timeMinuteLabel.height = self.amountLabel.height;
    _timeMinuteLabel.X = _colonLabel.maxX;
    _timeMinuteLabel.centerY = _timeHoursLabel.centerY;
    
    [_colonLabel2 sizeToFit];
    _colonLabel2.X = _timeMinuteLabel.maxX;
    _colonLabel2.centerY = _timeMinuteLabel.centerY;
    
    _timeSecondLabel.width = self.amountLabel.height;
    _timeSecondLabel.height = self.amountLabel.height;
    _timeSecondLabel.X = _timeMinuteLabel.maxX + 4;
    _timeSecondLabel.centerY = _timeMinuteLabel.centerY;
    
    [self.deleteButton sizeToFit];
    self.deleteButton.X = self.width - _deleteButton.width - _contentMargin;
    self.deleteButton.centerY = self.height/2;

    [self.submitButton sizeToFit];
    self.submitButton.X = self.width - _submitButton.width - _contentMargin;
    self.submitButton.centerY = self.height/2;
    
    [self.cancelButton sizeToFit];
    if (self.submitButton.hidden) {
        self.cancelButton.X = self.width - _cancelButton.width - _contentMargin;
    }else{
        self.cancelButton.X = _submitButton.X - _cancelButton.width - _contentMargin;
    }
    self.cancelButton.centerY = self.height/2;
    
    [self.afterSalesButton sizeToFit];
    if (self.deleteButton.hidden) {
        self.afterSalesButton.X = self.width - _afterSalesButton.width - _contentMargin;
        self.afterSalesButton.centerY = self.height/2;
    }else{
        self.afterSalesButton.X = self.deleteButton.X - self.refundButton.width - _contentMargin;
        self.afterSalesButton.centerY = self.height/2;
    }

    
    [self.confirmGoodsButton sizeToFit];
    self.confirmGoodsButton.X = _afterSalesButton.X - _confirmGoodsButton.width - _contentMargin;
    self.confirmGoodsButton.centerY = self.height/2;
    
    [self.courierButton sizeToFit];
    self.courierButton.X = _confirmGoodsButton.X - _courierButton.width - _contentMargin;
    self.courierButton.centerY = self.height/2;
    
    [self.refundButton sizeToFit];
    if (self.deleteButton.hidden) {
        self.refundButton.X = self.width - self.refundButton.width - _contentMargin;
        self.refundButton.centerY = self.height/2;
    }else{
        self.refundButton.X = self.deleteButton.X - self.refundButton.width - _contentMargin;
        self.refundButton.centerY = self.height/2;
    }

    
    self.separator.X = 0;
    self.separator.Y = 0;
    self.separator.width =self.width;
    self.separator.height = QGOnePixelLineHeight;
    
}

#pragma mark - Model

- (void)setOrder:(QGMallOrderModel *)order {
    _order = order;
    [self configTime];
    [self configWithStatus:_order.orderStatus];

}

- (void)configTime{

    [_timeLabel reset];
    [_timeLabel2 reset];
    [_timeLabel3 reset];
    
    if(!_isTimeDwon){
        _timeLabel = [[QGTimerLabel alloc] initWithLabel:_timeHoursLabel andTimerType:QGTimerLabelTypeTimer];
        _timeLabel.timeFormat= @"HH";
        _timeLabel2 = [[QGTimerLabel alloc] initWithLabel:_timeMinuteLabel andTimerType:QGTimerLabelTypeTimer];
        _timeLabel2.timeFormat= @"mm";
        _timeLabel3 = [[QGTimerLabel alloc] initWithLabel:_timeSecondLabel andTimerType:QGTimerLabelTypeTimer];
        _timeLabel3.timeFormat= @"ss";
        
        _isTimeDwon = YES;
    }

    
    NSInteger timeInval= self.order.remainingTime/1000;
    //获取剩余小时数
    NSInteger remainingHours2=timeInval%(24*3600);
    
    [_timeLabel setCountDownTime:remainingHours2];
    [_timeLabel start];
    [_timeLabel2 setCountDownTime:remainingHours2];
    [_timeLabel2 start];
    [_timeLabel3 setCountDownTime:remainingHours2];
    [_timeLabel3 start];
    

    
}

- (void)configWithStatus:(QGMallOrderStatus)status {
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    
    
    switch (status) {
        case QGMallOrderStatusCancel: {
            self.deleteButton.hidden = NO;
        } break;
        case QGMallOrderStatusPayment: {
            _colonLabel.hidden = NO;
            _colonLabel2.hidden = NO;
            self.timeHoursLabel.hidden = NO;
            self.timeMinuteLabel.hidden = NO;
            self.timeSecondLabel.hidden = NO;
            self.amountLabel.hidden = NO;
            self.cancelButton.hidden = NO;
            self.submitButton.hidden = NO;
        } break;
        case QGMallOrderStatusPrepare: {
            _refundButton.hidden = NO;
            _refundButton.enabled = YES;
        } break;
        case QGMallOrderStatusSend: {
            self.refundButton.hidden = NO;
            _refundButton.enabled = YES;
        } break;
        case QGMallOrderStatusDidSend: {
            self.courierButton.hidden = NO;
            self.confirmGoodsButton.hidden = NO;
            self.afterSalesButton.hidden = NO;
        } break;
        case QGMallOrderStatusComplete:{
            self.afterSalesButton.hidden = NO;
            self.deleteButton.hidden = NO;
            break;
        }
        case QGMallOrderStatusSystemRefund: {
            self.refundButton.hidden = NO;
            self.refundButton.title = @"退款处理中";
            self.refundButton.enabled = NO;
            self.refundButton.borderColor = QGMainContentColor;
            break;
        }
        case QGMallOrderStatusSystemRefunding: {
            self.refundButton.hidden = NO;
            self.refundButton.title = @"退款中";
            self.refundButton.enabled = NO;
            self.refundButton.borderColor = QGMainContentColor;
            break;
        }
        case QGMallOrderStatusSystemRefundFinish: {
            self.refundButton.hidden = NO;
            self.refundButton.title = @"已退款";
            self.refundButton.enabled = NO;
            self.refundButton.borderColor = QGMainContentColor;
            self.deleteButton.enabled = NO;
            break;
        }
        case QGMallOrderStatusSystemRefundFailure: {
            self.refundButton.hidden = NO;
            self.refundButton.title = @"退款失败";
            self.refundButton.enabled = NO;
            self.refundButton.borderColor = QGMainContentColor;
            break;
        }
        case QGMallOrderStatusSystemGoodsBack: {
            
            break;
        }
        case QGMallOrderStatusSystemGoodsBacking: {
            self.afterSalesButton.hidden = NO;
            self.courierButton.hidden = NO;
            self.confirmGoodsButton.hidden = NO;
            self.afterSalesButton.title = @"处理中";
            self.afterSalesButton.enabled = NO;
            break;
        }
        case QGMallOrderStatusSystemGoodsBackFinish: {
            self.afterSalesButton.hidden = NO;
            self.courierButton.hidden = NO;
            self.confirmGoodsButton.hidden = NO;
            self.afterSalesButton.title = @"已退货";
            self.afterSalesButton.enabled = NO;
            break;
        }
        case QGMallOrderStatusSystemExchange: {
            self.deleteButton.hidden = NO;
            break;
        }
            
        default: {
        } break;
    }
    
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
