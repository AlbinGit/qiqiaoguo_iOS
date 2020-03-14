//
//  BLUGenderButton.m
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUGenderButton.h"

@implementation BLUGenderButton

@synthesize gender = _gender;

- (void)setGender:(BLUUserGender)gender {
    _gender = gender;

    self.image = [UIImage userGenderImageWithGender:gender];

    self.imageView.contentMode = UIViewContentModeScaleToFill;
}

- (instancetype)init {
    return [self initWithGenderButtonType:BLUGenderButtonTypeDefault];
}

- (instancetype)initWithGenderButtonType:(BLUGenderButtonType)genderButtonType {
    if (self = [super init]) {
        _genderButtonType = genderButtonType;
        self.userInteractionEnabled = NO;
        return self;
    }
    return nil;
}

@end
