//
//  QGMallOrderHeaderCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGMallOrderHeaderCell.h"

@interface QGMallOrderHeaderCell ()

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *UserinfoLabel;
@property (nonatomic, strong) UILabel *DetailedAddressLabel;
@property (nonatomic, strong) UILabel *logisticsDetailLabel;
@property (nonatomic, strong) UILabel *logisticsLabel;
@property (nonatomic, strong) UILabel *logisticsTimeLabel;
@property (nonatomic, strong) UIView *separatedView;
@property (nonatomic, strong) UIView *separated2View;
@property (nonatomic, strong) UILabel *orderGoodsLabel;
@property (nonatomic, strong) UIView *LineView;
@property (nonatomic, strong) UIImageView *logisticsImage;
@property (nonatomic, strong) UIImageView *arrowImage;

@end

@implementation QGMallOrderHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _addressLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _addressLabel.text = @"收货地址:";
        _addressLabel.textColor = QGMainContentColor;
        
        _UserinfoLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _UserinfoLabel.textColor = QGMainContentColor;
        _UserinfoLabel.text = @"   ";
        
        _DetailedAddressLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _DetailedAddressLabel.numberOfLines = 2;
        _DetailedAddressLabel.text = @"   ";
        _DetailedAddressLabel.textColor = QGCellContentColor;
        
        _separatedView = [UIView new];
        _separatedView.backgroundColor = APPBackgroundColor;
        
        _logisticsDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsDetailLabel.text = @"订单动态:";
        _logisticsDetailLabel.textColor = QGMainContentColor;
        
        _logisticsLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsLabel.textColor = QGMainRedColor;
        _logisticsLabel.text = @"   ";
        
        _logisticsTimeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsTimeLabel.textColor = QGMainContentColor;
        
        _logisticsButton = [UIButton new];
        _StoreButton = [UIButton new];
        
        _separated2View = [UIView new];
        _separated2View.backgroundColor = APPBackgroundColor;
        
        _orderGoodsLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _orderGoodsLabel.text = @"店铺名称";
        _orderGoodsLabel.textColor = QGTitleColor;

        _LineView = [UIView new];
        _LineView.backgroundColor = QGCellbottomLineColor;
        
        _logisticsImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell_arrow"]];
        
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell_arrow"]];
        
        [superview addSubview:_arrowImage];
        [superview addSubview:_StoreButton];
        [superview addSubview:_logisticsImage];
        [superview addSubview:_addressLabel];
        [superview addSubview:_UserinfoLabel];
        [superview addSubview:_DetailedAddressLabel];
        [superview addSubview:_separatedView];
        [superview addSubview:_logisticsDetailLabel];
        [superview addSubview:_logisticsLabel];
        [superview addSubview:_logisticsTimeLabel];
        [superview addSubview:_separated2View];
        [superview addSubview:_orderGoodsLabel];
        [superview addSubview:_LineView];
        [superview addSubview:_logisticsButton];
        
        }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat Margin = BLUThemeMargin * 4;
    
    [_addressLabel sizeToFit];
    _addressLabel.Y = Margin;
    _addressLabel.x = Margin;
    
    [_UserinfoLabel sizeToFit];
    _UserinfoLabel.Y = _addressLabel.Y;
    _UserinfoLabel.x = _addressLabel.maxX + 8;
    _UserinfoLabel.width = self.width - _addressLabel.width - 40;
    
   CGSize DetailAddLabelSize = [_DetailedAddressLabel sizeThatFits:CGSizeMake(_UserinfoLabel.width, CGFLOAT_MAX)];
    _DetailedAddressLabel.Y = _UserinfoLabel.maxY + 8;
    _DetailedAddressLabel.x = _UserinfoLabel.X;
    _DetailedAddressLabel.width = DetailAddLabelSize.width;
    _DetailedAddressLabel.height = DetailAddLabelSize.height;
    
    _separatedView.height = 10;
    _separatedView.width = self.width;
    _separatedView.X = 0;
    _separatedView.Y = _DetailedAddressLabel.maxY + 12;
    
    [_logisticsDetailLabel sizeToFit];
    _logisticsDetailLabel.X = _addressLabel.X;
    _logisticsDetailLabel.Y = _separatedView.maxY + 8;
    
    [_logisticsLabel sizeToFit];
    _logisticsLabel.X = _logisticsDetailLabel.maxX + 8;
    _logisticsLabel.Y = _logisticsDetailLabel.Y;
    _logisticsLabel.width = self.width - _logisticsDetailLabel.width - 40;
    
    [_logisticsTimeLabel sizeToFit];
    _logisticsTimeLabel.X = _logisticsDetailLabel.maxX + 8;
    _logisticsTimeLabel.Y = _logisticsLabel.maxY + 8;

    
    _separated2View.height = 10;
    _separated2View.width = self.width;
    _separated2View.X = 0;
    
    if (_logisticsTimeLabel.text.length > 0) {
        
        _separated2View.Y = _logisticsTimeLabel.maxY + 8;
    }else{
        
        _separated2View.Y = _logisticsLabel.maxY + 8;
    }
    
    _logisticsButton.X = 0;
    _logisticsButton.Y = _separatedView.maxY;
    _logisticsButton.height = _separated2View.Y - _separatedView.maxY;
    _logisticsButton.width = self.width;
    
    
    [_logisticsImage sizeToFit];
    _logisticsImage.X = self.width - Margin - _logisticsImage.width;
    _logisticsImage.centerY = _logisticsButton.centerY;
    
    [_orderGoodsLabel sizeToFit];
    _orderGoodsLabel.X = Margin;
    _orderGoodsLabel.Y = _separated2View.maxY + 12;
    
    [_arrowImage sizeToFit];
    _arrowImage.centerY = _orderGoodsLabel.centerY;
    _arrowImage.x = _orderGoodsLabel.maxX + 4;
    
    _StoreButton.x = 0;
    _StoreButton.Y = _separated2View.maxY;
    _StoreButton.width = self.width;
    _StoreButton.height = 20 + _orderGoodsLabel.height;
    
    _LineView.X = 0;
    _LineView.width = self.width;
    _LineView.height = QGOnePixelLineHeight;
    _LineView.Y = _orderGoodsLabel.maxY + 12 - QGOnePixelLineHeight;
    
    self.cellSize = CGSizeMake(self.contentView.width, _LineView.maxY);
}

- (void)setOrder:(QGMallOrderModel *)order{
    _order = order;
    
    _UserinfoLabel.text = [NSString stringWithFormat:@"%@ %@",order.buyerName,order.buyerTel];
    _DetailedAddressLabel.text = order.buyerAddress;
    _orderGoodsLabel.text = order.shopName;
    
    [self configLogisticsInfo];
    
}

- (void)configLogisticsInfo{
    _logisticsButton.enabled = NO;
    _logisticsImage.hidden = YES;
    switch (self.order.orderStatus) {
        case QGMallOrderStatusPayment: {
            _logisticsLabel.text = @"待付款";
            break;
        }
        case QGMallOrderStatusPrepare: {
            _logisticsLabel.text = @"正在备货";
            break;
        }
        case QGMallOrderStatusCancel: {
            _logisticsLabel.text = @"已取消";
            break;
        }
        case QGMallOrderStatusSend: {
            _logisticsLabel.text = @"正在备货";
            break;
        }
        case QGMallOrderStatusComplete: {
            _logisticsLabel.text = @"已完成";
            break;
        }
        case QGMallOrderStatusSystemRefund:{
            _logisticsLabel.text = @"退款处理中";
            break;
        }
            default:
        {
            _logisticsImage.hidden = NO;
            _logisticsLabel.text = self.order.logisticsInfo;
//            NSLog(@"%@",self.order);
//            if (_logisticsLabel.text.length < 1) {
//               _logisticsLabel.text = @"正在备货";
//            }
            _logisticsTimeLabel.text = self.order.logisticsTime;
            _logisticsButton.enabled = YES;
            
        }break;

    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}

@end
