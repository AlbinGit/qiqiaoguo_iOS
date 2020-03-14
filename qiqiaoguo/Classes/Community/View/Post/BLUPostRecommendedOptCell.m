//
//  BLUPostRecommendedOptCell.m
//  Blue
//
//  Created by Bowen on 6/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostRecommendedOptCell.h"
#import "BLUPost.h"
#import "BLUCircle.h"

static const CGFloat kCircleButtonHeight = 36.0;
static const NSInteger kImageViewCount = 4;

@interface BLUPostRecommendedOptCell ()

@property (nonatomic, strong) UIButton *circleButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) BLUSolidLine *solidLine;
@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *featureButton;
@property (nonatomic, strong) UILabel *postTitleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSArray *imageViewArray;
@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) BLUGenderButton *genderButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *imagePromptLabel;

@property (nonatomic, assign, getter=shouldShowContent) BOOL showContent;
@property (nonatomic, assign, getter=shouldShowPhoto) BOOL showPhoto;
@property (nonatomic, assign, getter=shouldShowFeature) BOOL showFeature;
@property (nonatomic, assign, getter=shouldShowImagePrompt) BOOL showImagePrompt;

@end

@implementation BLUPostRecommendedOptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        
        superview.layer.shouldRasterize = YES;
        superview.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        // Circle button
        _circleButton = [UIButton new];
        [_circleButton addTarget:self action:@selector(transitToCircleAction:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_circleButton];
        
        // Title label
        _titleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        [superview addSubview:_titleLabel];
        
        // Add button
        _addButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
        _addButton.borderColor = BLUThemeMainColor;
        _addButton.titleColor = BLUThemeMainColor;
        _addButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin, BLUThemeMargin, BLUThemeMargin, BLUThemeMargin);
        [_addButton addTarget:self action:@selector(followCircleAction:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_addButton];
        
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [superview addSubview:_solidLine];
        
        // TEST:
        _addButton.title = NSLocalizedString(@"post-recommended-optCell.add", @"Add");
        
        [self initializePostView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentMargin = BLUThemeMargin * 3;
    CGFloat margin = BLUThemeMargin * 2;

    _circleButton.frame = CGRectMake(contentMargin, contentMargin, kCircleButtonHeight, kCircleButtonHeight);
    _circleButton.cornerRadius = _circleButton.width / 2;

 
    [_addButton sizeToFit];
    CGSize addButtonSize = _addButton.size;
    _addButton.frame = CGRectMake(self.contentView.width - contentMargin - addButtonSize.width, 0, addButtonSize.width, addButtonSize.height);
    _addButton.centerY = _circleButton.centerY;
    
    CGFloat titleLabelWidth = self.contentView.width - _circleButton.right - margin * 2 - contentMargin;
    CGFloat titleLabelHeight = [_titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, CGFLOAT_MAX)].height;
    _titleLabel.frame = CGRectMake(_circleButton.right + margin, 0, titleLabelWidth, titleLabelHeight);
    _titleLabel.centerY = _circleButton.centerY;
    
    [self layoutPostView];
  
    _solidLine.frame = CGRectMake(contentMargin, _containerView.bottom + contentMargin, self.contentView.width - contentMargin * 2, BLUThemeOnePixelHeight);
    
    self.cellSize = CGSizeMake(self.contentView.width, _solidLine.bottom);
}

- (void)setModel:(id)model {
    // FIX:
    self.post = (BLUPost *)model;
    _circleButton.image = nil;
    _circleButton.borderColor = self.post.circle.circleColor;
    _circleButton.borderWidth = BLUThemeOnePixelHeight;
    if (!self.cellForCalcingSize) {
        _circleButton.imageURL = self.post.circle.logo.thumbnailURL;
    }

    _titleLabel.text = self.post.circle.name;
    _addButton.hidden = self.post.circle.didFollowCircle;
    
    [self configPostView];

}

- (void)transitToCircleAction:(id)sender {
    if (self.post.circle) {
        NSDictionary *dict = @{BLUCircleKeyCircle: self.post.circle};
        if ([self.circleTransitionDelegate respondsToSelector:@selector(shouldTransitToCircle:fromView:sender:)]) {
            [self.circleTransitionDelegate shouldTransitToCircle:dict fromView:self sender:self.circleButton];
        }
    }
}

- (void)followCircleAction:(id)sender {
    if ([self.circleActionDelegate respondsToSelector:@selector(shouldFollowCircle:fromView:sender:)]) {
        BLUCircle *circle = self.post.circle;
        if (circle) {
            NSDictionary *circleInfo = @{BLUCircleKeyCircle: circle};
            [self.circleActionDelegate shouldFollowCircle:circleInfo fromView:self sender:sender];
        }
    }
}

- (void)transitToUserAction:(id)sender {
    if (self.post.author) {
        NSDictionary *dict = @{BLUUserKeyUser: self.post.author};
        if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
            [self.userTransitionDelegate shouldTransitToUser:dict fromView:self sender:self.avatarButton];
        }
    }
}

- (void)initializePostView {
    UIView *superview = self.contentView;
    
    _containerView = [UIView new];
    _containerView.backgroundColor = BLUThemeSubTintBackgroundColor;
    _containerView.cornerRadius = BLUThemeNormalActivityCornerRadius;
    [superview addSubview:_containerView];
    
    superview = self.containerView;
    
    superview.opaque = YES;
    
    // Feature button
    _featureButton = [UIButton new];
    _featureButton.backgroundImage = [BLUCurrentTheme postFeatureIcon];
    [superview addSubview:_featureButton];
    
    // Title label
    _postTitleLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    [superview addSubview:_postTitleLabel];
    
    // Content label
    _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _contentLabel.numberOfLines = 2;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [superview addSubview:_contentLabel];
    
    // Image array
    NSMutableArray *imageViewArray = [NSMutableArray new];
    for (NSInteger i = 0; i < kImageViewCount; ++i) {
        UIImageView *imageView = [UIImageView new];
        imageView.tag = i;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = BLUThemeMainTintBackgroundColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageViewArray addObject:imageView];
        [superview addSubview:imageView];
    }
    _imageViewArray = [NSArray arrayWithArray:imageViewArray];
    
    // Avatar button
    _avatarButton = [BLUAvatarButton new];
    [_avatarButton addTarget:self action:@selector(transitToUserAction:) forControlEvents:UIControlEventTouchUpInside];
    _avatarButton.backgroundColor = superview.backgroundColor;
    [superview addSubview:_avatarButton];
    
    // Gender button
    _genderButton = [BLUGenderButton new];
    [superview addSubview:_genderButton];
    
    // Time label
    _timeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
    _timeLabel.numberOfLines = 1;
    [superview addSubview:_timeLabel];
    
    // Comment button
    _commentButton = [UIButton new];
    _commentButton.titleFont = _timeLabel.font;
    _commentButton.titleColor = _timeLabel.textColor;
    _commentButton.image = [BLUCurrentTheme postCommentIcon];
    [superview addSubview:_commentButton];
    
    // Nickname label
    _nicknameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeSub];
    _nicknameLabel.numberOfLines = 1;
    _nicknameLabel.font = _commentButton.titleLabel.font;
    [superview addSubview:_nicknameLabel];
    
    // Image prompt label
    _imagePromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _imagePromptLabel.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.5];
    _imagePromptLabel.textColor = BLUThemeMainTintContentForegroundColor;
    _imagePromptLabel.textAlignment = NSTextAlignmentCenter;
    _imagePromptLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);
    [superview addSubview:_imagePromptLabel];
    
}

- (void)configPostView {
    // Feature
    _showFeature = _post.postType == BLUPostTypeFeature;
    _featureButton.hidden = !_showFeature;
    
    // Title
    _postTitleLabel.text = _post.title;
    
    // Content
    _showContent = _post.content.length > 0;
    _contentLabel.text = _post.content;
    _contentLabel.hidden = !_showContent;
    
    // Photo
    _showPhoto = _post.photos.count > 0;
    @weakify(self);
    [_imageViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        @strongify(self);
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
    
    // Comment
    _commentButton.title = [NSString stringWithFormat:@" %@", @(_post.commentCount)];
    
    // Nickname
    _nicknameLabel.text = _post.author.nickname;
    
    // Gender
    _genderButton.gender = _post.author.gender;
    
    // Time
    _timeLabel.text = _post.createDate.postTime;
    
    // Avatar
    _avatarButton.image = nil;
    if (!self.cellForCalcingSize) {
        [_avatarButton setUser:_post.author];
    }
    
    // Image prompt
    _showImagePrompt = _post.photos.count > kImageViewCount;
    _imagePromptLabel.hidden = !_showImagePrompt;
    _imagePromptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"post-common-opt-cell.image-prompt-label.title.%@", @"title"), @(_post.photos.count)];
}

- (void)layoutPostView {
    
    _containerView.frame = CGRectMake(_circleButton.right, _circleButton.bottom + BLUThemeMargin, self.contentView.width - _circleButton.right - BLUThemeMargin * 3, 0);
    
    CGFloat margin = BLUThemeMargin;
    CGFloat containerWidth = _containerView.width - BLUThemeMargin * 4;
    CGFloat sectionHeight = BLUThemeMargin * 2;
    CGFloat containerMargin = BLUThemeMargin * 2;
    
    // 1
    CGSize titleLabelSize = [_postTitleLabel sizeThatFits:CGSizeMake(containerWidth, CGFLOAT_MAX)];
    CGFloat titleLabelHeight = titleLabelSize.height;
    
    if (_showFeature) {
        _featureButton.frame = CGRectMake(containerMargin, containerMargin, titleLabelHeight - margin, titleLabelHeight - margin);
        _postTitleLabel.frame = CGRectMake(_featureButton.right + margin, containerMargin, containerWidth - _featureButton.right - margin, titleLabelHeight);
        _featureButton.centerY = _postTitleLabel.centerY;
    } else {
        _featureButton.frame = CGRectZero;
        _postTitleLabel.frame = CGRectMake(containerMargin, containerMargin, containerWidth, titleLabelHeight);
    }
    
    // 2
    __block UIView *lastView = _postTitleLabel;
    if (_showContent) {
        CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(containerWidth, CGFLOAT_MAX)];
        CGFloat contentLabelHeight = contentLabelSize.height;
        _contentLabel.frame = CGRectMake( containerMargin, _postTitleLabel.bottom + sectionHeight, containerWidth, contentLabelHeight);
        lastView = _contentLabel;
    } else {
        _contentLabel.frame = CGRectZero;
    }
    
    
    // 3
    CGFloat imageViewWidth = (containerWidth - (kImageViewCount - 1) * margin) / (kImageViewCount);
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
            CGFloat x = idx * imageViewWidth + containerMargin + idx * margin;
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
        _imagePromptLabel.frame = CGRectMake(self.contentView.width - containerMargin * 2 - BLUThemeMargin * 2 - imagePromptLabelWidth - _containerView.left, lastView.bottom - imagePromptLabelHeight - BLUThemeMargin, imagePromptLabelWidth, imagePromptLabelHeight);
        _imagePromptLabel.cornerRadius = BLUThemeNormalActivityCornerRadius;
    } else {
        _imagePromptLabel.frame = CGRectZero;
    }
    
    // 4
    [_commentButton sizeToFit];
    CGSize commentButtonSize = _commentButton.size;
    _commentButton.frame = CGRectMake(_containerView.width - containerMargin - commentButtonSize.width, lastView.bottom + BLUThemeMargin * 2, commentButtonSize.width, commentButtonSize.height);
    
    // 4
    _avatarButton.frame = CGRectMake(containerMargin, _commentButton.top, _commentButton.height, _commentButton.height);
    _avatarButton.cornerRadius = _avatarButton.width / 2;
    
    // 4
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(_containerView.width - containerMargin - _commentButton.width -  _timeLabel.width - BLUThemeMargin, 0, _timeLabel.width, _timeLabel.height);
    _timeLabel.centerY = _avatarButton.centerY;
  
    // 4
    [_nicknameLabel sizeToFit];
    CGFloat nicknameLabelWidth = _containerView.width - (_avatarButton.right + margin) - (_containerView.width - _timeLabel.left) - (_avatarButton.height - margin) - BLUThemeMargin * 3;
    nicknameLabelWidth = _nicknameLabel.width < nicknameLabelWidth ? _nicknameLabel.width : nicknameLabelWidth;
    _nicknameLabel.frame = CGRectMake(_avatarButton.right + margin, 0, nicknameLabelWidth, _nicknameLabel.height);
    _nicknameLabel.centerY = _avatarButton.centerY;
    
    // 4
    _genderButton.frame = CGRectMake(_nicknameLabel.right + BLUThemeMargin, 0, _avatarButton.height - margin, _avatarButton.height - margin);
    _genderButton.centerY = _avatarButton.centerY;
    
    _containerView.height = _commentButton.bottom + containerMargin;
}

@end
