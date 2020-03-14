//
//  BLUCircleBriefCell.m
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircleBriefCell.h"
#import "BLUCircle.h"
#import "BLUCircleMO.h"

static const CGFloat kCircleButtonHeight = 45.0;

@interface BLUCircleBriefCell ()

//@property (nonatomic, strong) UIButton *circleButton;
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *contentLabel;
//@property (nonatomic, strong) UIButton *addButton;
//@property (nonatomic, strong) UIButton *commentButton;
//@property (nonatomic, strong) UILabel *unreadPostCountLabel;
//
//@property (nonatomic, strong) BLUCircle *circle;
//@property (nonatomic, strong) BLUSolidLine *solidLine;

@end

@implementation BLUCircleBriefCell

#pragma mark - Life Circle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *superview = self.contentView;
        superview.layer.shouldRasterize = YES;
        superview.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        // Circle button
        _circleButton = [UIButton new];
        _circleButton.backgroundColor = [UIColor clearColor];
        _circleButton.size = CGSizeMake(kCircleButtonHeight, kCircleButtonHeight);
        _circleButton.userInteractionEnabled = NO;

        // TitleLabel
        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];

        // ContentLabel
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _contentLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);
        _contentLabel.numberOfLines = 1;

        // AddButton
        _addButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        [_addButton setImage:[[UIImage imageNamed:@"circle_join_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        _addButton.borderColor = BLUThemeMainColor;
//        _addButton.titleColor = BLUThemeMainColor;
//        _addButton.title = NSLocalizedString(@"circle-brief.add-button.title", @"Join");
        _addButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin, BLUThemeMargin, BLUThemeMargin, BLUThemeMargin);
        [_addButton addTarget:self action:@selector(joinCircleAction:) forControlEvents:UIControlEventTouchUpInside];

        // Comment button
        _commentButton = [UIButton new];
        _commentButton.titleFont = _contentLabel.font;
        _commentButton.titleColor = _contentLabel.textColor;
        _commentButton.image = [BLUCurrentTheme circlePostCountIcon];
        _commentButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        // Unread post count label
        _unreadPostCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _unreadPostCountLabel.backgroundColor = BLUThemeMainColor;
        _unreadPostCountLabel.textColor = [UIColor whiteColor];
        _unreadPostCountLabel.textAlignment = NSTextAlignmentCenter;

        [superview addSubview:_circleButton];
        [superview addSubview:_titleLabel];
        [superview addSubview:_contentLabel];
        [superview addSubview:_addButton];
        [superview addSubview:_commentButton];
        [superview addSubview:_solidLine];
        [superview addSubview:_unreadPostCountLabel];

        _commentButton.hidden = YES;

        _showSeparatorLine = YES;
        _showQuit = NO;
        _showUnreadPostCount = NO;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _unreadPostCountLabel.hidden = YES;
    _unreadPostCountLabel.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Circle
    _circleButton.frame = CGRectMake(BLUThemeMargin * 2, BLUThemeMargin * 3, kCircleButtonHeight, kCircleButtonHeight);
//    _circleButton.layer.masksToBounds = YES;
//    _circleButton.layer.cornerRadius = kCircleButtonHeight/2;
    
    // Comment & Title & Add
    [_addButton sizeToFit];
    [_commentButton sizeToFit];
    [_titleLabel sizeToFit];
    [_unreadPostCountLabel sizeToFit];
    _unreadPostCountLabel.width += BLUThemeMargin;
    _unreadPostCountLabel.height += BLUThemeMargin;
    _unreadPostCountLabel.width = _unreadPostCountLabel.width > _unreadPostCountLabel.height ? _unreadPostCountLabel.width : _unreadPostCountLabel.height;

    CGFloat rightOffset = _unreadPostCountLabel.width > _addButton.width ? _unreadPostCountLabel.width : _addButton.width;
    CGFloat maxTitleLabelWidth = self.contentView.width - _commentButton.width - _circleButton.width - rightOffset - BLUThemeMargin * 8;
    CGFloat titleLabelWidth = _titleLabel.width > maxTitleLabelWidth ? maxTitleLabelWidth : _titleLabel.width;

    _titleLabel.frame = CGRectMake(_circleButton.right + BLUThemeMargin * 2, _circleButton.top + BLUThemeMargin, titleLabelWidth, _titleLabel.height);

    _commentButton.frame = CGRectMake(_titleLabel.right + BLUThemeMargin * 2, _titleLabel.bottom - _commentButton.height, _commentButton.width, _commentButton.height);

    _addButton.frame = CGRectMake(self.contentView.width - _addButton.width - BLUThemeMargin * 3, 0, _addButton.width, _addButton.height+1);
    _addButton.centerY = self.contentView.centerY;

    _unreadPostCountLabel.frame = CGRectMake(self.contentView.width - _unreadPostCountLabel.width - BLUThemeMargin * 2, 0, _unreadPostCountLabel.width, _unreadPostCountLabel.height);
    _unreadPostCountLabel.centerY = _circleButton.centerY;
    _unreadPostCountLabel.cornerRadius = _unreadPostCountLabel.height / 2;
    if (!_showUnreadPostCount) {
        _unreadPostCountLabel.frame = CGRectZero;
    }

    // Content
    [_contentLabel sizeToFit];
    _contentLabel.frame = CGRectMake(_circleButton.right + BLUThemeMargin * 2, _circleButton.bottom - _contentLabel.height, self.contentView.width - _circleButton.width - _unreadPostCountLabel.width - BLUThemeMargin * 8, _contentLabel.height);
   
    _solidLine.frame = CGRectMake(BLUThemeMargin * 2, _circleButton.bottom + BLUThemeMargin * 3, self.contentView.width - BLUThemeMargin * 4, BLUThemeOnePixelHeight);
    
    // Size
    self.cellSize = CGSizeMake(self.contentView.width, _circleButton.bottom + BLUThemeMargin * 2);
}

+ (CGSize)sizeForLayoutedCellWith:(CGFloat)width sharedCell:(BLUCell *)cell {
    CGSize size = CGSizeMake(width, kCircleButtonHeight + [BLUCurrentTheme margin] * 6 + 1);
    return size;
}

- (void)            setModel:(id)model
     shouldShowSeparatorLine:(BOOL)showSeparatorLine
              shouldShowQuit:(BOOL)showQuit
   shouldShowUnreadPostCount:(BOOL)showUnreadPostCount
        circleActionDelegate:(id<BLUCircleActionDelegate>)circleActionDelegate {
//    NSParameterAssert([model isKindOfClass:[BLUCircle class]]);

    _circle = (BLUCircle *)model;

    _showSeparatorLine = showSeparatorLine;
    _showQuit = showQuit;
    _showUnreadPostCount = showUnreadPostCount == YES && (_circle.unreadPostCount > 0) && (showQuit == NO);
    _circleActionDelegate = circleActionDelegate;

    _titleLabel.text = self.circle.name;
    _contentLabel.text = self.circle.slogan;
    _commentButton.title = [NSString stringWithFormat:@"%@", @(_circle.postCount)];
    if (_showUnreadPostCount) {
        _unreadPostCountLabel.text = [NSString stringWithFormat:@"%@", _circle.unreadPostCount > 99 ? @"99+" : @(_circle.unreadPostCount)];
        _unreadPostCountLabel.hidden = NO;
    } else {
        _unreadPostCountLabel.text = nil;
        _unreadPostCountLabel.hidden = YES;
    }
    _solidLine.hidden = !_showSeparatorLine;

    _circleButton.image = nil;
    if (!self.cellForCalcingSize) {
        _circleButton.imageURL = self.circle.logo.thumbnailURL;
    }

    if (self.showQuit) {
        _addButton.hidden = NO;
        if (self.circle.didFollowCircle) {
            [_addButton setImage:[[UIImage imageNamed:@"circle_quit_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//            _addButton.title = NSLocalizedString(@"circle-brief.add-button.title.quit", @"Quit");
//            _addButton.image = [UIImage imageNamed:@"circle_quit_icon"];
//            _addButton.titleColor = [UIColor grayColor];
//            _addButton.borderColor = [UIColor grayColor];
        } else {
            [_addButton setImage:[[UIImage imageNamed:@"circle_join_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//            _addButton.title = NSLocalizedString(@"circle-brief.add-button.title", @"Join");
//            _addButton.image = [UIImage imageNamed:@"circle_join_icon"];
//            _addButton.titleColor = BLUThemeMainColor;
//            _addButton.borderColor = BLUThemeMainColor;
        }
    } else {
        _addButton.hidden = self.circle.didFollowCircle;
        [_addButton setImage:[[UIImage imageNamed:@"circle_join_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        _addButton.image = [UIImage imageNamed:@"circle_join_icon"];
//        _addButton.title = NSLocalizedString(@"circle-brief.add-button.title", @"Join");
    }
}

- (void)setShowSeparatorLine:(BOOL)showSeparatorLine {
    _showSeparatorLine = showSeparatorLine;
    self.solidLine.hidden = !showSeparatorLine;
}

- (void)joinCircleAction:(id)sender {
    if (self.circle) {
        if (self.circle.didFollowCircle) {
            if ([self.circleActionDelegate respondsToSelector:@selector(shouldUnfollowCircle:fromView:sender:)]) {
                NSDictionary *circleInfo = @{BLUCircleKeyCircle: self.circle};
                [self.circleActionDelegate shouldUnfollowCircle:circleInfo fromView:self sender:sender];
            }
        } else {
            if ([self.circleActionDelegate respondsToSelector:@selector(shouldFollowCircle:fromView:sender:)]) {
                NSDictionary *circleInfo = @{BLUCircleKeyCircle: self.circle};
                [self.circleActionDelegate shouldFollowCircle:circleInfo fromView:self sender:sender];
            }
        }
    }
}

@end
