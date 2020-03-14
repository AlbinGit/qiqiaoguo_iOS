//
//  QGMillSingleStoreCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/14.
//
//

#import "QGMillSingleStoreCell.h"


@interface QGMillSingleStoreCell ()

@property (nonatomic, strong)UILabel *TitleLabel;
@property (nonatomic, strong)UIImageView *goodsImageView;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UIView *LineView;
@property (nonatomic, strong)UILabel *goodsCountLabel;

@end


@implementation QGMillSingleStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _TitleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _TitleLabel.numberOfLines = 2;
        
        _priceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeBoldTitle];
        _priceLabel.textColor = QGMainRedColor;
        
        _goodsImageView = [UIImageView new];
        
        _LineView = [UIView new];
        _LineView.backgroundColor = QGCellbottomLineColor;
        
        _goodsCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeSub];
        _goodsCountLabel.textColor = QGCellContentColor;
        
        [self addSubview:_TitleLabel];
        [self addSubview:_priceLabel];
        [self addSubview:_LineView];
        [self addSubview:_goodsCountLabel];
        [self addSubview:_goodsImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat Margin = BLUThemeMargin * 4;
    _goodsImageView.frame = CGRectMake(Margin, Margin, 70, 70);
    
    _TitleLabel.width = self.width - _goodsImageView.maxX - Margin - BLUThemeMargin *2;
    [_TitleLabel sizeToFit];
    _TitleLabel.X = _goodsImageView.maxX + BLUThemeMargin * 2;
    _TitleLabel.Y = _goodsImageView.Y;
    
    [_priceLabel sizeToFit];
    _priceLabel.X = _goodsImageView.maxX + BLUThemeMargin * 2;
    _priceLabel.Y = _goodsImageView.maxY - _priceLabel.height;
    
    [_goodsCountLabel sizeToFit];
    _goodsCountLabel.X = _priceLabel.maxX + BLUThemeMargin * 2;
    _goodsCountLabel.Y = _priceLabel.maxY - _goodsCountLabel.height- 2;
    
    _LineView.X = _TitleLabel.X;
    _LineView.Y = _goodsImageView.maxY + Margin - QGOnePixelLineHeight;
    _LineView.width = self.width - _goodsImageView.maxX - BLUThemeMargin * 2;
    _LineView.height = QGOnePixelLineHeight;
    
//    self.cellSize = CGSizeMake(self.contentView.width, _goodsImageView.bottom + Margin);
}

- (NSMutableAttributedString *)configTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Global-purchasing-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"Global-purchasing-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}

- (void)setSingModel:(QGSingleStoreModel *)singModel {
    _singModel = singModel;
    
    
    if (_singModel.delivery_type.integerValue == 3) {
        _TitleLabel.attributedText = [self configTitle:_singModel.title];
    }else{
        _TitleLabel.text = _singModel.title;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",singModel.sales_price.floatValue];
    
    _goodsCountLabel.text = [NSString stringWithFormat:@"月销%ld份",singModel.sales_volume.integerValue];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:singModel.coverpath]];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
