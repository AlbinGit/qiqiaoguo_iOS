//
//  BLUImagePickerAlbumContentsCollectionViewCell.m
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

static const CGFloat kIndexLabelHeight = 20.0;

#import "BLUImagePickerAlbumContentsCollectionViewCell.h"

@interface BLUImagePickerAlbumContentsCollectionViewCell ()

@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation BLUImagePickerAlbumContentsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = 2.0f;
        
        // ImageView
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset([BLUCurrentTheme topMargin] / 2);
            make.right.bottom.equalTo(self.contentView).offset(-[BLUCurrentTheme topMargin] / 2);
        }];
        
        // Index Label
        _indexLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        _indexLabel.textColor = BLUThemeMainColor;
        _indexLabel.font = BLUThemeBoldFontWithType(BLUUIThemeFontSizeTypeNormal);
        _indexLabel.borderColor = BLUThemeSubTintBackgroundColor;
        _indexLabel.text = nil;
        _indexLabel.borderWidth = 1.5;
        _indexLabel.cornerRadius = kIndexLabelHeight / 2;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_indexLabel];
        
        [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(BLUThemeMargin);
            make.right.equalTo(self.contentView.mas_right).offset(-BLUThemeMargin);;
            make.height.width.equalTo(@(kIndexLabelHeight));
        }];
        
        [self updateIndexLabelState];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [self updateIndexLabelState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateIndexLabelState];
}

- (void)updateIndexLabelState {
    if (self.selected && index > 0) {
        _indexLabel.borderColor = BLUThemeMainColor;
        _indexLabel.text = [NSString stringWithFormat:@"%@", @(_index)];
    } else {
        _indexLabel.borderColor = BLUThemeSubTintBackgroundColor;
        _indexLabel.text = nil;
    }
}

@end
