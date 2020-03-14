//
//  BLUPostLikedUserCollectionViewCell.m
//  Blue
//
//  Created by Bowen on 12/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostLikedUserCollectionViewCell.h"

@implementation BLUPostLikedUserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _config];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _config];
    }
    return self;
}

- (void)_config {
    _avatarButton = [BLUAvatarButton new];
    [self.contentView addSubview:_avatarButton];
    
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
