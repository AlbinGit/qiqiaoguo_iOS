//
//  QGActivOrderCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGActivOrderCell.h"

@interface QGActivOrderCell ()

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *goodsImage;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *goodsCountLabel;

@property (nonatomic, strong)UILabel *speciesLabel;

@property (nonatomic, strong)UIView *LineView;

@property (nonatomic, strong)UIButton *afterSalesButton;

@end

@implementation QGActivOrderCell

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
        
        _priceLabel =[UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        [superview addSubview:_priceLabel];
        
        _goodsCountLabel =[UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        [superview addSubview:_goodsCountLabel];
        
        _afterSalesButton = [UIButton new];
        [superview addSubview:_afterSalesButton];
        
        _speciesLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _speciesLabel.textColor = QGCellContentColor;
        _speciesLabel.numberOfLines = 1;
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
    
    [_titleLabel sizeToFit];
    _titleLabel.Y = _goodsImage.Y - BLUThemeMargin;
    _titleLabel.x = _goodsImage.maxX + Margin;
    _titleLabel.width = self.width - _goodsImage.width - Margin * 3;
    
    [_priceLabel sizeToFit];
    _priceLabel.Y = _goodsImage.maxY - _priceLabel.height + BLUThemeMargin;
    _priceLabel.x = _titleLabel.x;
    
    [_goodsCountLabel sizeToFit];
    _goodsCountLabel.Y = _goodsImage.maxY - _goodsCountLabel.height + BLUThemeMargin;
    _goodsCountLabel.x = self.width - _goodsCountLabel.width - Margin;
    
    [_speciesLabel sizeToFit];
    _speciesLabel.X = _titleLabel.X;
    _speciesLabel.centerY = _goodsImage.centerY;
    
    _LineView.X = self.X;
    _LineView.width = self.width;
    _LineView.height = QGOnePixelLineHeight;
    _LineView.Y = _goodsImage.bottom + Margin - QGOnePixelLineHeight;
    
    self.cellSize = CGSizeMake(self.contentView.width, _LineView.maxY);
}

- (void)setOrder:(QGMallGoodsModell *)order{
    
    _order = order;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:order.imageStr]];

   // _titleLabel.text = order.title;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",order.goodsPrice];
    _goodsCountLabel.text = [NSString stringWithFormat:@"x%ld",order.Quantity];
    _speciesLabel.text = order.sizeStr;
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}
- (void)setOrderType:(NSInteger)orderType {
    _orderType = orderType;
    
        if ([[@(orderType) stringValue] isEqualToString:@"13"] || [[@(orderType) stringValue] isEqualToString:@"14"] ) {
            _titleLabel.attributedText = [self configTitle: _order.title];
        }else {
           _titleLabel.text = _order.title;
        }
//    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

- (NSMutableAttributedString *)configTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"audition-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"audition-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}
@end
