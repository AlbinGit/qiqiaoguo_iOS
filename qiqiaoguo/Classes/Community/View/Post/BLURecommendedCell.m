//
//  BLURecommendedCell.m
//  Blue
//
//  Created by Bowen on 14/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLURecommendedCell.h"
#import "BLURecommend.h"
#import "BLURecommendData.h"

@implementation BLURecommendedCell

#pragma mark - BLUCell.

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _verticalRatio1 = 0.64;
        _verticalRatio2 = 0.86;
        _elementSpacing = BLUThemeMargin * 4;

        _poster = [UIImageView new];
        _poster.backgroundColor = [UIColor whiteColor];
        _poster.cornerRadius = BLUThemeHighActivityCornerRadius;
        [self.contentView addSubview:_poster];

        _leftButton = [UIButton new];
        _leftButton.titleFont =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        _leftButton.titleColor = [UIColor whiteColor];

        _rightButton = [UIButton new];
        _rightButton.titleFont =
        BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal);
        _rightButton.titleColor = [UIColor whiteColor];

        _bottomButton = [UIButton new];
        _bottomButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);
        _bottomButton.titleColor = [UIColor colorFromHexString:@"ffb200"];
        _bottomButton.borderWidth = 1.0;
        _bottomButton.borderColor = [UIColor colorFromHexString:@"ffb200"];
        _bottomButton.contentEdgeInsets =
        UIEdgeInsetsMake(BLUThemeMargin / 2.0, BLUThemeMargin * 1.5,
                         BLUThemeMargin / 2.0, BLUThemeMargin * 1.5);

        [_poster addSubview:_leftButton];
        [_poster addSubview:_rightButton];
        [_poster addSubview:_bottomButton];

        self.backgroundColor = BLUThemeSubTintBackgroundColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSInteger posterWidth = self.contentView.width * (_recommend.height / _recommend.width);
    _poster.frame = CGRectMake(BLUThemeMargin * 2, BLUThemeMargin * 1, self.contentView.width - BLUThemeMargin * 4, posterWidth);

    if (_leftButton.hidden == NO && _rightButton.hidden == NO) {
        [_leftButton sizeToFit];
        [_rightButton sizeToFit];

        CGFloat contentY = _verticalRatio1 * _poster.height;
        CGFloat leftX = (_poster.width - _leftButton.width -
                         _rightButton.width - _elementSpacing) / 2.0;
        CGFloat rightX = leftX + _leftButton.width + _elementSpacing;
        _leftButton.frame = CGRectMake(leftX, contentY,
                                       _leftButton.width, _leftButton.height);
        _rightButton.frame = CGRectMake(rightX, contentY,
                                        _rightButton.width, _rightButton.height);
    } else {
        _leftButton.frame = CGRectZero;
        _rightButton.frame = CGRectZero;
    }

    if (_bottomButton.hidden == NO) {
        [_bottomButton sizeToFit];

        CGFloat contentY =_verticalRatio2 * _poster.height;
        CGFloat contentX = (_poster.width - _bottomButton.width) / 2.0;
        _bottomButton.frame = CGRectMake(contentX, contentY,
                                         _bottomButton.width, _bottomButton.height);
        _bottomButton.cornerRadius = _bottomButton.height / 2.0;
    }

    self.cellSize = CGSizeMake(self.contentView.width, _poster.bottom + BLUThemeMargin * 1);
}

#pragma mark - Model

- (void)setModel:(id)model {

    NSParameterAssert([model isKindOfClass:[BLURecommend class]]);
    _recommend = (BLURecommend *)model;
    _poster.image = nil;
    if (!self.cellForCalcingSize) {
        [_poster sd_setImageWithURL:_recommend.imageURL];
    }

    NSString *leftTitle = nil;
    NSString *rightTitle = nil;
    NSString *bottomTitle = nil;

    UIImage *leftImage = nil;
    UIImage *rightImage = nil;

    switch (_recommend.redirectType) {
        case BLUPageRedirectionTypePost: {
            if (_recommend.data.isVideo.boolValue) {
                leftTitle = _recommend.data.accessCount.description;
                rightTitle = _recommend.data.commentCount.description;
                leftImage = [UIImage imageNamed:@"recommend-number-of-views"];
                rightImage = [UIImage imageNamed:@"recommend-number-of-comments"];
            } else {
                leftTitle = _recommend.data.likeCount.description;
                rightTitle = _recommend.data.commentCount.description;
                leftImage = [UIImage imageNamed:@"recommend-number-of-likes"];
                rightImage = [UIImage imageNamed:@"recommend-number-of-comments"];
            }

            leftTitle = [NSString stringWithFormat:@" %@", leftTitle];
            rightTitle = [NSString stringWithFormat:@" %@", rightTitle];
        } break;
        case BLUPageRedirectionTypeCircle: {
            bottomTitle = NSLocalizedString(@"recommend-cell.circle-prompt.hot:%@", @"Hot");
            bottomTitle = [NSString stringWithFormat:bottomTitle, _recommend.data.heat];
        } break;
        case BLUPageRedirectionTypeTag: {
            bottomTitle = NSLocalizedString(@"recommend-cell.tag-prompt.join:%@", @"Join");
            bottomTitle = [NSString stringWithFormat:bottomTitle, _recommend.data.postCount];
        } break;
        case BLUPageRedirectionTypeWeb: {
            // Empty
        } break;
//        case BLUPageRedirectionTypeToy: {
//            bottomTitle = NSLocalizedString(@"recommend-cell.toy-prompt.follow:%@", @"Follow");
//            bottomTitle = [NSString stringWithFormat:bottomTitle, _recommend.data.collectionCount];
//        } break;
    }

    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    _bottomButton.hidden = YES;

    if (leftTitle) {
        _leftButton.hidden = NO;
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        if (leftImage) {
            [self.leftButton setImage:leftImage forState:UIControlStateNormal];
        }
    }

    if (rightTitle) {
        _rightButton.hidden = NO;
        [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
        if (rightImage) {
            [self.rightButton setImage:rightImage forState:UIControlStateNormal];
        }
    }

    if (bottomTitle) {
        _bottomButton.hidden = NO;
        [self.bottomButton setTitle:bottomTitle forState:UIControlStateNormal];
    }
}

@end
