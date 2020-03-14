//
//  QGAboutCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//

#import "QGAboutCell.h"


static const CGFloat kHeightOfLogo = 80;

@interface QGAboutCell ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *buildLabel;

@end

@implementation QGAboutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = BLUThemeSubTintBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _logoImageView = [UIImageView new];
        _logoImageView.image = [BLUCurrentTheme appLogo];
        _logoImageView.cornerRadius = BLUThemeNormalActivityCornerRadius;
        [self.contentView addSubview:_logoImageView];
        
        _nameLabel = [UILabel new];
        _nameLabel.text = [NSString appName];
        _nameLabel.font =  BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeLarge);
        [self.contentView addSubview:_nameLabel];
        
        _versionLabel = [UILabel new];

        _versionLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:[NSString stringWithFormat:@"V%@", [NSString appVersion]]];
        _versionLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        _versionLabel.textColor = BLUThemeSubTintContentForegroundColor;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.numberOfLines = 0;
        [self.contentView addSubview:_versionLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _logoImageView.frame = CGRectMake(0, 8 * BLUThemeMargin, kHeightOfLogo, kHeightOfLogo);
    _logoImageView.centerX = self.contentView.centerX;
    
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(0, _logoImageView.bottom + 2 * BLUThemeMargin, _nameLabel.width, _nameLabel.height);
    _nameLabel.centerX = _logoImageView.centerX;
    
    [_versionLabel sizeToFit];
    _versionLabel.frame = CGRectMake(0, _nameLabel.bottom + 2 * BLUThemeMargin, _versionLabel.width, _versionLabel.height);
    _versionLabel.centerX = _logoImageView.centerX;
    
    self.cellSize = CGSizeMake(self.contentView.width, _versionLabel.bottom + 8 * BLUThemeMargin);
}


@end
