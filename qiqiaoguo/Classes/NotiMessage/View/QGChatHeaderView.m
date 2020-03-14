//
//  QGChatHeaderView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/31.
//
//

#import "QGChatHeaderView.h"

@implementation QGChatHeaderView

- (instancetype)initWithGoodMO:(id)good {
    
    if (self = [super init]) {
        
        _good = good;
        
        _contentInsets = UIEdgeInsetsMake(BLUThemeMargin * 4,
                                          BLUThemeMargin * 3,
                                          BLUThemeMargin * 4,
                                          BLUThemeMargin * 3);
        
        _containerInsets = UIEdgeInsetsMake(0, 0,
                                            BLUThemeMargin * 4, 0);
        
        _elementSpacing = BLUThemeMargin * 2;
        
        _imageSize = CGSizeMake(70, 70);
        
        [self addSubview:self.containerView];
        UIView *superview = self.containerView;
        [superview addSubview:self.goodImageView];
        [superview addSubview:self.nameLabel];
        [superview addSubview:self.priceLabel];
        [superview addSubview:self.sendButton];
        
        [self configUI];
        
        
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)configUI
{
    
    if ([_good isKindOfClass:[QGStoreDetailModel class]]) {
        QGStoreDetailModel *model = _good;
        self.nameLabel.text = model.item.title;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.item.sales_price];
        [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.item.coverpath]];
    }else if([_good isKindOfClass:[QGCourseDetaiResultModel class]]){
        QGCourseDetaiResultModel *model = _good;
        self.nameLabel.text = model.item.title;
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.item.class_price];
        [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.item.cover_path]];
        [_sendButton setTitle:@"发送课程链接"forState:UIControlStateNormal];
    }else if ([_good isKindOfClass:[QGEduTeacherDetailResultModel class]]){
        QGEduTeacherDetailResultModel *model = _good;
        self.nameLabel.text = model.item.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.item.signature];
        [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.item.head_img]];
        [_sendButton setTitle:@"发送教师链接"forState:UIControlStateNormal];
    }else if ([_good isKindOfClass:[QGActlistDetailResultModel class]]){
        QGActlistDetailResultModel *model = _good;
        self.nameLabel.text = model.item.title;
        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.item.price];
        [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.item.coverPicPop]];
        [_sendButton setTitle:@"发送活动链接"forState:UIControlStateNormal];
    }else if ([_good isKindOfClass:[QGShopDetailsModel class]]){
        QGShopDetailsModel *model = _good;
        self.nameLabel.text = model.item.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.item.signature];
        [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.item.cover_photo]];
        [_sendButton setTitle:@"发送机构链接"forState:UIControlStateNormal];
    }
    

    self.containerView.backgroundColor = [UIColor whiteColor];
    self.goodImageView.frame =
    CGRectMake(self.contentInsets.left, self.contentInsets.top,
               self.imageSize.width, self.imageSize.height);
    
    CGFloat containerWidth = MAIN_SCREEN_WIDTH - self.containerInsets.left - self.containerInsets.right;
    self.containerView.frame = CGRectMake(self.containerInsets.left,
                                          self.containerInsets.top,
                                          containerWidth,
                                          self.goodImageView.bottom +
                                          self.contentInsets.bottom + 30);
    
    CGFloat nameX = self.goodImageView.right + self.elementSpacing;
    CGFloat nameMaxWidth = CGRectGetWidth(self.containerView.frame)- nameX -
    self.contentInsets.right;
    CGSize nameSize =
    [self.nameLabel sizeThatFits:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)];
    self.nameLabel.frame =
    CGRectMake(nameX, self.goodImageView.y + BLUThemeMargin * 2,
               nameMaxWidth, nameSize.height);
    
    CGSize priceSize =
    [self.priceLabel sizeThatFits:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)];
    self.priceLabel.frame =
    CGRectMake(nameX, self.nameLabel.bottom + self.elementSpacing,
               priceSize.width, priceSize.height);
    
    CGSize sendSize =
    [self.sendButton sizeThatFits:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)];
    CGFloat sendY = self.goodImageView.bottom +  BLUThemeMargin * 2;
    self.sendButton.frame =
    CGRectMake(0, sendY,
               sendSize.width, sendSize.height);
    self.sendButton.centerX = self.containerView.centerX;
}



- (UIImageView *)goodImageView {
    if (_goodImageView == nil) {
        _goodImageView = [UIImageView new];
        _goodImageView.cornerRadius = 5;
        _goodImageView.backgroundColor = BLUThemeSubTintBackgroundColor;
    }
    return _goodImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _nameLabel.textColor = [UIColor colorFromHexString:@"333333"];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [UILabel new];
        _priceLabel.font =  BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _priceLabel.textColor = BLUThemeMainColor;
        _priceLabel.numberOfLines = 1;
    }
    return _priceLabel;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton new];
        _sendButton.borderColor = BLUThemeMainColor;
        _sendButton.borderWidth = 1.0;
        _sendButton.cornerRadius = BLUThemeNormalActivityCornerRadius;
        _sendButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        _sendButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin,
                                                         BLUThemeMargin * 8,
                                                         BLUThemeMargin,
                                                         BLUThemeMargin * 8);
        [_sendButton setTitleColor:BLUThemeMainColor
                          forState:UIControlStateNormal];
        [_sendButton setTitle:NSLocalizedString(@"chat-good-hint-cell.send-button.title",
                                                @"Send toy url")
                     forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}



@end
