//
//  UIImage+User.m
//  Blue
//
//  Created by Bowen on 17/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "UIImage+User.h"

@implementation UIImage (User)

+ (UIImage *)postGenderImageWithGender:(BLUUserGender)gender {

    switch (gender) {
        case BLUUserGenderSecret: {
            return [UIImage imageNamed:@"post-common-secret"];
        } break;
        case BLUUserGenderMale: {
            return [UIImage imageNamed:@"post-common-male"];
        } break;
        case BLUUserGenderFemale: {
            return [UIImage imageNamed:@"post-common-female"];
        } break;
        default: {
            return [UIImage imageNamed:@"post-common-secret"];
        } break;
    }

    return [UIImage imageNamed:@"post-common-secret"];
}

+ (UIImage *)userGenderImageWithGender:(BLUUserGender)gender {
    switch (gender) {
        case BLUUserGenderSecret: {
            return [UIImage imageNamed:@"user-gender-secret"];
        } break;
        case BLUUserGenderMale: {
            return [UIImage imageNamed:@"user-male-icon"];
        } break;
        case BLUUserGenderFemale: {
            return [UIImage imageNamed:@"user-female-icon"];
        } break;
        default: {
            return [UIImage imageNamed:@"user-gender-secret"];
        } break;
    }

    return [UIImage imageNamed:@"user-gender-secret"];
}

+ (UIImage *)userAvatarWithGender:(BLUUserGender)gender {
    if (gender == BLUUserGenderFemale) {
        return [UIImage imageNamed:@"user-male-avatar-icon"];
    } else if (gender == BLUUserGenderMale) {
        return [UIImage imageNamed:@"user-female-avatar-icon"];
    } else {
        return [UIImage imageNamed:@"user-not-login"];
    }
}

@end
