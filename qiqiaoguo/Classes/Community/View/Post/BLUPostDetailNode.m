//
//  ASPostDetailNodel.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailNode.h"
#import "BLUPostDetailUserInfoNode.h"
#import "BLUPost.h"
#import "BLUContentParagraph.h"
#import "BLUCircle.h"
#import "BLUPostTagTextAttachment.h"
#import "BLUPostTag.h"
#import "BLUPostDetailNode+Text.h"
#import "BLUPostDetailNode+Action.h"
#import "BLUPostDetailNode+CollectionNode.h"

static void * const kContentParagraphKey = "kContentParagraphKey";

static const CGFloat kLikedUserAvatarHeight = 24.0;
static const CGFloat kLikedButtonHeight = 75.0;

@implementation BLUPostDetailNode

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);

        _post = post;

        _userNode =
        [[BLUPostDetailUserInfoNode alloc]
         initWithUser:post.author
         postTime:post.createDate.postTime
         anonymous:_post.anonymousEnable];
        [_userNode addTarget:self
                      action:@selector(touchAndShowUserDetails:)
            forControlEvents:ASControlNodeEventTouchUpInside];

        _titleNode = [ASTextNode new];
        _titleNode.attributedString = [self attributedTitle:post.title];
        _titleNode.layerBacked = YES;

        if (_post.contentType != BLUPostContentTypeParagraph) {
            [_post generateParagraphFromNormalContent];
        } else {
            [_post generateParagraphFromPhotos];
        }

        _paragraphNodes = [NSMutableArray new];
        [post.paragraphs
         enumerateObjectsUsingBlock:^(BLUContentParagraph *paragraph,
                                      NSUInteger idx,
                                      BOOL * _Nonnull stop) {
            switch (paragraph.type) {
                case BLUPostParagraphTypeRedirectText:
                case BLUPostParagraphTypeText: {
                    ASTextNode *textNode =
                    [self contentNodeWithParagraph:paragraph];
                    [_paragraphNodes addObject:textNode];
                } break;
                case BLUPostParagraphTypeRedirectImage:
                case BLUPostParagraphTypeImage:
                case BLUPostParagraphTypeVideo: {
                    ASNetworkImageNode *imageNode =
                    [self imageNodeWithParagraph:paragraph];
                    imageNode.image = ImageNamed(@"post-image-default");
                    [_paragraphNodes addObject:imageNode];
                } break;
            }
        }];

        if (post.tags) {
            _tagNode = [ASTextNode new];
            _tagNode.attributedString = [self attributedTags:post.tags];
            _tagNode.linkAttributeNames = [self tagLinkedAttributedNames];
            _tagNode.delegate = self;
            _tagNode.userInteractionEnabled = YES;
            _tagNode.highlightStyle = ASTextNodeHighlightStyleLight;
            _tagNode.longPressCancelsTouches = YES;
        }

//        if (post.circle.shouldVisible == YES) {
            _circleNode = [ASTextNode new];
            _circleNode.attributedString = [self attributedCircle:post.circle];
            _circleNode.linkAttributeNames = [self circleLinkedAttributedNames];
            _circleNode.delegate = self;
            _circleNode.linkAttributeNames = [self circleLinkedAttributedNames];
            _circleNode.userInteractionEnabled = YES;
            _circleNode.highlightStyle = ASTextNodeHighlightStyleLight;
            _circleNode.longPressCancelsTouches = YES;
//        }

        _separator = [ASDisplayNode new];
        _separator.backgroundColor =
        [UIColor colorWithHue:0.33 saturation:0 brightness:0.94 alpha:1];

        [self addSubnode:_userNode];
        [self addSubnode:_titleNode];
        for (ASDisplayNode *node in _paragraphNodes) {
            [self addSubnode:node];
        }
        if (_tagNode) {
            [self addSubnode:_tagNode];
        }
        if (_circleNode) {
            [self addSubnode:_circleNode];
        }
        [self addSubnode:_separator];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    __block CGSize calculateSize = CGSizeZero;
    calculateSize.width = constrainedSize.width;
    calculateSize.height += self.contentInset;
    CGFloat contentWidth = calculateSize.width - self.contentInset * 2;

    CGSize userNodeSize = [_userNode measure:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    calculateSize.height += userNodeSize.height + [self titleTopMargin];

    CGSize titleSize =
    [_titleNode measure:CGSizeMake(contentWidth, constrainedSize.height)];
    calculateSize.height += titleSize.height + self.contentInset;

    [self.paragraphNodes
     enumerateObjectsUsingBlock:^(ASDisplayNode *node,
                                  NSUInteger idx,
                                  BOOL * _Nonnull stop) {
        if ([node isKindOfClass:[ASTextNode class]]) {
            ASTextNode *textNode = (ASTextNode *)node;
            CGSize textNodeSize =
            [textNode measure:CGSizeMake(contentWidth,
                                         constrainedSize.height)];

            calculateSize.height += textNodeSize.height + self.contentMargin;
        } else if ([node isKindOfClass:[ASImageNode class]]) {
            ASImageNode *imageNode = (ASImageNode *)node;
            CGFloat imageWitdh = constrainedSize.width;
            BLUContentParagraph *paragraph =
            [self retrieveParagraphFromNode:imageNode];
            BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
            CGFloat imageHeight = (paragraph.height * imageWitdh) / paragraph.width;

            imageNode.bounds =
            CGRectMake(0, 0, imageWitdh, imageHeight);

            calculateSize.height += imageHeight + self.contentMargin;
        }
    }];

    if (_tagNode) {
        CGSize tagSize =
        [_tagNode measure:CGSizeMake(contentWidth, constrainedSize.height)];
        calculateSize.height += tagSize.height;
        calculateSize.height += [self contentInset];
    }

    if (_circleNode) {
        CGSize circleSize =
        [_circleNode measure:CGSizeMake(contentWidth, constrainedSize.height)];
        calculateSize.height += circleSize.height + self.contentInset;
    }

    CGFloat separatorHeight = BLUThemeOnePixelHeight;
    calculateSize.height += separatorHeight;

    return calculateSize;
}

- (void)layout {
    [super layout];

    __block CGFloat lastBottom = 0;

    _userNode.frame =
    CGRectMake(self.contentInset, self.contentInset,
               _userNode.calculatedSize.width,
               _userNode.calculatedSize.height);

    lastBottom = CGRectGetMaxY(_userNode.frame);
    lastBottom += [self titleTopMargin];

    _titleNode.frame =
    CGRectMake(self.contentInset, lastBottom,
               _titleNode.calculatedSize.width,
               _titleNode.calculatedSize.height);

    lastBottom = CGRectGetMaxY(_titleNode.frame);
    lastBottom += [self contentInset];

    [self.paragraphNodes
     enumerateObjectsUsingBlock:^(ASDisplayNode *node,
                                  NSUInteger idx,
                                  BOOL * _Nonnull stop) {
        if ([node isKindOfClass:[ASTextNode class]]) {
            ASTextNode *textNode = (ASTextNode *)node;
            textNode.frame =
            CGRectMake(self.contentInset, lastBottom,
                       textNode.calculatedSize.width,
                       textNode.calculatedSize.height);
            lastBottom += CGRectGetHeight(textNode.frame);
            lastBottom += [self contentMargin];
        } else if ([node isKindOfClass:[ASImageNode class]]) {
            ASImageNode *imageNode = (ASImageNode *)node;
            imageNode.image = ImageNamed(@"post-image-default");
            imageNode.backgroundColor = BLUThemeSubTintBackgroundColor;
            imageNode.frame =
            CGRectMake(0, lastBottom,
                       CGRectGetWidth(imageNode.frame),
                       CGRectGetHeight(imageNode.frame));
            lastBottom += CGRectGetHeight(imageNode.frame);
            lastBottom += [self contentMargin];

            if (imageNode.subnodes.count > 0) {
                for (ASDisplayNode *node in imageNode.subnodes) {
                    if ([node isKindOfClass:[ASDisplayNode class]]) {
                        node.frame = imageNode.bounds;
                    }
                    if ([node isKindOfClass:[ASImageNode class]]) {
                        CGFloat imageNodeWidth = CGRectGetWidth(imageNode.frame);
                        CGFloat imageNodeHeight = CGRectGetHeight(imageNode.frame);
                        CGFloat playNodeWidth = MIN(imageNodeWidth, imageNodeHeight) / 3.0;
                        CGFloat playNodeX = (imageNodeWidth - playNodeWidth) / 2.0;
                        CGFloat playNodeY = (imageNodeHeight - playNodeWidth) / 2.0;
                        node.frame = CGRectMake(playNodeX, playNodeY, playNodeWidth, playNodeWidth);
                    }
                }
            }
        }
    }];

    if (_tagNode) {
        _tagNode.frame =
        CGRectMake(self.contentInset, lastBottom,
                   _tagNode.calculatedSize.width,
                   _tagNode.calculatedSize.height);

        lastBottom += CGRectGetHeight(_tagNode.frame);
        lastBottom += [self contentInset];
    }

    if (_circleNode) {
        _circleNode.frame =
        CGRectMake(self.contentInset, lastBottom,
                   _circleNode.calculatedSize.width,
                   _circleNode.calculatedSize.height);
        
        lastBottom += CGRectGetHeight(_circleNode.frame);
        lastBottom += self.contentInset;
    }

    _separator.frame =
    CGRectMake(0, lastBottom, self.calculatedSize.width,
               BLUThemeOnePixelHeight);
    lastBottom += BLUThemeOnePixelHeight;
    lastBottom += self.contentInset;

    lastBottom += kLikedButtonHeight;
    lastBottom += self.contentInset;
}

- (void)didLoad {
    self.layer.as_allowsHighlightDrawing = YES;

    for (ASDisplayNode *node in self.paragraphNodes) {
        if ([node isKindOfClass:[ASNetworkImageNode class]]) {

            ASNetworkImageNode *imageNode = (ASNetworkImageNode *)node;

            NSString *urlString = [imageNode.URL.absoluteString lowercaseString];
            if ([urlString containsString:@".gif"]) {
                UIImageView *imageView = [UIImageView new];
                [imageView sd_setImageWithURL:imageNode.URL];
                imageView.frame = imageNode.bounds;
                [imageNode.view addSubview:imageView];
            }
        }
    }

    [super didLoad];
}

- (ASTextNode *)contentNodeWithParagraph:(BLUContentParagraph *)paragraph {
    if (paragraph.type == BLUPostParagraphTypeText ||
        paragraph.type == BLUPostParagraphTypeRedirectText) {

        ASTextNode *textNode = [ASTextNode new];
        [self setParagraph:paragraph toNode:textNode];

        if (paragraph.text) {
            if (paragraph.type == BLUPostParagraphTypeRedirectText) {
                textNode.attributedString = [self attributedLink:paragraph.text];
            } else {
                textNode.attributedString = [self attributedContent:paragraph.text];
            }
        }

        if (paragraph.type == BLUPostParagraphTypeRedirectText) {
            [self addActionToTextNode:textNode];
        } else {
            textNode.layerBacked = YES;
        }

        return textNode;
    } else {
        return nil;
    }
}

- (ASNetworkImageNode *)imageNodeWithParagraph:(BLUContentParagraph *)paragraph {
    if (paragraph.type == BLUPostParagraphTypeImage ||
        paragraph.type == BLUPostParagraphTypeRedirectImage ||
        paragraph.type == BLUPostParagraphTypeVideo) {

        ASNetworkImageNode *imageNode  =
        [[ASNetworkImageNode alloc] initWithWebImage];
        imageNode.image = ImageNamed(@"post-image-default");
        [self setParagraph:paragraph toNode:imageNode];
        imageNode.URL = paragraph.imageURL;
        [self addActionToImageNode:imageNode];

        if (paragraph.type == BLUPostParagraphTypeVideo) {
            ASDisplayNode *blendNode = [ASDisplayNode new];
            blendNode.backgroundColor = [UIColor blackColor];
            blendNode.alpha = 0.5;
            blendNode.layerBacked = YES;

            ASImageNode *playNode = [ASImageNode new];
            playNode.image = [UIImage imageNamed:@"post-play-video"];
            playNode.layerBacked = YES;

            [imageNode addSubnode:blendNode];
            [imageNode addSubnode:playNode];
        }

        return imageNode;
    } else {
        return nil;
    }
}

- (void)setParagraph:(BLUContentParagraph *)paragraph toNode:(id)node {
    BLUAssert(node, @"Node 不能为空");
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    objc_setAssociatedObject(node, kContentParagraphKey, paragraph, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BLUContentParagraph *)retrieveParagraphFromNode:(ASDisplayNode *)node {
    BLUAssert(node, @"Node 不能为空");
    BLUContentParagraph *paragraph = objc_getAssociatedObject(node, kContentParagraphKey);
    return paragraph;
}

- (CGFloat)contentInset {
    return BLUThemeMargin * 4;
}

- (CGFloat)contentMargin {
    return BLUThemeMargin * 2;
}

- (CGFloat)titleTopMargin {
    return BLUThemeMargin * 6;
}

- (CGFloat)likedUserAvatarHeight {
    return kLikedUserAvatarHeight;
}

- (CGFloat)likedUserCollectionNodeHeight {
    return kLikedUserAvatarHeight + BLUThemeMargin * 2;
}

@end
