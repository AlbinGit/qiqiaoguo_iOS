//
//  BLUPostCommonOptCell.m
//  Blue
//
//  Created by Bowen on 1/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostCommonOptCell.h"
#import "BLUPost.h"

static const NSInteger kImageViewCount = 4;

@interface BLUPostCommonOptCell ()

@property (nonatomic, strong) BLUSolidLine *solidLine;

@property (nonatomic, strong) UIButton *featureButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSArray *imageViewArray;
@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) BLUGenderButton *genderButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *imagePromptLabel;
@property (nonatomic, strong) UIButton *videoSubscriptButton;
@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) BLUPost *post;
@property (nonatomic, assign, getter=shouldShowContent) BOOL showContent;
@property (nonatomic, assign, getter=shouldShowPhoto) BOOL showPhoto;
@property (nonatomic, assign, getter=shouldShowFeature) BOOL showFeature;
@property (nonatomic, assign, getter=shouldShowImagePrompt) BOOL showImagePrompt;
@property (nonatomic, assign, getter=shouldShowVideoSubscript) BOOL showVideoSubscript;
@property (nonatomic, assign, getter=shouldShowTop) BOOL showTop;

@end

@implementation BLUPostCommonOptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        
        superview.opaque = YES;
        superview.backgroundColor = BLUThemeMainTintBackgroundColor;
        
        // Feature button
        _featureButton = [UIButton new];
        _featureButton.image = [BLUCurrentTheme postFeatureIcon];

        // Title label
        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];

        // Content label
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _contentLabel.numberOfLines = 2;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;

        // Image array
        NSMutableArray *imageViewArray = [NSMutableArray new];
        for (NSInteger i = 0; i < kImageViewCount; ++i) {
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = BLUThemeSubTintBackgroundColor;
            imageView.tag = i;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageViewArray addObject:imageView];
            [superview addSubview:imageView];
        }
        _imageViewArray = [NSArray arrayWithArray:imageViewArray];
        
        // Avatar button
        _avatarButton = [BLUAvatarButton new];
        [_avatarButton addTarget:self action:@selector(transitToUserAction:) forControlEvents:UIControlEventTouchUpInside];

        // Gender button
        _genderButton = [BLUGenderButton new];

        // Time label
        _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
        _timeLabel.numberOfLines = 1;

        // Comment button
        _commentButton = [UIButton new];
        _commentButton.titleFont = _timeLabel.font;
        _commentButton.titleColor = _timeLabel.textColor;
        _commentButton.image = [BLUCurrentTheme postCommentIcon];

        // Nickname label
        _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeSub];
        _nicknameLabel.numberOfLines = 1;
        _nicknameLabel.font = _commentButton.titleLabel.font;

        // Image prompt label
        _imagePromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _imagePromptLabel.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.5];
        _imagePromptLabel.textColor = BLUThemeMainTintContentForegroundColor;
        _imagePromptLabel.textAlignment = NSTextAlignmentCenter;
        _imagePromptLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);

        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;

        // Video subscript button
        _videoSubscriptButton = [UIButton new];
        _videoSubscriptButton.image = [BLUCurrentTheme postPlayVideoSubscript];

        // Top image view
        _topImageView = [UIImageView new];
        _topImageView.image = [BLUCurrentTheme postTop];

        [superview addSubview:_featureButton];
        [superview addSubview:_titleLabel];
        [superview addSubview:_contentLabel];
        [superview addSubview:_avatarButton];
        [superview addSubview:_genderButton];
        [superview addSubview:_timeLabel];
        [superview addSubview:_commentButton];
        [superview addSubview:_nicknameLabel];
        [superview addSubview:_imagePromptLabel];
        [superview addSubview:_solidLine];
        [superview addSubview:_videoSubscriptButton];
        [superview addSubview:_topImageView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = BLUThemeMargin;
    CGFloat cellWidth = self.contentView.width - BLUThemeMargin * 6;
    CGFloat sectionHeight = BLUThemeMargin * 2;
    CGFloat cellMargin = BLUThemeMargin * 3;
    
    // 1
    if (_showFeature) {
        _featureButton.frame = CGRectMake(cellMargin, cellMargin, _featureButton.image.size.width, _featureButton.image.size.height);
    } else {
        _featureButton.frame = CGRectZero;
    }

    if (_showVideoSubscript) {
        _videoSubscriptButton.frame = CGRectMake(_showFeature ? _featureButton.right + margin : cellMargin, cellMargin, _videoSubscriptButton.image.size.width, _videoSubscriptButton.image.size.height);
    } else {
        _videoSubscriptButton.frame = CGRectZero;
    }

    if (_showTop) {
        _topImageView.frame = CGRectMake(self.contentView.width - _topImageView.image.size.width, cellMargin + BLUThemeMargin, _topImageView.image.size.width, _topImageView.image.size.height);
    } else {
        _topImageView.frame = CGRectZero;
    }

    CGFloat titleLabelMaxWidth = cellWidth - (_showFeature ? _featureButton.width + margin : 0) - (_showVideoSubscript ? _videoSubscriptButton.width + margin : 0) - (_showTop ? _topImageView.width - cellMargin + margin : 0);
    CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(titleLabelMaxWidth, CGFLOAT_MAX)];
    _titleLabel.frame = CGRectMake(cellMargin + (_showFeature ? _featureButton.width + margin : 0) + (_showVideoSubscript ? _videoSubscriptButton.width + margin : 0), cellMargin, titleLabelMaxWidth, titleLabelSize.height);

    if (_showFeature) {
        _featureButton.centerY = _titleLabel.centerY;
    }

    if (_showVideoSubscript) {
        _videoSubscriptButton.centerY = _titleLabel.centerY;
    }

    // 2
    __block UIView *lastView = _titleLabel;
    if (_showContent) {
        CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(cellWidth, CGFLOAT_MAX)];
        CGFloat contentLabelHeight = contentLabelSize.height;
        _contentLabel.frame = CGRectMake( cellMargin, _titleLabel.bottom + sectionHeight, cellWidth, contentLabelHeight);
        lastView = _contentLabel;
    } else {
        _contentLabel.frame = CGRectZero;
    }

    // 3
    CGFloat imageViewWidth = (cellWidth - (kImageViewCount - 1) * margin) / (kImageViewCount);
    CGFloat y = lastView.bottom;
    if (self.shouldShowContent) {
        y += BLUThemeMargin;
    } else {
        y += BLUThemeMargin * 2;
    }
    @weakify(self);
    [_imageViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        if (self.shouldShowPhoto) {
            CGFloat x = idx * imageViewWidth + cellMargin + idx * margin;
            if (idx < self.post.photos.count) {
                UIImageView *imageView = _imageViewArray[idx];
                imageView.frame = CGRectMake(x, y, imageViewWidth, imageViewWidth);
                // FIX:
                lastView = imageView;
            } else {
                imageView.frame = CGRectZero;
            }
        } else {
            imageView.frame = CGRectZero;
        }
    }];
    
    if (self.shouldShowImagePrompt) {
        [_imagePromptLabel sizeToFit];
        CGFloat imagePromptLabelWidth = _imagePromptLabel.width + BLUThemeMargin * 2;
        CGFloat imagePromptLabelHeight = _imagePromptLabel.height;
        _imagePromptLabel.frame = CGRectMake(self.contentView.width - cellMargin - BLUThemeMargin - imagePromptLabelWidth, lastView.bottom - imagePromptLabelHeight - BLUThemeMargin, imagePromptLabelWidth, imagePromptLabelHeight);
        _imagePromptLabel.cornerRadius = BLUThemeNormalActivityCornerRadius;
    } else {
        _imagePromptLabel.frame = CGRectZero;
    }
    
    // 4
    [_commentButton sizeToFit];
    CGSize commentButtonSize = _commentButton.size;
    _commentButton.frame = CGRectMake(self.width - cellMargin - commentButtonSize.width, lastView.bottom + BLUThemeMargin * 2, commentButtonSize.width, commentButtonSize.height);
    
    // 4
    _avatarButton.frame = CGRectMake(cellMargin, _commentButton.top, _commentButton.height, _commentButton.height);
    _avatarButton.cornerRadius = _avatarButton.width / 2;
    
    // 4
    [_nicknameLabel sizeToFit];
    CGFloat diffWidth = self.contentView.width - cellMargin * 2 - margin * 3 - self.commentButton.width - self.avatarButton.width - (_avatarButton.width - margin);
    if (_nicknameLabel.width < diffWidth) {
        _nicknameLabel.frame = CGRectMake(cellMargin + _avatarButton.width + margin, 0, _nicknameLabel.width, _nicknameLabel.height);
    } else {
        _nicknameLabel.frame = CGRectMake(cellMargin + _avatarButton.width + margin, 0, diffWidth, _nicknameLabel.height);
    }
    _nicknameLabel.centerY = _avatarButton.centerY;
    
    // 4
    _genderButton.frame = CGRectMake(_nicknameLabel.right + margin, _avatarButton.top, _avatarButton.height - margin, _avatarButton.height - margin);
    _genderButton.centerY = _avatarButton.centerY;
    
    // 4
    [_timeLabel sizeToFit];
    diffWidth = (self.contentView.width - cellMargin * 2 - _commentButton.width - _avatarButton.width - margin * 4 - _genderButton.width - _nicknameLabel.width);
    if (_timeLabel.width < diffWidth) {
        _timeLabel.frame = CGRectMake(self.contentView.width - cellMargin - _commentButton.width - margin - _timeLabel.width, 0, _timeLabel.width, _timeLabel.height);
    } else {
        _timeLabel.frame = CGRectMake(self.contentView.width - cellMargin - _commentButton.width - margin - diffWidth, 0, diffWidth, _timeLabel.height);
    }
    _timeLabel.centerY = _avatarButton.centerY;
    
    if (_showThickLine) {
        _solidLine.frame = CGRectMake(0, _commentButton.bottom + cellMargin, self.contentView.width, BLUThemeMargin * 2);
    } else {
        _solidLine.frame = CGRectMake(0, _commentButton.bottom + cellMargin, self.contentView.width, BLUThemeOnePixelHeight);
    }
    
    self.cellSize = CGSizeMake(self.contentView.width, _solidLine.bottom);
}

- (void)setModel:(id)model {
    _post = (BLUPost *)model;
    
    // Feature
    _showFeature = _post.postType == BLUPostTypeFeature;
    _showVideoSubscript = _post.hasVideo;
    _showTop = _post.isTop;
    _featureButton.hidden = !_showFeature;
    
    // Title
    _titleLabel.text = _post.title;
    
    // Content
    _showContent = _post.content.length > 0;
    _contentLabel.text = _post.content;
    _contentLabel.hidden = !_showContent;
    
    // Photo
    _showPhoto = _post.photos.count > 0;
    @weakify(self);
    [_imageViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        imageView.image = nil;
        if (self.shouldShowPhoto) {
            if (!self.cellForCalcingSize && idx < self.post.photos.count) {
                imageView.hidden = NO;
                BLUImageRes *imageRes = self.post.photos[idx];
                if (!self.cellForCalcingSize) {
                    [imageView sd_setImageWithURL:imageRes.thumbnailURL];
                }
            } else {
                imageView.hidden = YES;
            }
        } else {
            imageView.hidden = YES;
        }
    }];
    
    // Image prompt
    _showImagePrompt = _post.photos.count > kImageViewCount;
    _imagePromptLabel.hidden = !_showImagePrompt;
    _imagePromptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"post-common-opt-cell.image-prompt-label.title.%@", @"title"), @(_post.photos.count)];
    
    // Comment
    _commentButton.title = [NSString stringWithFormat:@" %@", @(_post.commentCount)];
    
    // Nickname
    _nicknameLabel.text = _post.anonymousEnable ? [BLUUser anonymousNickname] : _post.author.nickname;
    
    // Gender
    _genderButton.gender = _post.author.gender;
    _genderButton.hidden = _post.anonymousEnable ? YES : NO;
    
    // Time
    _timeLabel.text = _post.createDate.postTime;

    _topImageView.hidden = !_showTop;
    
    // Avatar
    _avatarButton.image = nil;
    if (!self.cellForCalcingSize) {
        [_avatarButton setUser:_post.author anonymous:_post.anonymousEnable];
    }
}

- (void)transitToUserAction:(id)sender {
    if (_post.anonymousEnable) {
        return ;
    }

    if (self.post.author) {
        NSDictionary *dict = @{BLUUserKeyUser: self.post.author};
        if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
            [self.userTransitionDelegate shouldTransitToUser:dict fromView:self sender:self.avatarButton];
        }
    }
}

@end
