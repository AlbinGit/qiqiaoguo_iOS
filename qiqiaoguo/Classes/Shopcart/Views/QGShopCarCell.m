//
//  QGShopCarCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGShopCarCell.h"

@interface QGShopCarCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UILabel *goodsNoteLabel;
@property (nonatomic, strong) UILabel *goodsInventoryLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *goodsCountLabel;
@property (nonatomic, strong) UIButton *increaseButton; // 增加按钮
@property (nonatomic, strong) UIButton *ReductionButton; // 减少按钮
@property (nonatomic, strong) UIView *CellButtomLine;

@end

@implementation QGShopCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor whiteColor];
        
        _selectButton  = [UIButton new];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        [_selectButton setImage:[UIImage imageNamed:@"toy-deselected"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"toy-selected"] forState:UIControlStateSelected];
        [superview addSubview:_selectButton];
        
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
        _goodsInventoryLabel.textColor = QGCellContentColor;
        [superview addSubview:_goodsInventoryLabel];
        
        _goodsPriceLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _goodsPriceLabel.textColor = QGMainRedColor;
        [superview addSubview:_goodsPriceLabel];
        
        _goodsCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _goodsCountLabel.textAlignment = NSTextAlignmentCenter;
        _goodsCountLabel.textColor = QGTitleColor;
        [superview addSubview:_goodsCountLabel];
        
        _increaseButton = [UIButton new];
        [_increaseButton addTarget:self action:@selector(increaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_increaseButton setImage:[UIImage imageNamed:@"increase-no-use"] forState:UIControlStateDisabled];
        [_increaseButton setImage:[UIImage imageNamed:@"increase-use"] forState:UIControlStateNormal];
        _increaseButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        [superview addSubview:_increaseButton];
        
        _ReductionButton = [UIButton new];
        [_ReductionButton addTarget:self action:@selector(ReductionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ReductionButton setImage:[UIImage imageNamed:@"Reduction-no-use"] forState:UIControlStateDisabled];
        [_ReductionButton setImage:[UIImage imageNamed:@"Reduction-use"] forState:UIControlStateNormal];
        _ReductionButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        [superview addSubview:_ReductionButton];
        
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
    
    [_selectButton sizeToFit];
    _selectButton.X = 0;
    
    _goodsImageView.X = _selectButton.maxX;
    _goodsImageView.Y = Margin;
    _goodsImageView.height = 70;
    _goodsImageView.width = 70;
    
    [_goodsTitleLabel sizeToFit];
    _goodsTitleLabel.X = _goodsImageView.maxX + BLUThemeMargin *2;
    _goodsTitleLabel.Y = _goodsImageView.Y - 4;
    _goodsTitleLabel.width = self.width - Margin - _goodsTitleLabel.X;
    
    [_goodsInventoryLabel sizeToFit];
    CGSize noteSize = [_goodsNoteLabel sizeThatFits:CGSizeMake(self.width - _selectButton.width - _goodsImageView.width - _goodsInventoryLabel.width - Margin *2, MAXFLOAT)];
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
    
    [_increaseButton sizeToFit];
    _increaseButton.X = self.width - Margin - _increaseButton.width;
    _increaseButton.centerY = _goodsPriceLabel.centerY;
    
    [_goodsCountLabel sizeToFit];
    _goodsCountLabel.width = countLabel.width;
    _goodsCountLabel.X = _increaseButton.X - _goodsCountLabel.width - 4;
    _goodsCountLabel.centerY = _increaseButton.centerY;
    
    [_ReductionButton sizeToFit];
    _ReductionButton.X = _goodsCountLabel.X - _ReductionButton.width - 4;
    _ReductionButton.centerY = _goodsCountLabel.centerY;
    
    _CellButtomLine.X = self.X;
    _CellButtomLine.width = self.width;
    _CellButtomLine.height = QGOnePixelLineHeight;
    _CellButtomLine.Y = _goodsImageView.bottom + Margin - QGOnePixelLineHeight;
    
    _selectButton.height = _CellButtomLine.y;
    
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
    _goodsCountLabel.text = [NSString stringWithFormat:@"%@",goods.goodsCount];
    _selectButton.selected = goods.selected.integerValue;
    _selectButton.tag = goods.goodID.integerValue;
    _increaseButton.tag = goods.goodID.integerValue;
    _ReductionButton.tag = goods.goodID.integerValue;
    
    if (goods.goodsCount.integerValue >= goods.inventory.integerValue) {
        _increaseButton.enabled = NO;
    }else{
        _increaseButton.enabled= YES;
    }
    
    if (goods.goodsCount.integerValue <= 1) {
        _ReductionButton.enabled = NO;
    }else{
        _ReductionButton.enabled = YES;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)selectButtonClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(selectButtonClick:)]) {
        [self.delegate selectButtonClick:button];
    }
    
}

- (void)increaseButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(increaseButtonClick:)]) {
        [self.delegate increaseButtonClick:button];
    }
}


- (void)ReductionButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(ReductionButtonClick:)]) {
        [self.delegate ReductionButtonClick:button];
    }
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
