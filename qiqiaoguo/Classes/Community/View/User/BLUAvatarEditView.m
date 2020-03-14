//
//  BLUAvatarEditView.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAvatarEditView.h"
#import "BLUAvatarButton.h"

@implementation BLUAvatarEditView

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
    // Aavtar button
    _avatarButton = [BLUAvatarButton new];
    _avatarButton.backgroundColor = [UIColor randomColor];
    [self addSubview:_avatarButton];
    
    // Photo button
    _photoView = [UIImageView new];
    _photoView.image = [BLUCurrentTheme postTakePhotoIcon];
//    _photoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_photoView];

}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
//    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//        make.centerX.equalTo(self).multipliedBy(1.5);
//    }];
//    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatarButton.cornerRadius = self.width / 2;
    [_photoView sizeToFit];
    _photoView.frame = CGRectMake(self.width - _photoView.width * 1.5, self.height - _photoView.height, _photoView.width, _photoView.height);

}

@end
