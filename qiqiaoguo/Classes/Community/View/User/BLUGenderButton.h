//
//  BLUGenderButton.h
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUUser.h"

typedef NS_ENUM(NSInteger, BLUGenderButtonType) {
    BLUGenderButtonTypeDefault = 0,
    BLUGenderButtonTypeRoundRect,
    BLUGenderButtonTypeSmall,
};

@interface BLUGenderButton : UIButton

@property (nonatomic, assign) BLUUserGender gender;
@property (nonatomic, assign) BLUGenderButtonType genderButtonType;

- (instancetype)initWithGenderButtonType:(BLUGenderButtonType)genderButtonType;

@end
