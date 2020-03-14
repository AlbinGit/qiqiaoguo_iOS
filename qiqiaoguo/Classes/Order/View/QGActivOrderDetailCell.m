//
//  QGActivOrderDetailCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGActivOrderDetailCell.h"
#import "QGMallGoodsModell.h"
@interface QGActivOrderDetailCell ()

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *goodsImage;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *goodsCountLabel;

@property (nonatomic, strong)UILabel *speciesLabel;

@property (nonatomic, strong)UIView *LineView;

@property (nonatomic, strong)UIButton *afterSalesButton;

@end
@implementation QGActivOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = APPBackgroundColor;
        // Prompt image view
        _goodsImage = [UIImageView new];
        [superview addSubview:_goodsImage];
        
        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        [superview addSubview:_titleLabel];
        
//        _priceLabel =[UILabel makeThemeLabelWithType:BLULabelTypeTitle];
//        [superview addSubview:_priceLabel];
//        
//        _goodsCountLabel =[UILabel makeThemeLabelWithType:BLULabelTypeTitle];
//        [superview addSubview:_goodsCountLabel];
//        
//        _afterSalesButton = [UIButton new];
//        [superview addSubview:_afterSalesButton];
        
        _speciesLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _speciesLabel.textColor = QGCellContentColor;
        [superview addSubview:_speciesLabel];
        
        _LineView = [UIView new];
        _LineView.backgroundColor =[UIColor whiteColor];
        [superview addSubview:_LineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat Margin = BLUThemeMargin * 4;
    
    _goodsImage.frame = CGRectMake(Margin, Margin, 90, 60);
    _goodsImage.backgroundColor = [UIColor redColor];
    
    [_titleLabel sizeToFit];
    _titleLabel.Y = _goodsImage.Y - BLUThemeMargin;
    _titleLabel.x = _goodsImage.maxX + Margin;
    _titleLabel.width = self.width - _goodsImage.width - Margin * 3;
    
    [_speciesLabel sizeToFit];
    _speciesLabel.X = _titleLabel.X;
    _speciesLabel.centerY = _goodsImage.centerY;
    
    _LineView.X = self.X;
    _LineView.width = self.width;
    _LineView.height = QGOnePixelLineHeight;
    _LineView.Y = _goodsImage.bottom + Margin - QGOnePixelLineHeight;
    
    self.cellSize = CGSizeMake(self.contentView.width, _LineView.maxY);
}

- (void)setOrder:(QGActivOrderModel *)order{
    
    _order = order;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:order.coverPicOrgImage]];
    _titleLabel.text = order.activTitle;
    _speciesLabel.text = order.typeName;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
