//
//  BLUAvatarButton.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAvatarButton.h"
#import "SDWebImageManager.h"
//#import "QGUpdateUserheadHttpDownload.h"
#import "SACommon.h"

@implementation BLUAvatarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self _config];
    return self;
}

- (instancetype)init {
    self = [super init];
    [self _config];
    return self;
}

- (void)_config {
//    self.gender = BLUUserGenderMale;
    self.contentMode = UIViewContentModeScaleToFill;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)setGender:(BLUUserGender)gender {
    if (![BLUAppManager sharedManager].currentUser) {
        self.image = [UIImage imageNamed:@"user-logout-icon"];
    }else
    {
    self.image = [UIImage imageNamed:@"user_default_icon"];
    }
}

- (void)setUser:(BLUUser *)user {
    _user = user;
    
    if (!_user) {
        return;
    }
    else if (user.avatar.thumbnailURL) {
        [self setImageURL:user.avatar.thumbnailURL];
    } else if(user.WechatHeadimgURL){
        self.imageURL = user.WechatHeadimgURL;
    }else
    {
         self.gender = user.gender;
    }
}

- (void)setUser:(BLUUser *)user anonymous:(BOOL)anonymous {
    if (anonymous) {
        _user = user;
        self.image = [BLUCurrentTheme anonymousAvatar];
    } else {
        [self setUser:user];
    }
}


@end
