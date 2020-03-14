//
//  BLUUserIndicatorCell.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserIndicatorCell.h"

static const CGFloat kAvatarButtonHeight = 32;
static const CGFloat kIndicatorImageViewHeight = 16;

@interface BLUUserIndicatorCell ()

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *infoTypeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) BLUSolidLine *solidLine;
@property (nonatomic, strong) BLUUser *user;

@end

@implementation BLUUserIndicatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        
        // Avatar button
        _avatarButton = [BLUAvatarButton new];
        [superview addSubview:_avatarButton];
       
        // Info type label
        _infoTypeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _infoTypeLabel.textColor = BLUThemeMainDeepContentForegroundColor;
        [superview addSubview:_infoTypeLabel];
        
        // Content label
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _contentLabel.textColor = BLUThemeSubTintContentForegroundColor;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [superview addSubview:_contentLabel];
        
        // Indicator image view
        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage imageNamed:@"common-navigation-right-gray-icon"];
        [superview addSubview:_indicatorImageView];
        
        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [superview addSubview:_solidLine];
        
        // Test
        _avatarButton.backgroundColor = [UIColor randomColor];
        _contentLabel.text = @"Content";
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    UIView *superview = self.contentView;
  
    CGFloat leftToCell = [BLUCurrentTheme leftMargin] * 4;
    CGFloat rightToCell = leftToCell;
    CGFloat leftToInfoLabel = [BLUCurrentTheme leftMargin] * 26;
    CGFloat topToCell = [BLUCurrentTheme topMargin] * 3;
    CGFloat margin = [BLUCurrentTheme leftMargin] * 2;
    
    // Avatar button
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.left.equalTo(superview).offset(leftToCell);
        make.height.width.equalTo(@(kAvatarButtonHeight));
    }];
    
    // Info type label
    [_infoTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel);
        make.left.equalTo(superview).offset(leftToCell);
    }];
    
    // Content label
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).offset(topToCell);
        make.left.equalTo(superview).offset(leftToInfoLabel);
        make.right.equalTo(_indicatorImageView.mas_left).offset(-margin);
    }];
    
    // Indicator image view
    [_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.height.width.equalTo(@(kIndicatorImageViewHeight));
        make.right.equalTo(superview).offset(-rightToCell);
    }];
    
    // Solid line
    [_solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).offset(leftToCell);
        make.right.equalTo(superview).offset(-rightToCell);
        make.bottom.equalTo(superview);
        make.height.equalTo(@(BLUThemeOnePixelHeight));
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutSubviews];
    
    _avatarButton.cornerRadius = _avatarButton.width / 2;
    
    CGFloat bottom = (_infoTypeLabel.bottom > _contentLabel.bottom ? _infoTypeLabel.bottom : _contentLabel.bottom) + [BLUCurrentTheme margin] * 3;
    self.cellSize = CGSizeMake(self.contentView.width, bottom);
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}

- (void)setShowSeparatorLine:(BOOL)showSeparatorLine {
    _showSeparatorLine = showSeparatorLine;
    self.solidLine.hidden = !showSeparatorLine;
}

- (void)setInfoType:(NSString *)infoType {
    _infoType = infoType;
    _infoTypeLabel.text = infoType;
    _infoTypeLabel.hidden = NO;
    _avatarButton.hidden = YES;
}

- (void)setAvatarURL:(NSURL *)avatarURL {
    _avatarURL = avatarURL;
    _avatarButton.imageURL = avatarURL;
//    _avatarButton.backgroundColor = [UIColor randomColor];
    _avatarButton.hidden = NO;
    _infoTypeLabel.hidden = YES;
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarButton.image = avatarImage;
//    _avatarButton.backgroundColor = [UIColor randomColor];
    _avatarButton.hidden = NO;
    _infoTypeLabel.hidden = YES;
}

- (void)setShouldShowIndicator:(BOOL)shouldShowIndicator {
    _indicatorImageView.hidden = !shouldShowIndicator;
}

@end
