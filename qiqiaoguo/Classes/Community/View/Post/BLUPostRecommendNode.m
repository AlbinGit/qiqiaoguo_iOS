//
//  BLUPostRecommendNode.m
//  Blue
//
//  Created by Bowen on 8/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostRecommendNode.h"
#import "BLUPost.h"
#import "BLUCircle.h"

#define kCellMargin (BLUThemeMargin * 3)
#define kContentMargin (BLUThemeMargin * 2)

static const CGFloat kCircleNodeSize = 36.0;
static const NSInteger kImagesCount = 4;

@interface BLUPostRecommendNode ()

@property (nonatomic, strong) ASNetworkImageNode *circleNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *divider;
@property (nonatomic, strong) ASDisplayNode *container;

@property (nonatomic, strong) ASTextNode *postTitleNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) NSMutableArray *imageNodes;
@property (nonatomic, strong) ASNetworkImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *nicknameNode;
@property (nonatomic, strong) ASImageNode *genderNode;
@property (nonatomic, strong) ASTextNode *timeNode;
@property (nonatomic, strong) ASImageNode *commentImageNode;
@property (nonatomic, strong) ASTextNode *commentNode;

@end

@implementation BLUPostRecommendNode

- (instancetype)initWithPost:(BLUPost *)post {
    if (!(self = [super init])) {
        return nil;
    }

    _circleNode = [[ASNetworkImageNode alloc] initWithWebImage];
    _circleNode.URL = post.circle.logo.thumbnailURL;
    _circleNode.backgroundColor = [UIColor whiteColor];
    _circleNode.imageModificationBlock = ^UIImage *(UIImage *image) {
        // TODO:
        return image;
    };
    [self addSubnode:_circleNode];

    _titleNode = [[ASTextNode alloc] init];
    _titleNode.backgroundColor = BLUThemeMainTintBackgroundColor;
    _titleNode.layerBacked = YES;
    // TODO:
    _titleNode.attributedString = [[NSAttributedString alloc] initWithString:post.circle.name];
    _titleNode.maximumNumberOfLines = 1;
    [self addSubnode:_titleNode];

    // TODO: Join button

    _divider = [ASDisplayNode new];
    _divider.layerBacked = YES;
    _divider.backgroundColor = BLUThemeSubTintBackgroundColor;
    [self addSubnode:_divider];

    _container = [ASDisplayNode new];
    _container.layerBacked = YES;
    _container.backgroundColor = [UIColor randomColor];
    [self addSubnode:_container];

    _postTitleNode = [ASTextNode new];
    _postTitleNode.backgroundColor = [UIColor randomColor];
    _postTitleNode.layerBacked = YES;
    // TODO:
    _postTitleNode.attributedString = [[NSAttributedString alloc] initWithString:post.title];
    _postTitleNode.maximumNumberOfLines = 1;
    [self addSubnode:_postTitleNode];

    _contentNode = [ASTextNode new];
    _contentNode.backgroundColor = [UIColor randomColor];
    _contentNode.layerBacked = YES;
    _contentNode.attributedString = [NSAttributedString contentAttributedStringWithContent:post.content];
    [self addSubnode:_contentNode];

    _imageNodes = [NSMutableArray new];
    [post.photos enumerateObjectsUsingBlock:^(BLUImageRes *imageRes, NSUInteger idx, BOOL * _Nonnull stop) {
        ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] initWithWebImage];
        imageNode.URL = imageRes.thumbnailURL;
        imageNode.backgroundColor = [UIColor randomColor];
        [self addSubnode:imageNode];
        [_imageNodes addObject:imageNode];
    }];

    _avatarNode = [ASNetworkImageNode new];
    _avatarNode.backgroundColor = [UIColor randomColor];
    _avatarNode.URL = post.author.avatar.thumbnailURL;
    _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
        UIImage *modifiedImage;
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:image.size.height / 2.0] addClip];
        [image drawInRect:rect];
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return modifiedImage;
    };
    [self addSubnode:_avatarNode];

    _nicknameNode = [ASTextNode new];
    _nicknameNode.backgroundColor = [UIColor randomColor];
    _nicknameNode.layerBacked = YES;
    _nicknameNode.maximumNumberOfLines = 1;
    _nicknameNode.attributedString = [[NSAttributedString alloc] initWithString:post.author.nickname];
    [self addSubnode:_nicknameNode];

    _genderNode = [ASImageNode new];
    _genderNode.layerBacked = YES;
    _genderNode.image = [UIImage userGenderImageWithGender:post.author.gender];
    [self addSubnode:_genderNode];

    _timeNode = [ASTextNode new];
    _timeNode.backgroundColor = [UIColor randomColor];
    _timeNode.layerBacked = YES;
    _timeNode.attributedString = [[NSAttributedString alloc] initWithString:post.createDate.postTime];
    [self addSubnode:_timeNode];

    _commentImageNode = [ASImageNode new];
    _commentImageNode.backgroundColor = [UIColor randomColor];
    _commentImageNode.layerBacked = YES;
    _commentImageNode.image = [BLUCurrentTheme postCommentIcon];
    [self addSubnode:_commentImageNode];

    _commentNode = [ASTextNode new];
    _commentNode.backgroundColor = [UIColor randomColor];
    _commentNode.layerBacked = YES;
    _commentNode.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(post.commentCount)]];
    [self addSubnode:_commentNode];

    self.shouldRasterizeDescendants = YES;
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    [_titleNode measure:CGSizeMake(constrainedSize.width - kCircleNodeSize - kCellMargin * 2 - kContentMargin, constrainedSize.height)];

    CGFloat postTitleNodeWidth = constrainedSize.width - kCellMargin * 2 - kCircleNodeSize - kContentMargin * 2;

    CGSize postTitleSize = [_postTitleNode measure:CGSizeMake(postTitleNodeWidth, constrainedSize.height)];
    CGSize contentSize = [_contentNode measure:CGSizeMake(postTitleNodeWidth, constrainedSize.height)];
    CGFloat imageNodeWidth = (constrainedSize.width - kContentMargin * 2 - kCellMargin * 2 - kCircleNodeSize - BLUThemeMargin * (kImagesCount - 1)) / kImagesCount;
    CGSize imageNodeSize = CGSizeMake(imageNodeWidth, imageNodeWidth);

    BOOL shouldShowContent = _contentNode.attributedString.string.length > 0;
    BOOL shouldShowImages = _imageNodes.count > 0;

    CGSize timeSize = [_timeNode measure:CGSizeMake(postTitleNodeWidth, constrainedSize.height)];
    CGSize commentSize = [_commentNode measure:CGSizeMake(postTitleNodeWidth, constrainedSize.height)];
    [_commentNode measure:CGSizeMake(postTitleNodeWidth - timeSize.height - BLUThemeMargin - BLUThemeMargin - timeSize.height - BLUThemeMargin - timeSize.width - BLUThemeMargin - timeSize.height - BLUThemeMargin - commentSize.width, timeSize.height)];

    CGFloat requiredHeight = kCellMargin + kCircleNodeSize + kContentMargin + postTitleSize.height + (shouldShowContent ? kContentMargin + contentSize.height : 0 ) + (shouldShowImages ? kContentMargin + imageNodeSize.height : 0) + kContentMargin + timeSize.height + kContentMargin + kCellMargin;

    return CGSizeMake(constrainedSize.width, requiredHeight);
}

- (void)layout {
    _circleNode.frame = CGRectMake(kCellMargin, kCellMargin, kCircleNodeSize, kCircleNodeSize);

    CGSize titleSize = _titleNode.calculatedSize;
    CGFloat titleY = _circleNode.bounds.size.height / 2 + _circleNode.frame.origin.y - titleSize.height / 2;
    _titleNode.frame = CGRectMake(kContentMargin + kCircleNodeSize + kCellMargin, titleY, titleSize.width, titleSize.height);

    CGSize postTitleSize = _postTitleNode.calculatedSize, contentSize;
    BOOL shouldShowContent = !(_contentNode.attributedString.string.length == 0);
    if (shouldShowContent) {
        contentSize = _contentNode.calculatedSize;
    } else {
        contentSize = CGSizeZero;
    }

    CGPoint postTitleOrigin = CGPointMake(kCellMargin + kCircleNodeSize + kContentMargin, kCellMargin + kCircleNodeSize + kContentMargin);
    _postTitleNode.frame = CGRectMake(postTitleOrigin.x, postTitleOrigin.y, postTitleSize.width, postTitleSize.height);

    CGPoint contentOrigin = CGPointMake(postTitleOrigin.x, postTitleOrigin.y + postTitleSize.height + kContentMargin);
    _contentNode.frame = CGRectMake(contentOrigin.x, contentOrigin.y, contentSize.width, contentSize.height);

    CGFloat imageNodeWidth = (self.frame.size.width - kContentMargin * 2 - kCellMargin * 2 - kCircleNodeSize - BLUThemeMargin * (kImagesCount - 1)) / kImagesCount;
    CGFloat imageNodeHeight = 0;

    BOOL shouldShowImage = _imageNodes.count > 0;
    if (shouldShowImage) {
        imageNodeHeight = imageNodeWidth;

        __block CGPoint imageNodeOrigin;
        if (shouldShowContent) {
            imageNodeOrigin = CGPointMake(postTitleOrigin.x, contentOrigin.y + contentSize.height + kContentMargin);
        } else {
            imageNodeOrigin = CGPointMake(postTitleOrigin.x, postTitleOrigin.y + postTitleSize.height + kContentMargin);
        }

        [_imageNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode *imageNode, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= kImagesCount) {
                *stop = YES;
            } else {
                imageNode.frame = CGRectMake(imageNodeOrigin.x, imageNodeOrigin.y, imageNodeWidth, imageNodeHeight);
                imageNodeOrigin = CGPointMake(imageNodeOrigin.x + imageNodeWidth + BLUThemeMargin, imageNodeOrigin.y);
            }
        }];
    } else {
        imageNodeHeight = 0;
    }

    CGFloat avatarY = postTitleOrigin.y + postTitleSize.height + (shouldShowContent ? kContentMargin + contentSize.height : 0) + (shouldShowImage ? kContentMargin + imageNodeHeight : 0) + kContentMargin;
    CGFloat avatarWidth = _timeNode.calculatedSize.height;
    _avatarNode.frame = CGRectMake(postTitleOrigin.x, avatarY, avatarWidth, avatarWidth);
    _avatarNode.clipsToBounds = YES;
    _avatarNode.borderWidth = 1.0;
    _avatarNode.borderColor = [UIColor randomColor].CGColor;
    _avatarNode.cornerRadius = avatarWidth;

    CGFloat containerHeight = kContentMargin + postTitleSize.height + (shouldShowContent ? kContentMargin + contentSize.height : 0) + (shouldShowImage ? kContentMargin + imageNodeHeight : 0) + kContentMargin + avatarWidth + kContentMargin;
    _container.frame = CGRectMake(kCellMargin + kCircleNodeSize, kCellMargin + kCircleNodeSize, self.frame.size.width - kCellMargin * 2 - kCircleNodeSize, containerHeight);
}

@end
