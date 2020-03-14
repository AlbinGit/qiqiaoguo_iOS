//
//  BLUChatGoodHintCell.m
//  Blue
//
//  Created by Bowen on 23/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUChatGoodHintCell.h"
//#import "BLUGoodMO.h"
#import "BLUImageMO.h"

@implementation BLUChatGoodHintCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _contentInsets = UIEdgeInsetsMake(BLUThemeMargin * 4,
                                          BLUThemeMargin * 3,
                                          BLUThemeMargin * 4,
                                          BLUThemeMargin * 3);

        _containerInsets = UIEdgeInsetsMake(BLUThemeMargin * 4, 0,
                                            BLUThemeMargin * 4, 0);

        _elementSpacing = BLUThemeMargin * 2;

        _imageSize = CGSizeMake(80, 80);

        [self.contentView addSubview:self.containerView];
        UIView *superview = self.containerView;
        [superview addSubview:self.goodImageView];
        [superview addSubview:self.nameLabel];
        [superview addSubview:self.priceLabel];
        [superview addSubview:self.sendButton];

        self.contentView.backgroundColor = BLUThemeSubTintBackgroundColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.goodImageView.frame =
    CGRectMake(self.contentInsets.left, self.contentInsets.top,
               self.imageSize.width, self.imageSize.height);

    CGFloat nameX = self.goodImageView.right + self.elementSpacing;
    CGFloat nameMaxWidth = self.contentView.width - nameX -
    self.contentInsets.right;
    CGSize nameSize =
    [self.nameLabel sizeThatFits:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)];
    self.nameLabel.frame =
    CGRectMake(nameX, self.goodImageView.y,
               nameSize.width, nameSize.height);

    CGSize priceSize =
    [self.priceLabel sizeThatFits:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)];
    self.priceLabel.frame =
    CGRectMake(nameX, self.nameLabel.bottom + self.elementSpacing,
               priceSize.width, priceSize.height);

    CGSize sendSize =
    [self.sendButton sizeThatFits:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)];
    CGFloat sendY = self.goodImageView.bottom - sendSize.height;
    self.sendButton.frame =
    CGRectMake(nameX, sendY,
               sendSize.width, sendSize.height);

    self.containerView.frame = CGRectMake(self.containerInsets.left,
                                          self.containerInsets.top,
                                          self.contentView.width -
                                          self.containerInsets.left -
                                          self.containerView.right,
                                          self.goodImageView.bottom +
                                          self.contentInsets.bottom);

    self.cellSize = CGSizeMake(self.contentView.width,
                               self.containerView.bottom);
}

- (void)setModel:(id)model {
    [super setModel:model];
//    BLUGoodMO *goodMO = (BLUGoodMO *)model;

//    self.nameLabel.text = goodMO.name;
//    self.priceLabel.text = goodMO.price.stringValue;
    self.containerView.backgroundColor = [UIColor whiteColor];

//    if (!self.cellForCalcingSize) {
//        [self.goodImageView sd_setImageWithURL:goodMO.logo.thumbnailURL];
//    }
}

- (UIImageView *)goodImageView {
    if (_goodImageView == nil) {
        _goodImageView = [UIImageView new];
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
                                                         BLUThemeMargin * 2,
                                                         BLUThemeMargin,
                                                         BLUThemeMargin * 2);
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
