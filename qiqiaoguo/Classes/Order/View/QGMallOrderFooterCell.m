//
//  QGMallOrderFooterCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGMallOrderFooterCell.h"

@interface QGMallOrderFooterCell ()

@property (nonatomic, strong) UILabel *orderTotalLabel;
@property (nonatomic, strong) UILabel *orderTotalPriceLabel;

@property (nonatomic, strong) UILabel *goodsTotalLabel;
@property (nonatomic, strong) UILabel *goodsTotalPriceLabel;
@property (nonatomic, strong) UILabel *postageLabel;
@property (nonatomic, strong) UILabel *postagePriceLabel;
@property (nonatomic, strong) UILabel *meassageLabel;
@property (nonatomic, strong) UILabel *meassageDetailLabel;

@property (nonatomic, strong) UIView *separatedView;
@property (nonatomic, strong) UILabel *orderInfoLabel;

@property (nonatomic, strong) UILabel *orderIDLabel;
@property (nonatomic, strong) UILabel *orderIDDetailLabel;
@property (nonatomic, strong) UILabel *paywayLabel;
@property (nonatomic, strong) UILabel *paywayDetailLabel;
@property (nonatomic, strong) UILabel *creatTimeLabel;
@property (nonatomic, strong) UILabel *creatTimeDetailLabel;
@property (nonatomic, strong) UILabel *deliveryTimeLabel;
@property (nonatomic, strong) UILabel *deliveryTimeDetailLabel;

@property (nonatomic, strong) UIView *Line2View;
@property (nonatomic, strong) UIView *LineView;

@end

@implementation QGMallOrderFooterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _orderTotalLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _orderTotalLabel.text = @"订单总额";
        _orderTotalLabel.textColor = QGTitleColor;
        
        _orderTotalPriceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _orderTotalPriceLabel.textColor = QGMainRedColor;
        
        _goodsTotalLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _goodsTotalLabel.text = @"商品总额:";
        _goodsTotalLabel.textColor = QGCellContentColor;
        
        _goodsTotalPriceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _goodsTotalPriceLabel.textColor = QGCellContentColor;
        
        _postageLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _postageLabel.text = @"邮费:";
        _postageLabel.textColor = QGCellContentColor;
        
        _postagePriceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _postagePriceLabel.textColor = QGCellContentColor;
        
        _meassageLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _meassageLabel.text = @"买家留言:";
        _meassageLabel.textColor = QGCellContentColor;
        
        _meassageDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _meassageDetailLabel.text = @"无";
        _meassageDetailLabel.textColor = QGCellContentColor;
        

        _separatedView = [UIView new];
        _separatedView.backgroundColor = APPBackgroundColor;
        
        _orderInfoLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _orderInfoLabel.text = @"订单信息";
        _orderInfoLabel.textColor = QGTitleColor;
        
        _orderIDLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _orderIDLabel.text = @"订单编号:";
        _orderIDLabel.textColor = QGCellContentColor;
        
        _orderIDDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _orderIDDetailLabel.textColor = QGCellContentColor;
        
        _paywayLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _paywayLabel.text = @"付款方式:";
        _paywayLabel.textColor = QGCellContentColor;
        
        _paywayDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _paywayDetailLabel.textColor = QGCellContentColor;
        
        _creatTimeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _creatTimeLabel.text = @"创建时间:";
        _creatTimeLabel.textColor = QGCellContentColor;
        
        _creatTimeDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _creatTimeDetailLabel.textColor = QGCellContentColor;
        
        _deliveryTimeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _deliveryTimeLabel.text = @"发货时间:";
        _deliveryTimeLabel.textColor = QGCellContentColor;
        
        _deliveryTimeDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _deliveryTimeDetailLabel.textColor = QGCellContentColor;

        _LineView = [UIView new];
        _LineView.backgroundColor = QGCellbottomLineColor;
        _Line2View = [UIView new];
        _Line2View.backgroundColor = QGCellbottomLineColor;
        
        [superview addSubview:_orderTotalLabel];
        [superview addSubview:_orderTotalPriceLabel];
        [superview addSubview:_goodsTotalLabel];
        [superview addSubview:_goodsTotalPriceLabel];
        [superview addSubview:_postageLabel];
        [superview addSubview:_postagePriceLabel];
        [superview addSubview:_meassageLabel];
        [superview addSubview:_meassageDetailLabel];
        [superview addSubview:_separatedView];
        [superview addSubview:_orderInfoLabel];
        [superview addSubview:_orderIDLabel];
        [superview addSubview:_orderIDDetailLabel];
        [superview addSubview:_paywayLabel];
        [superview addSubview:_paywayDetailLabel];
        [superview addSubview:_creatTimeLabel];
        [superview addSubview:_creatTimeDetailLabel];
        [superview addSubview:_deliveryTimeLabel];
        [superview addSubview:_deliveryTimeDetailLabel];
        [superview addSubview:_Line2View];
        [superview addSubview:_LineView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat Margin = BLUThemeMargin * 3;
    
    [_orderTotalLabel sizeToFit];
    _orderTotalLabel.Y = Margin;
    _orderTotalLabel.x = Margin + BLUThemeMargin;
    
    [_orderTotalPriceLabel sizeToFit];
    _orderTotalPriceLabel.Y = _orderTotalLabel.Y;
    _orderTotalPriceLabel.x = self.width - _orderTotalPriceLabel.width - Margin;
    
    _LineView.x = 0;
    _LineView.width = self.width;
    _LineView.height = QGOnePixelLineHeight;
    _LineView.Y = _orderTotalLabel.maxY + 8 - QGOnePixelLineHeight;
    
    [_goodsTotalLabel sizeToFit];
    _goodsTotalLabel.Y = _LineView.maxY + 8;
    _goodsTotalLabel.x = _orderTotalLabel.X;
    
    [_goodsTotalPriceLabel sizeToFit];
    _goodsTotalPriceLabel.Y = _goodsTotalLabel.Y;
    _goodsTotalPriceLabel.x = self.width - _goodsTotalPriceLabel.width - Margin;
    
    [_postageLabel sizeToFit];
    _postageLabel.Y = _goodsTotalLabel.maxY + 8;
    _postageLabel.x = _orderTotalLabel.X;
    
    [_postagePriceLabel sizeToFit];
    _postagePriceLabel.Y = _postageLabel.Y;
    _postagePriceLabel.x = self.width - _postagePriceLabel.width - Margin;
    
    [_meassageLabel sizeToFit];
    _meassageLabel.Y = _postageLabel.maxY + 8;
    _meassageLabel.x = _orderTotalLabel.X;
    
    _meassageDetailLabel.width = self.width - _meassageLabel.maxX - 8 - Margin;
    [_meassageDetailLabel sizeToFit];
    _meassageDetailLabel.Y = _meassageLabel.Y;
    _meassageDetailLabel.x = _meassageLabel.maxX + 8;
    
    _separatedView.x = 0;
    _separatedView.Y = _meassageLabel.maxY + Margin;
    _separatedView.height = 10;
    _separatedView.width =self.width;
    
    [_orderInfoLabel sizeToFit];
    _orderInfoLabel.x = _orderTotalLabel.x;
    _orderInfoLabel.Y = _separatedView.maxY +Margin;
    
    _Line2View.x = 0;
    _Line2View.width = self.width;
    _Line2View.height = QGOnePixelLineHeight;
    _Line2View.Y = _orderInfoLabel.maxY + Margin - QGOnePixelLineHeight;
    
    [_orderIDLabel sizeToFit];
    _orderIDLabel.x = _orderTotalLabel.x;
    _orderIDLabel.Y = _Line2View.maxY + 8;
    
    [_orderIDDetailLabel sizeToFit];
    _orderIDDetailLabel.Y = _orderIDLabel.Y;
    _orderIDDetailLabel.x = _orderIDLabel.maxX + 8;
    
    [_paywayLabel sizeToFit];
    _paywayLabel.x = _orderTotalLabel.x;
    _paywayLabel.Y = _orderIDLabel.maxY + 8;
    
    [_paywayDetailLabel sizeToFit];
    _paywayDetailLabel.Y = _paywayLabel.Y;
    _paywayDetailLabel.x = _paywayLabel.maxX + 8;
    
    [_creatTimeLabel sizeToFit];
    _creatTimeLabel.x = _orderTotalLabel.x;
    _creatTimeLabel.Y = _paywayLabel.maxY + 8;
    
    [_creatTimeDetailLabel sizeToFit];
    _creatTimeDetailLabel.Y = _creatTimeLabel.Y;
    _creatTimeDetailLabel.x = _creatTimeLabel.maxX + 8;
    
    [_deliveryTimeLabel sizeToFit];
    _deliveryTimeLabel.x = _orderTotalLabel.x;
    _deliveryTimeLabel.Y = _creatTimeLabel.maxY + 8;
    
    [_deliveryTimeDetailLabel sizeToFit];
    _deliveryTimeDetailLabel.Y = _deliveryTimeLabel.Y;
    _deliveryTimeDetailLabel.x = _deliveryTimeLabel.maxX + 8;
    
    CGFloat cellSizeHeight = _deliveryTimeLabel.hidden ? _creatTimeLabel.maxY + 8 :_deliveryTimeLabel.maxY + 8;
    self.cellSize = CGSizeMake(self.contentView.width, cellSizeHeight);
}

- (void)setOrder:(QGMallOrderModel *)order{
    _order = order;
    _orderTotalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",order.orderAmount];
    _goodsTotalPriceLabel.text = [NSString stringWithFormat:@"¥%@",order.goodsAmount];
    _postagePriceLabel.text = [NSString stringWithFormat:@"¥%@",order.deliveryAmount];
    _orderIDDetailLabel.text = [NSString stringWithFormat:@"%@",order.orderNum];

    _meassageDetailLabel.text = order.orderMark.length > 0 ? order.orderMark : @"无";
    _paywayDetailLabel.text = order.PayTypeName;
    _creatTimeDetailLabel.text = order.create_time;
    
    _deliveryTimeDetailLabel.hidden = NO;
    _deliveryTimeLabel.hidden = NO;
    switch (order.orderStatus) {
        case QGMallOrderStatusPayment: {
             _deliveryTimeDetailLabel.text = @"待支付";
            _deliveryTimeDetailLabel.hidden = YES;
            _deliveryTimeLabel.hidden = YES;
            break;
        }
        case QGMallOrderStatusPrepare: {
            _deliveryTimeDetailLabel.text = @"正在备货";
            _deliveryTimeDetailLabel.hidden = YES;
            _deliveryTimeLabel.hidden = YES;
            break;
        }
        case QGMallOrderStatusSend: {
            _deliveryTimeDetailLabel.text = @"正在备货";
            _deliveryTimeDetailLabel.hidden = YES;
            _deliveryTimeLabel.hidden = YES;
            break;
        }
        case QGMallOrderStatusCancel:{
            _paywayDetailLabel.text = @"已取消";
            _deliveryTimeDetailLabel.hidden = YES;
            _deliveryTimeLabel.hidden = YES;
            break;
        }
        case QGMallOrderStatusSystemRefunding:{
            _deliveryTimeDetailLabel.hidden = YES;
            _deliveryTimeLabel.hidden = YES;
            break;
        }
        case QGMallOrderStatusSystemRefundFinish:{
            _deliveryTimeDetailLabel.hidden = YES;
            _deliveryTimeLabel.hidden = YES;
            break;
        }

            default:
             _deliveryTimeDetailLabel.text = order.shipping_time;
            break;
    }
   
    
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
