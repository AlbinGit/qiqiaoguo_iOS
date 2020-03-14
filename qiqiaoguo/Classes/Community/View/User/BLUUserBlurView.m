//
//  BLUUserBlurView.m
//  Blue
//
//  Created by Bowen on 18/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUserBlurView.h"

const NSString *BLUUserBlurViewMaleImageCacheKey = @"BLUUserBlurViewMaleImageCacheKey";
const NSString *BLUUserBlurViewFemaleImageCacheKey = @"BLUUserBlurViewFemaleImageCacheKey";

@interface BLUUserBlurView ()

@property (nonatomic, strong) UIView *blackMaskView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *blurImageView;

@end

@implementation BLUUserBlurView

- (instancetype)init {
    if (self = [super init]) {
        [self _config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _config];
    }
    return self;
}

- (void)_config {
    
    UIView *superview = self;
    superview.clipsToBounds = YES;
    
    // Image view
    _imageView = [UIImageView new];
    [_imageView.layer addAnimation:[CAAnimation animation] forKey:kCATransition];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [superview addSubview:_imageView];
    
    // Blur image view
    _blurImageView = [UIImageView new];
    _blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_blurImageView.layer addAnimation:[CAAnimation animation] forKey:kCATransition];
    [superview addSubview:_blurImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *superview = self;

    // Image view
    _imageView.frame = superview.bounds;
    
    // Blur image view
    _blurImageView.frame = superview.bounds;
}

- (void)setUser:(BLUUser *)user {
    _user = user;
    self.backgroundColor = BLUThemeMainColor;
    _blurImageView.image = [UIImage imageNamed:@"user-info-bkg"];
}

@end
