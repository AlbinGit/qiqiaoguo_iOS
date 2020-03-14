//
//  BLUMessageCell.m
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUDynamicCell.h"
#import "BLUDynamic.h"

@interface BLUDynamicCell ()

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *detailWrapper;
@property (nonatomic, strong) BLUGenderButton *genderButton;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIImageView *detailTriangle;

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) BLUDynamic *dynamic;

@property (nonatomic, assign) BOOL showDetail;

@end

@implementation BLUDynamicCell

#pragma mark - UITableViewCell.

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIView *superview = self.contentView;
        superview.backgroundColor = BLUThemeSubTintBackgroundColor;

        _container = [UIView new];
        _container.backgroundColor = BLUThemeMainTintBackgroundColor;
        _container.cornerRadius = BLUThemeHighActivityCornerRadius;

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeSubTintBackgroundColor;
        [_avatarButton addTarget:self action:@selector(transitToUserAction:) forControlEvents:UIControlEventTouchUpInside];

//        _genderButton = [BLUGenderButton new];

        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nicknameLabel.numberOfLines = 1;
        _nicknameLabel.textColor = [UIColor colorFromHexString:@"999999"];

        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _titleLabel.textColor = [UIColor colorFromHexString:@"666666"];
        _titleLabel.numberOfLines = 1;

        _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _timeLabel.textColor = [UIColor colorFromHexString:@"c1c1c1"];
        _timeLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeNormal);

        _detailWrapper = [UIView new];
        _detailWrapper.backgroundColor = APPBackgroundColor;

        _detailTriangle = [UIImageView new];
        _detailTriangle.image = [UIImage imageNamed:@"dynamic-triangle"];

        _detailButton = [UIButton new];
        _detailButton.userInteractionEnabled = NO;
        _detailButton.titleColor = [UIColor colorFromHexString:@"999999"];
        _detailButton.titleLabel.numberOfLines = 1;
        _detailButton.titleFont = _nicknameLabel.font;

        [superview addSubview:_container];
        [_container addSubview:_avatarButton];
//        [_container addSubview:_genderButton];
        [_container addSubview:_nicknameLabel];
        [_container addSubview:_titleLabel];
        [_container addSubview:_timeLabel];
        [_container addSubview:_detailWrapper];
        [_detailWrapper addSubview:_detailButton];
        [_detailWrapper addSubview:_detailTriangle];

        return self;
    }
    return nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _detailTriangle.hidden = YES;
    _detailWrapper.hidden = YES;
    _detailButton.hidden = YES;
    _detailTriangle.frame = CGRectZero;
    _detailButton.frame = CGRectZero;
    _detailWrapper.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat containerWidth = [UIScreen mainScreen].bounds.size.width - BLUThemeMargin * 9;

    [_nicknameLabel sizeToFit];
    [_titleLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_detailButton sizeToFit];
    [_detailTriangle sizeToFit];

    CGSize genderButtonSize = CGSizeMake(_nicknameLabel.height - BLUThemeMargin * 2, _nicknameLabel.height - BLUThemeMargin * 2);
    CGFloat avatarButtonHeight = _nicknameLabel.height + _titleLabel.height - BLUThemeMargin * 2;
    CGFloat nicknameLabelMaxWidth = containerWidth - BLUThemeMargin * 11 - genderButtonSize.width - avatarButtonHeight;
    CGFloat titleLabelMaxWidth = containerWidth - BLUThemeMargin * 11 - _timeLabel.width - avatarButtonHeight;

    _nicknameLabel.x = BLUThemeMargin * 6 + avatarButtonHeight;
    _nicknameLabel.y = BLUThemeMargin * 3;
    _nicknameLabel.width = _nicknameLabel.width < nicknameLabelMaxWidth ? _nicknameLabel.width : nicknameLabelMaxWidth;

//    _genderButton.x = _nicknameLabel.right + BLUThemeMargin * 2;
//    _genderButton.y = _nicknameLabel.bottom - genderButtonSize.height - BLUThemeMargin;
//    _genderButton.width = genderButtonSize.width;
//    _genderButton.height = genderButtonSize.height;

    _titleLabel.x = _nicknameLabel.x;
    _titleLabel.y = _nicknameLabel.bottom + BLUThemeMargin * 2;
    _titleLabel.width = _titleLabel.width < titleLabelMaxWidth ? _titleLabel.width : titleLabelMaxWidth;

    _timeLabel.x = containerWidth - _timeLabel.width - BLUThemeMargin * 3;
    _timeLabel.centerY = _titleLabel.centerY;

    _avatarButton.x = BLUThemeMargin * 3;
    _avatarButton.width = avatarButtonHeight;
    _avatarButton.height = avatarButtonHeight;
    _avatarButton.centerY = _nicknameLabel.bottom + BLUThemeMargin * 1;
    _avatarButton.cornerRadius = _avatarButton.height / 2;

    if (_showDetail) {
        _detailWrapper.x = BLUThemeMargin * 3;
        _detailWrapper.y = _titleLabel.bottom + BLUThemeMargin * 4;
        _detailWrapper.width = containerWidth - BLUThemeMargin * 6;
        _detailWrapper.height = BLUThemeMargin * 8 + _detailButton.height;

        CGFloat detailButtonMaxWidth = _detailWrapper.width - BLUThemeMargin * 8;
        _detailButton.x = BLUThemeMargin * 4;
        _detailButton.y = BLUThemeMargin * 4;
        _detailButton.width = _detailButton.width < detailButtonMaxWidth ? _detailButton.width: detailButtonMaxWidth;

        _detailTriangle.x = _detailWrapper.width - _detailTriangle.width;
        _detailTriangle.y = 0;
    } else {
        _detailWrapper.frame = CGRectZero;
        _detailButton.frame = CGRectZero;
        _detailTriangle.frame = CGRectZero;
    }

    _container.x = BLUThemeMargin * 4.5;
    _container.y = BLUThemeMargin * 4;
    _container.width = containerWidth;
    _container.height = _showDetail ? _detailWrapper.bottom : _titleLabel.bottom;
    _container.height += BLUThemeMargin * 4;

    self.cellSize = CGSizeMake(self.contentView.width, _container.bottom);
}

#pragma mark - Model

- (void)setModel:(id)model {

    _dynamic = (BLUDynamic *)model;
    _showDetail = NO;

    switch (_dynamic.type) {
        case BLUDynamicTypeCommentPost:
        case BLUDynamicTypeLikePost: {
            _showDetail = YES;
            _detailButton.image = [UIImage imageNamed:@"dynamic-post"];
            _detailButton.title = [NSString stringWithFormat:@" %@", _dynamic.content];
        } break;
        case BLUDynamicTypeLikeComment:
        case BLUDynamicTypeReplyComment: {
            _showDetail = YES;
            _detailButton.image = [UIImage imageNamed:@"dynamic-comment"];
            _detailButton.title = [NSString stringWithFormat:@" %@", _dynamic.content];
        } break;
        case BLUDynamicTypeUserFollow: {
            _showDetail = NO;
        } break;
    }

    _nicknameLabel.text = _dynamic.FromUserName;
    _avatarButton.image = nil;
    if (!self.cellForCalcingSize) {
        
//        BLUUser *user = [BLUUser ]
        if (_dynamic.headimageURLStr.length > 0) {
            _avatarButton.imageURL = [NSURL URLWithString:_dynamic.headimageURLStr];
        }else
        {
            [_avatarButton setUser:[BLUUser new]];
        }
    }
    _genderButton.gender = 1;
    _titleLabel.text = _dynamic.content;
    _timeLabel.text = _dynamic.createDate.postTime;
    switch (_dynamic.type) {
        case BLUDynamicTypeLikePost: {
            _titleLabel.text = NSLocalizedString(@"dynamic-cell.title-label.text.like-your-post", @"Like your post");
        } break;
        case BLUDynamicTypeCommentPost: {
            _titleLabel.text = NSLocalizedString(@"dynamic-cell.title-label.text.comment-your-post", @"Comment your post");
        } break;
        case BLUDynamicTypeLikeComment: {
            _titleLabel.text = NSLocalizedString(@"dynamic-cell.title-label.text.like-your-comment", @"Like your comment");
        } break;
        case BLUDynamicTypeReplyComment: {
            _titleLabel.text = NSLocalizedString(@"dynamic-cell.title-label.text.comment-your-comment", @"Comment your comment");
        } break;
        case BLUDynamicTypeUserFollow: {
            _titleLabel.text = NSLocalizedString(@"dynamic-cell.title-label.text.follow-your", @"Follow you");
        } break;
    }

    if (_showDetail) {
        _detailButton.hidden = NO;
        _detailWrapper.hidden = NO;
        _detailTriangle.hidden = NO;
    } else {
        _detailButton.hidden = YES;
        _detailWrapper.hidden = YES;
        _detailTriangle.hidden = YES;
    }

    if (_dynamic.target.anonymous) {
        _nicknameLabel.text = NSLocalizedString(@"dynamic-cell.nickname-label.text.anonymous", @"Anonymous");
        _avatarButton.userInteractionEnabled = NO;
        _genderButton.hidden = YES;
    } else {
        _nicknameLabel.text = _dynamic.FromUserName;
        _avatarButton.userInteractionEnabled = YES;
        _genderButton.hidden = NO;
    }
}

- (void)transitToUserAction:(id)sender {
    if (_dynamic.target.anonymous) {
        return ;
    }

    if (_dynamic.fromUser.userID) {
        NSDictionary *dict = @{BLUUserKeyUserID: @(_dynamic.FromUserID)};
        if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
            [self.userTransitionDelegate shouldTransitToUser:dict fromView:self sender:self.avatarButton];
        }
    }
}

@end
