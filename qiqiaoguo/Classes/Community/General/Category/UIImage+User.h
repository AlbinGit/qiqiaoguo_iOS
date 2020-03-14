//
//  UIImage+User.h
//  Blue
//
//  Created by Bowen on 17/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (User)

+ (UIImage *)postGenderImageWithGender:(BLUUserGender)gender;
+ (UIImage *)userGenderImageWithGender:(BLUUserGender)gender;
+ (UIImage *)userAvatarWithGender:(BLUUserGender)gender;

@end
