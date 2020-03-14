//
//  BLUPostDetailOptCell.m
//  Blue
//
//  Created by Bowen on 6/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostDetailOptCell.h"
#import "BLUPostLikedUserCollectionViewCell.h"
#import "BLUPost.h"
#import "BLUContentParagraph.h"
#import "BLUPostPlayButton.h"
#import "BLUCircle.h"

struct {
    unsigned int didLike: 1;
    unsigned int didDislike: 1;
    unsigned int didCollect: 1;
    unsigned int didCancelCollect: 1;
    unsigned int didShare: 1;
    unsigned int didComment: 1;
    unsigned int didTriggerOtherAction: 1;
    unsigned int didPlayVideo: 1;
} _BLUPostDetailOptDelegateFlags;

static const CGFloat kLikedAvatarButtonHeight = 32;
static const CGFloat kButtonHeight = 40;
static const CGFloat kMaxImagesCount = 9;

@interface BLUPostDetailOptCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *lzButton;
@property (nonatomic, strong) UILabel *lvLabel;

@property (nonatomic, strong) BLUSolidLine *solidLine;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) BLUSolidLine *likeTopLine;
@property (nonatomic, strong) UIImageView *likeBottomImageView;

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) NSArray *imageViews;

@property (nonatomic, strong) NSArray *likedUsers;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *likedUserCollectionView;
@property (nonatomic, strong) UIImageView *leftShadeImageView;
@property (nonatomic, strong) UIImageView *rightShadeImageView;

@property (nonatomic, strong) UILabel *likePromptLabel;

@property (nonatomic, strong) BLUPost *post;

@property (nonatomic, assign) BOOL showPhotos;
@property (nonatomic, assign) BOOL showLikeUsers;
@property (nonatomic, assign) BOOL showContent;

@property (nonatomic, assign) BOOL showParagraph;

@property (nonatomic, strong) NSArray *textParagraphs;
@property (nonatomic, strong) NSArray *imageParagraphs;
@property (nonatomic, strong) NSArray *videoParagraphs;

@property (nonatomic, strong) NSURL *redirectURL;
@property (nonatomic, assign) NSInteger redirectID;

@end

@implementation BLUPostDetailOptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *superview = self.contentView;
        superview.backgroundColor = BLUThemeMainTintBackgroundColor;
        superview.layer.shouldRasterize = YES;
        superview.layer.rasterizationScale = [[UIScreen mainScreen] scale];

        // Lz button
        _lzButton = [UIButton makeThemeButtonWithType:BLUButtonTypeSolidRoundRect];
        _lzButton.contentEdgeInsets = UIEdgeInsetsMake(0, [BLUCurrentTheme leftMargin], 0, [BLUCurrentTheme rightMargin]);
        _lzButton.titleColor = [UIColor whiteColor];
        _lzButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
        [superview addSubview:_lzButton];

        _lvLabel = [UILabel new];
        _lvLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeVerySmall);
        _lvLabel.textColor = [UIColor colorFromHexString:@"#cc9318"];
        _lvLabel.borderWidth = 1.0;
        _lvLabel.borderColor = _lvLabel.textColor;
        _lvLabel.cornerRadius = BLUThemeNormalActivityCornerRadius;
        [superview addSubview:_lvLabel];

        // Solid line
        _solidLine = [BLUSolidLine new];
        _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [superview addSubview:_solidLine];
        
        // Content label
        _contentLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _contentLabel.numberOfLines = 0;
        [superview addSubview:_contentLabel];
        
        // TODO: image section
        // Like button
        _likeButton = [self makeButton];
        _likeButton.borderWidth = 0.0;
        [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setImage:[BLUCurrentTheme postLikeNormalIcon] forState:UIControlStateNormal];
        
        // Like top line
        _likeTopLine = [BLUSolidLine new];
        _likeTopLine.backgroundColor = BLUThemeSubTintBackgroundColor;
        [_likeButton addSubview:_likeTopLine];
        
        // Like bottom image view
        _likeBottomImageView = [UIImageView new];
        _likeBottomImageView.image = [BLUCurrentTheme postEmbossingLineIcon];
        _likeBottomImageView.tintColor = BLUThemeSubTintBackgroundColor;
        [_likeButton addSubview:_likeBottomImageView];
        
        // Comment button
        _commentButton = [self makeButton];
        [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.image = [BLUCurrentTheme postCommentIcon];
        
        // Share button
        _shareButton = [self makeButton];
        [_shareButton addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.image = [BLUCurrentTheme shareIcon];
        
        // More button
        _moreButton = [self makeButton];
        [_moreButton addTarget:self action:@selector(OtherAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.image = [BLUCurrentTheme moreIcon];
        
        // Image view array

        NSMutableArray *imageViews = [NSMutableArray new];
        for (NSInteger i = 0; i < kMaxImagesCount; ++i) {
            UIImageView *imageView = [UIImageView new];
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
            [tapImage setNumberOfTapsRequired:1];
            [tapImage setNumberOfTouchesRequired:1];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tapImage];
            [superview addSubview:imageView];
            [imageViews addObject:imageView];
        }

        _imageViews = imageViews;

        // CollectionView
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = [BLUCurrentTheme leftMargin];
        _flowLayout.itemSize = CGSizeMake(kLikedAvatarButtonHeight, kLikedAvatarButtonHeight);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _likedUserCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _likedUserCollectionView.delegate = self;
        _likedUserCollectionView.dataSource = self;
        _likedUserCollectionView.backgroundColor = BLUThemeMainTintBackgroundColor;
        [_likedUserCollectionView registerClass:[BLUPostLikedUserCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BLUPostLikedUserCollectionViewCell class])];
        _likedUserCollectionView.contentInset = UIEdgeInsetsMake([BLUCurrentTheme topMargin], [BLUCurrentTheme leftMargin], [BLUCurrentTheme bottomMargin], [BLUCurrentTheme rightMargin]);
        
        UIEdgeInsets collectionViewContentInset = _likedUserCollectionView.contentInset;
        collectionViewContentInset.left = BLUThemeMargin * 2;
        collectionViewContentInset.right = BLUThemeMargin * 2;
        _likedUserCollectionView.contentInset = collectionViewContentInset;
        
        _likedUserCollectionView.showsHorizontalScrollIndicator = NO;
        [superview addSubview:_likedUserCollectionView];

        // Like prompt label
        _likePromptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _likePromptLabel.font = _likeButton.titleFont;
        _likePromptLabel.textColor = _likeButton.titleColor;
        [superview addSubview:_likePromptLabel];
        
        // Left shade image view
        _leftShadeImageView = [UIImageView new];
        _leftShadeImageView.image = [BLUCurrentTheme postLeftShadeIcon];
        [superview addSubview:_leftShadeImageView];
        
        // Right shade image view
        _rightShadeImageView = [UIImageView new];
        _rightShadeImageView.image = [BLUCurrentTheme postRightShadeIcon];
        [superview addSubview:_rightShadeImageView];
        
        for (UIImageView *imageView in _imageViews) {
            imageView.backgroundColor = BLUThemeSubTintBackgroundColor;
        }

        return self;
    }
    return nil;
}

- (UIButton *)makeButton {
    UIButton *button = [UIButton makeThemeButtonWithType:BLUButtonTypeLeftImage];
    button.titleFont = _contentLabel.font;
    button.titleColor = BLUThemeSubTintContentForegroundColor;
    button.tintColor = BLUThemeSubTintContentForegroundColor;
    button.imageView.tintColor = BLUThemeSubTintContentForegroundColor;
    button.borderColor = BLUThemeSubTintBackgroundColor;
    button.borderWidth = BLUThemeOnePixelHeight;
    [self.contentView addSubview:button];
    return button;
}

- (void)setModel:(id)model {
    NSParameterAssert([model isKindOfClass:[BLUPost class]]);
    _post = (BLUPost *)model;
    [self setUser:_post.author anonymous:_post.anonymousEnable];
    self.time = _post.createDate.postTime;
    
    _contentLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:self.post.content];

    // FIX:
    _likePromptLabel.text = [NSString stringWithFormat:NSLocalizedString(@"post-detail-opt-cell.like-count-%@", "likes"), @(self.post.likeCount)];
    _likedUsers = self.post.likedUsers;
    
    _likeButton.tintColor = self.post.didLike ? BLUThemeMainColor : BLUThemeSubTintContentForegroundColor;
    _likeButton.titleColor = _likeButton.tintColor;
    _likeButton.image = self.post.didLike ? [BLUCurrentTheme postDislikeNormalIcon] : [BLUCurrentTheme postLikeNormalIcon];
    
    _lzButton.title = NSLocalizedString(@"post-detail-opt-cell.lz", @"LZ");
    _likeButton.title = NSLocalizedString(@"post-detail-opt-cell.like", @"Like");
    _commentButton.title = NSLocalizedString(@"post-detail-opt-cell.comment", @"Comment");
    _shareButton.title = NSLocalizedString(@"post-detail-opt-cell.share", @"Share");
    _moreButton.title = NSLocalizedString(@"post-detail-opt-cell.more", @"More");
    _lvLabel.text = [NSString stringWithFormat:@" %@ ", _post.author.levelDesc];
    _lvLabel.hidden = _post.anonymousEnable;


    self.showParagraph = self.post.contentType == BLUPostContentTypeParagraph && self.post.paragraphs.count > 0 ? YES : NO;
    self.showContent = self.post.content.length > 0 && self.showParagraph == NO;
    self.showPhotos = self.post.photos.count > 0;
    self.showLikeUsers = self.post.likedUsers.count > 0;
    
    self.contentLabel.hidden = !self.showContent;
    self.likePromptLabel.hidden = !self.showLikeUsers;
    self.likedUserCollectionView.hidden = !self.showLikeUsers;
    self.leftShadeImageView.hidden = !self.showLikeUsers;
    self.rightShadeImageView.hidden = !self.showLikeUsers;
    
    self.likeTopLine.hidden = !self.showLikeUsers;
    self.likeBottomImageView.hidden = !self.showLikeUsers;
    self.likeButton.borderWidth = self.showLikeUsers ? 0.0 : BLUThemeOnePixelHeight;

    @weakify(self);
    [_imageViews enumerateObjectsUsingBlock:^(UIImageView *button, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        if (self.showPhotos) {
            if (idx < self.post.photos.count) {
                button.hidden = NO;
                BLUImageRes *imageRes = self.post.photos[idx];
                if (!self.cellForCalcingSize) {
                    [button sd_setImageWithURL:imageRes.originURL];
                }
            } else {
                button.hidden = YES;
                button.image = nil;
            }
        } else {
            button.hidden = YES;
            button.image = nil;
        }
    }];

    for (UILabel *textLabel in self.textParagraphs) {
        [textLabel removeFromSuperview];
    }
    self.textParagraphs = nil;
    
    for (UIImageView *imageView in self.imageParagraphs) {
        [imageView removeFromSuperview];
    }
    self.imageParagraphs = nil;
    
    if (self.showParagraph) {
        NSMutableArray *textParagraphs = [NSMutableArray new];
        NSMutableArray *imageParagraphs = [NSMutableArray new];
        NSMutableArray *videoParagraphs = [NSMutableArray new];
        UIView *superview = self.contentView;

        [_textParagraphs enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
            [view removeFromSuperview];
        }];
        _textParagraphs = nil;

        [_imageParagraphs enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
            [view removeFromSuperview];
        }];
        _imageParagraphs = nil;

        [_videoParagraphs enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
            [view removeFromSuperview];
        }];
        _videoParagraphs = nil;

        [self.post.paragraphs enumerateObjectsUsingBlock:^(BLUContentParagraph *postParagraph, NSUInteger idx, BOOL * _Nonnull stop) {
            if (postParagraph.type == BLUPostParagraphTypeText || postParagraph.type == BLUPostParagraphTypeRedirectText) {
                UILabel *textLabel = [UILabel makeThemeLabelWithType:BLULabelTypeMainContent];
                textLabel.tag = idx;
                textLabel.attributedText = [NSAttributedString contentAttributedStringWithContent:postParagraph.text];
                textLabel.numberOfLines = 0;
                [superview addSubview:textLabel];
                [textParagraphs addObject:textLabel];

                if (postParagraph.type == BLUPostParagraphTypeRedirectText) {
                    [self addRedirectActionToView:textLabel withRedirectType:postParagraph.redirectType];
                    if (postParagraph.redirectType == BLUContentParagraphRedirectTypeWeb) {
                        self.redirectURL = postParagraph.pageURL;
                    } else {
                        self.redirectID = postParagraph.objectID;
                    }
                }
            } else if (postParagraph.type == BLUPostParagraphTypeImage || postParagraph.type == BLUPostParagraphTypeRedirectImage) {
                UIImageView *imageView = [UIImageView new];
                imageView.tag = idx;
                imageView.backgroundColor = BLUThemeSubTintBackgroundColor;

                if (!self.cellForCalcingSize) {
                    [imageView sd_setImageWithURL:postParagraph.imageURL];
                }
                [superview addSubview:imageView];
                [imageParagraphs addObject:imageView];

                if (postParagraph.type == BLUPostParagraphTypeRedirectImage) {
                    [self addRedirectActionToView:imageView withRedirectType:postParagraph.redirectType];
                    if (postParagraph.redirectType == BLUContentParagraphRedirectTypeWeb) {
                        self.redirectURL = postParagraph.pageURL;
                    } else {
                        self.redirectID = postParagraph.objectID;
                    }
                } else {
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
                    [tapImage setNumberOfTapsRequired:1];
                    [tapImage setNumberOfTouchesRequired:1];
                    [imageView addGestureRecognizer:tapImage];
                }
            } else if (postParagraph.type == BLUPostParagraphTypeVideo) {
                BLUPostPlayButton *button = [BLUPostPlayButton new];
                [button addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = idx;
                button.backgroundColor = BLUThemeSubTintBackgroundColor;
                if (!self.cellForCalcingSize) {
                    button.imageURL = postParagraph.imageURL;
                }

                [superview addSubview:button];
                [videoParagraphs addObject:button];
            }
        }];

        self.textParagraphs = textParagraphs;
        self.imageParagraphs = imageParagraphs;
        self.videoParagraphs = videoParagraphs;
    }
    
    [self.likedUserCollectionView reloadData];
}

- (void)setDelegate:(id<BLUPostDetailActionDelegate>)delegate {
    _delegate = delegate;
    _BLUPostDetailOptDelegateFlags.didLike = [delegate respondsToSelector:@selector(shouldLikePost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didDislike = [delegate respondsToSelector:@selector(shouldDislikePost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didCollect = [delegate respondsToSelector:@selector(shouldCollectPost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didCancelCollect = [delegate respondsToSelector:@selector(shouldCancelCollectPost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didShare = [delegate respondsToSelector:@selector(shouldSharePost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didTriggerOtherAction = [delegate respondsToSelector:@selector(shouldTriggerOtherActionForPost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didComment = [delegate respondsToSelector:@selector(shouldCommentPost:fromView:sender:)];
    _BLUPostDetailOptDelegateFlags.didPlayVideo = [delegate respondsToSelector:@selector(shouldPlayVideoForPost:withVideoURL:fromView:sender:)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block CGFloat postBottom = 0;

    self.genderButton.height -= BLUThemeMargin;
    self.genderButton.width = self.genderButton.height;
    self.genderButton.clipsToBounds = NO;

    // Lz
    [_lzButton sizeToFit];
    _lzButton.frame = CGRectMake(self.contentView.width - BLUThemeMargin * 3 - _lzButton.width, self.genderButton.y, _lzButton.width, self.genderButton.height);

    // Level
    [_lvLabel sizeToFit];

    // Nickname label
    CGFloat nicknameLabelWidth;
    if (_lvLabel.hidden) {
        nicknameLabelWidth = self.contentView.width - self.nicknameLabel.left - (self.contentView.width - self.lzButton.left) - BLUThemeMargin * 2 - self.genderButton.width;
    } else {
        nicknameLabelWidth = self.contentView.width - self.nicknameLabel.left - (self.contentView.width - self.lzButton.left) - BLUThemeMargin * 3 - self.genderButton.width - _lvLabel.width;
    }
    nicknameLabelWidth = self.nicknameLabel.width < nicknameLabelWidth ? self.nicknameLabel.width : nicknameLabelWidth;
    self.nicknameLabel.frame = CGRectMake(self.nicknameLabel.x, self.nicknameLabel.y, nicknameLabelWidth, self.nicknameLabel.height);
    
    // Gender
    self.genderButton.frame = CGRectMake(self.nicknameLabel.right + BLUThemeMargin, self.genderButton.y, self.genderButton.width, self.genderButton.height);
    self.genderButton.centerY = self.nicknameLabel.centerY;

    // Level
    if (_lvLabel.hidden) {
        _lvLabel.frame = CGRectZero;
    } else {
        _lvLabel.x = self.genderButton.right + BLUThemeMargin;
        _lvLabel.centerY = self.genderButton.centerY;
    }

    _lzButton.centerY = self.genderButton.centerY;

    // Solid
    _solidLine.frame = CGRectMake(BLUThemeMargin * 3, self.cellSize.height + BLUThemeMargin * 2, self.contentView.width - BLUThemeMargin * 6, BLUThemeOnePixelHeight);
    postBottom = _solidLine.bottom + BLUThemeMargin * 2;
    
    // Content
    if (self.showContent) {
        CGSize contentLabelSize =[_contentLabel sizeThatFits:CGSizeMake(_solidLine.width, CGFLOAT_MAX)];
        _contentLabel.frame = CGRectMake(_solidLine.left, postBottom, _solidLine.width, contentLabelSize.height);
        postBottom = _contentLabel.bottom + BLUThemeMargin * 2;
    } else {
        _contentLabel.frame = CGRectZero;
    }
    
    // Paragraphs
    if (self.showParagraph) {
        CGFloat paragraphBottom = postBottom;
        CGFloat paragraphWidth = _solidLine.width;
        CGFloat paragraphLeft = _solidLine.left;
        NSInteger textLabelIndex = 0, imageViewIndex = 0, videoViewIndex = 0;
        for (BLUContentParagraph *paragraph in self.post.paragraphs) {
            if ((paragraph.type == BLUPostParagraphTypeText || paragraph.type == BLUPostParagraphTypeRedirectText) && textLabelIndex < self.textParagraphs.count) {
                UILabel *textLabel = self.textParagraphs[textLabelIndex];
                textLabelIndex++;
                CGSize textLabelSize = [textLabel sizeThatFits:CGSizeMake(_solidLine.width, CGFLOAT_MAX)];
                textLabel.frame = CGRectMake(paragraphLeft, paragraphBottom, paragraphWidth, textLabelSize.height);
                paragraphBottom = textLabel.bottom + BLUThemeMargin * 2;
            }
            
            if ((paragraph.type == BLUPostParagraphTypeImage || paragraph.type == BLUPostParagraphTypeRedirectImage) && imageViewIndex < self.imageParagraphs.count) {
                UIImageView *imageView = self.imageParagraphs[imageViewIndex];
                imageViewIndex++;
                imageView.frame = CGRectMake(paragraphLeft, paragraphBottom, paragraphWidth, paragraphWidth * (paragraph.height / paragraph.width));
                paragraphBottom = imageView.bottom + BLUThemeMargin * 2;
            }

            if (paragraph.type == BLUPostParagraphTypeVideo && videoViewIndex < self.videoParagraphs.count) {
                UIButton *button = self.videoParagraphs[videoViewIndex];
                videoViewIndex++;
                button.frame = CGRectMake(paragraphLeft, paragraphBottom, paragraphWidth, paragraphWidth * (paragraph.height / paragraph.width));
                paragraphBottom = button.bottom + BLUThemeMargin * 2;
            }
        }
        
        postBottom = paragraphBottom;
    }
    
    // Image
    @weakify(self);
    [_imageViews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        if (self.showPhotos) {
            if (idx < self.post.photos.count) {
                BLUImageRes *imageRes = self.post.photos[idx];
                CGFloat y = idx > 0 ? ((UIImageView *)self.imageViews[idx - 1]).bottom + BLUThemeMargin : postBottom;
                CGFloat width = self.contentView.width - BLUThemeMargin * 6;
                button.frame = CGRectMake(BLUThemeMargin * 3, y, width, width * (imageRes.height / imageRes.width));
                postBottom = button.bottom + BLUThemeMargin * 2;
            } else {
                button.frame = CGRectZero;
            }
        } else {
            button.frame = CGRectZero;
        }
    }];
   
    _likeButton.frame = CGRectMake(0 - BLUThemeOnePixelHeight, postBottom, self.contentView.width / 4 + BLUThemeOnePixelHeight, kButtonHeight);
    _commentButton.frame = CGRectMake(_likeButton.right - BLUThemeOnePixelHeight, postBottom, self.contentView.width / 4 + BLUThemeOnePixelHeight, kButtonHeight);
    _shareButton.frame = CGRectMake(_commentButton.right - BLUThemeOnePixelHeight, postBottom, self.contentView.width / 4 + BLUThemeOnePixelHeight, kButtonHeight);
    _moreButton.frame = CGRectMake(_shareButton.right - BLUThemeOnePixelHeight, postBottom, self.contentView.width / 4 + BLUThemeOnePixelHeight, kButtonHeight);
  
    if (self.showLikeUsers) {
        _likeTopLine.frame = CGRectMake(0, 0, _likeButton.width, BLUThemeOnePixelHeight);
        _likeBottomImageView.frame = CGRectMake(0, _likeButton.height - 8, _likeButton.width, 8);
    } else {
        _likeTopLine.frame = CGRectZero;
        _likeBottomImageView.frame = CGRectZero;
    }
   
    // Like
    if (self.showLikeUsers) {
        [_likePromptLabel sizeToFit];
        _likePromptLabel.frame = CGRectMake(BLUThemeMargin * 3, 0, _likePromptLabel.width, _likePromptLabel.height);
        _likedUserCollectionView.frame = CGRectMake(_likePromptLabel.right, _likeButton.bottom, self.contentView.width - _likePromptLabel.width, kLikedAvatarButtonHeight + BLUThemeMargin * 2);
        _likePromptLabel.centerY = _likedUserCollectionView.centerY;
        
        _leftShadeImageView.frame = CGRectMake(_likedUserCollectionView.x, _likedUserCollectionView.y, BLUThemeMargin * 2, _likedUserCollectionView.height);
        _rightShadeImageView.frame = CGRectMake(self.contentView.width - BLUThemeMargin * 2, _likedUserCollectionView.y, BLUThemeMargin * 2, _likedUserCollectionView.height);
    } else {
        _likePromptLabel.frame = CGRectZero;
        _likedUserCollectionView.frame = CGRectZero;
        _leftShadeImageView.frame = CGRectZero;
        _rightShadeImageView.frame = CGRectZero;
    }
    
    // Cell size
    self.cellSize = CGSizeMake(self.contentView.width, _likeButton.bottom + (self.showLikeUsers ? _likeButton.height : 0));
}

#pragma mark - Collection view datasouce

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _likedUsers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLUPostLikedUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLUPostLikedUserCollectionViewCell class]) forIndexPath:indexPath];
    // TODO:
    cell.avatarButton.backgroundColor = BLUThemeSubTintContentForegroundColor;
    cell.avatarButton.cornerRadius = kLikedAvatarButtonHeight / 2;
    cell.avatarButton.userInteractionEnabled = NO;
    if (!self.cellForCalcingSize) {
        BLUUser *user = self.likedUsers[indexPath.row];
        cell.avatarButton.imageURL = user.avatar.thumbnailURL;
    }
    return cell;
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
        BLUUser *user = _likedUsers[indexPath.row];
        if (user) {
            NSDictionary *userInfo = @{BLUUserKeyUser: user};
            [self.userTransitionDelegate shouldTransitToUser:userInfo fromView:self sender:nil];
        }
    }
}

#pragma mark - Action

- (NSDictionary *)postInfo {
    NSDictionary *dict = nil;
    if (self.post) {
        dict = @{BLUPostKeyPost: self.post};
    }
    return dict;
}

- (void)likeAction:(UIButton *)button {
    if (self.post.didLike) {
        if (_BLUPostDetailOptDelegateFlags.didDislike) {
            [self.delegate shouldDislikePost:[self postInfo] fromView:self sender:button];
        }
    } else {
        if (_BLUPostDetailOptDelegateFlags.didLike) {
            [self.delegate shouldLikePost:[self postInfo] fromView:self sender:button];
        }
    }
}

- (void)commentAction:(UIButton *)button {
    if (_BLUPostDetailOptDelegateFlags.didComment) {
        [self.delegate shouldCommentPost:[self postInfo] fromView:self sender:button];
    }
}

- (void)ShareAction:(UIButton *)button {
    if (_BLUPostDetailOptDelegateFlags.didShare) {
        [self.delegate shouldSharePost:[self postInfo] fromView:self sender:button];
    }
}

- (void)OtherAction:(UIButton *)button {
    if (_BLUPostDetailOptDelegateFlags.didTriggerOtherAction) {
        [self.delegate shouldTriggerOtherActionForPost:[self postInfo] fromView:self sender:button];
    }
}

- (void)videoAction:(UIButton *)button {
    BLUContentParagraph *postParagraph = self.post.paragraphs[button.tag];
    if (_BLUPostDetailOptDelegateFlags.didPlayVideo && postParagraph.videoURL) {
        [self.delegate shouldPlayVideoForPost:[self postInfo] withVideoURL:postParagraph.videoURL fromView:self sender:button];
    }
}

- (void)showImageAction:(UITapGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)[recognizer view];
    if ([imageView isKindOfClass:[UIImageView class]]) {
        if (imageView.image) {
            if ([self.showImageDelegate respondsToSelector:@selector(showImage:fromSender:)]) {
                [self.showImageDelegate showImage:imageView.image fromSender:imageView];
            }
        } else {
            return;
        }
    } else {
        return;
    }
}

- (void)tapAndRedirectToPostAction:(UITapGestureRecognizer *)recognizer {
    if ([self.redirectDelegate respondsToSelector:@selector(shouldRedirectToPostWithPostID:fromView:sender:)]) {
        [self.redirectDelegate shouldRedirectToPostWithPostID:self.redirectID fromView:self sender:recognizer.view];
    }
}

- (void)tapAndRedirectToCircleAction:(UITapGestureRecognizer *)recognizer {
    if ([self.redirectDelegate respondsToSelector:@selector(shouldRedirectToCircleWithCircleID:fromView:sender:)]) {
        [self.redirectDelegate shouldRedirectToCircleWithCircleID:self.redirectID fromView:self sender:recognizer.view];
    }
}

- (void)tapAndRedirectToWebAction:(UITapGestureRecognizer *)recognizer {
    if ([self.redirectDelegate respondsToSelector:@selector(shouldRedirectToCircleWithCircleID:fromView:sender:)]) {
        if ([self.redirectURL isKindOfClass:[NSURL class]]) {
            [self.redirectDelegate shouldRedirectToWebWithURL:self.redirectURL fromView:self sender:recognizer];
        }
    }
}

- (void)addRedirectActionToView:(UIView *)view withRedirectType:(BLUContentParagraphRedirectType)type {
    NSParameterAssert(type >= 1 && type <= 3);
    SEL selector;
    switch (type) {
        case BLUContentParagraphRedirectTypePost: {
            selector = @selector(tapAndRedirectToPostAction:);
        } break;
        case BLUContentParagraphRedirectTypeWeb: {
            selector = @selector(tapAndRedirectToWebAction:);
        } break;
        case BLUContentParagraphRedirectTypeCircle: {
            selector = @selector(tapAndRedirectToCircleAction:);
        } break;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

@end
