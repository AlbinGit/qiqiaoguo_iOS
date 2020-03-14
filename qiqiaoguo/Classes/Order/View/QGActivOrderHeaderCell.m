//
//  QGActivOrderHeaderCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGActivOrderHeaderCell.h"
#import "QGMallGoodsModell.h"

@interface QGActivOrderHeaderCell ()

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
@property (nonatomic, strong) UIView *LineView2;
@property (nonatomic, strong) UIImageView *logisticsImage;
@property (nonatomic, strong) UILabel *peopleNumLabel;

@property (nonatomic, strong) NSMutableArray *peopleLabelArr;

@end
@implementation QGActivOrderHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _peopleLabelArr = [NSMutableArray array];
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _addressLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _addressLabel.text = @"联系人:";
        _addressLabel.textColor = QGMainContentColor;
        
        _UserinfoLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _UserinfoLabel.textColor = QGMainContentColor;
        _UserinfoLabel.text = @"   ";
        
        _DetailedAddressLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _DetailedAddressLabel.numberOfLines = 2;
        _DetailedAddressLabel.text = @"   ";
        _DetailedAddressLabel.textColor = QGCellContentColor;
        
        _separatedView = [UIView new];
        _separatedView.backgroundColor = QGCellbottomLineColor;
        
        _logisticsDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsDetailLabel.text = @"参与者:";
        _logisticsDetailLabel.textColor = QGMainContentColor;
        
        _logisticsLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsLabel.textColor = QGMainRedColor;
        _logisticsLabel.text = @"   ";
        
        _logisticsTimeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _logisticsTimeLabel.textColor = QGMainContentColor;
        
        _logisticsButton = [UIButton new];
        
        _separated2View = [UIView new];
        _separated2View.backgroundColor = APPBackgroundColor;
        
        _orderGoodsLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _orderGoodsLabel.text = @"机构名称";
        _orderGoodsLabel.textColor = QGTitleColor;
        
        _LineView = [UIView new];
        _LineView.backgroundColor = QGCellbottomLineColor;
        
        _LineView2 = [UIView new];
        _LineView2.backgroundColor = QGCellbottomLineColor;
        
        _peopleNumLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _peopleNumLabel.textColor = QGTitleColor;
        
        _logisticsButton = [UIButton new];
        _logisticsImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell_arrow"]];
        
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
        [superview addSubview:_LineView2];
        [superview addSubview:_peopleNumLabel];
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
    
    _separatedView.height = QGOnePixelLineHeight;
    _separatedView.width = self.width - Margin*2;
    _separatedView.X = _addressLabel.X;
    _separatedView.Y = _addressLabel.maxY + 12;
    
    [_logisticsDetailLabel sizeToFit];
    _logisticsDetailLabel.X = _addressLabel.X;
    _logisticsDetailLabel.Y = _separatedView.maxY + 12;
    
    UIView *lastView = _separatedView;
    for (NSDictionary *dic in self.peopleLabelArr) {
        UILabel *titleLabel = dic[@"title"];
        UILabel *countLabel = dic[@"count"];
        [titleLabel sizeToFit];
        [countLabel sizeToFit];
        titleLabel.X = _logisticsDetailLabel.maxX + 4;
        if (lastView == _separatedView) {
            titleLabel.centerY = _logisticsDetailLabel.centerY;
        }else{
            titleLabel.Y = lastView.maxY + 12;
        }
        countLabel.X = self.width -  countLabel.width - Margin;
        countLabel.centerY = titleLabel.centerY;
        lastView = titleLabel;
    }
    

    _LineView2.X = Margin;
    _LineView2.width = self.width - Margin * 2;
    _LineView2.height = QGOnePixelLineHeight;
    _LineView2.Y = lastView.maxY + 12 - QGOnePixelLineHeight;
    
    [_peopleNumLabel sizeToFit];
    _peopleNumLabel.Y = _LineView2.maxY + 12;
    _peopleNumLabel.X = self.width - _peopleNumLabel.width - Margin;
    
    _separated2View.height = 10;
    _separated2View.width = self.width;
    _separated2View.X = 0;
    _separated2View.Y = _peopleNumLabel.maxY + 8;

    
    [_orderGoodsLabel sizeToFit];
    _orderGoodsLabel.X = Margin;
    _orderGoodsLabel.Y = _separated2View.maxY + 12;
    
    [_logisticsImage sizeToFit];
    _logisticsImage.X = _orderGoodsLabel.maxX+4;
    _logisticsImage.centerY = _orderGoodsLabel.centerY;
    
    _LineView.X = 0;
    _LineView.width = self.width;
    _LineView.height = QGOnePixelLineHeight;
    _LineView.Y = _orderGoodsLabel.maxY + 12 - QGOnePixelLineHeight;
    
    
    
    _logisticsButton.X = 0;
    _logisticsButton.Y = _separated2View.maxY;
    _logisticsButton.height = _LineView.Y - _separated2View.maxY;
    _logisticsButton.width = self.width;
    
    
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
    NSInteger count = 0;
    
     for (NSDictionary *dic in self.peopleLabelArr) {
        UIView *titleView = dic[@"title"];
        UIView *countView = dic[@"count"];
        [titleView removeFromSuperview];
        [countView removeFromSuperview];
    }
    [self.peopleLabelArr removeAllObjects];

    for (QGMallGoodsModell *model in self.order.goods) {
        count += model.Quantity;
        
        UILabel *peopleLabel = [UILabel new];
        peopleLabel.font = [UIFont systemFontOfSize:15];
        peopleLabel.textColor = QGCellContentColor;
        peopleLabel.text = [NSString stringWithFormat:@"%@ ¥%.2f",model.sizeStr,model.goodsPrice];
        
        UILabel *countLabel = [UILabel new];
        countLabel.font = [UIFont systemFontOfSize:15];
        countLabel.textColor = QGCellContentColor;
        countLabel.text = [NSString stringWithFormat:@"X%ld",(long)model.Quantity];
        [self addSubview:peopleLabel];
        [self addSubview:countLabel];
        NSDictionary *dic = @{@"title":peopleLabel,@"count":countLabel};
        [self.peopleLabelArr addObject:dic];
        
    }
    _peopleNumLabel.text = [NSString stringWithFormat:@"共有%ld人参与",(long)count];
    [self setNeedsLayout];
    [self layoutIfNeeded];
   
}

@end
