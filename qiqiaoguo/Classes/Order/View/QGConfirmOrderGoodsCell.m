//
//  QGConfirmOrderGoodsCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGConfirmOrderGoodsCell.h"

@interface QGConfirmOrderGoodsCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UILabel *goodsNoteLabel;
@property (nonatomic, strong) UILabel *goodsInventoryLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *goodsCountLabel;
@property (nonatomic, strong) UIView *CellButtomLine;

@end

@implementation QGConfirmOrderGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _goodsImageView = [UIImageView new];
        [superview addSubview:_goodsImageView];
        
        _goodsTitleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _goodsTitleLabel.textColor = QGTitleColor;
        [superview addSubview:_goodsTitleLabel];
        
        _goodsNoteLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _goodsNoteLabel.textColor = QGCellContentColor;
        _goodsNoteLabel.numberOfLines = 1;
        [superview addSubview:_goodsNoteLabel];
        
        _goodsInventoryLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _goodsInventoryLabel.numberOfLines = 1;
        _goodsInventoryLabel.textColor = QGCellContentColor;
        [superview addSubview:_goodsInventoryLabel];
        
        _goodsPriceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _goodsPriceLabel.textColor = QGMainRedColor;
        [superview addSubview:_goodsPriceLabel];
        
        _goodsCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
//        _goodsCountLabel.textAlignment = NSTextAlignmentCenter;
        _goodsCountLabel.textColor = QGMainContentColor;
        [superview addSubview:_goodsCountLabel];
        
        _CellButtomLine = [UIView new];
        _CellButtomLine.backgroundColor = QGCellbottomLineColor;
        [superview addSubview:_CellButtomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UILabel *countLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    countLabel.text = @"1000";
    [countLabel sizeToFit];
    
    CGFloat Margin = BLUThemeMargin * 4;
    
    
    _goodsImageView.X = Margin;
    _goodsImageView.Y = Margin;
    _goodsImageView.height = 70;
    _goodsImageView.width = 70;
    
    [_goodsTitleLabel sizeToFit];
    _goodsTitleLabel.X = _goodsImageView.maxX + BLUThemeMargin *2;
    _goodsTitleLabel.Y = _goodsImageView.Y - 4;
    _goodsTitleLabel.width = self.width - Margin - _goodsTitleLabel.X;
    
    [_goodsInventoryLabel sizeToFit];
    CGSize noteSize = [_goodsNoteLabel sizeThatFits:CGSizeMake(self.width - _goodsImageView.width - _goodsInventoryLabel.width - Margin *2, MAXFLOAT)];
    [_goodsNoteLabel sizeToFit];
    _goodsNoteLabel.X = _goodsTitleLabel.X;
    _goodsNoteLabel.Y = _goodsTitleLabel.maxY + 4;
    if (_goodsNoteLabel.width > noteSize.width) {
        _goodsNoteLabel.width = noteSize.width;
    }
    
    _goodsInventoryLabel.X = _goodsNoteLabel.maxX + BLUThemeMargin * 2;
    _goodsInventoryLabel.Y = _goodsNoteLabel.Y;
    
    [_goodsPriceLabel sizeToFit];
    _goodsPriceLabel.X = _goodsTitleLabel.X;
    _goodsPriceLabel.Y = _goodsImageView.maxY - _goodsPriceLabel.height + 4;
    
    
    [_goodsCountLabel sizeToFit];
    _goodsCountLabel.X = self.width - _goodsCountLabel.width - BLUThemeMargin * 4;
    _goodsCountLabel.centerY = _goodsPriceLabel.centerY;
    
    _CellButtomLine.X = self.X;
    _CellButtomLine.width = self.width;
    _CellButtomLine.height = QGOnePixelLineHeight;
    _CellButtomLine.Y = _goodsImageView.bottom + Margin - QGOnePixelLineHeight;
    
    
    self.cellSize = CGSizeMake(self.contentView.width, _goodsImageView.bottom + Margin);
}

- (void)setGoods:(QGGoodsMO *)goods
{
    _goods = goods;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goods.goodsImage]];
    
    if (goods.deliveryType.integerValue == 3) {
        // 全球购商品
        _goodsTitleLabel.attributedText = [self configTitle:goods.name];
    }else{
        _goodsTitleLabel.text = goods.name;
    }
    
    if ([goods.note hasPrefix:@"请选择"]) {
        
    }else{
        _goodsNoteLabel.text = goods.note;
    }
    _goodsInventoryLabel.text = [NSString stringWithFormat:@"库存:%@",goods.inventory];
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",goods.price];
    _goodsCountLabel.text = [NSString stringWithFormat:@"X %@",goods.goodsCount];
//    _selectButton.selected = goods.selected.integerValue;
//    _selectButton.tag = goods.goodID.integerValue;
//    _increaseButton.tag = goods.goodID.integerValue;
//    _ReductionButton.tag = goods.goodID.integerValue;
    
//    if (goods.goodsCount.integerValue >= goods.inventory.integerValue) {
//        _increaseButton.enabled = NO;
//    }else{
//        _increaseButton.enabled= YES;
//    }
//    
//    if (goods.goodsCount.integerValue <= 1) {
//        _ReductionButton.enabled = NO;
//    }else{
//        _ReductionButton.enabled = YES;
//    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
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
    //    [attri appendAttributedString:string];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}


@end
