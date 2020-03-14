//
//  BLUUserGenderImageNode.m
//  Blue
//
//  Created by Bowen on 21/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUUserGenderImageNode.h"

@implementation BLUUserGenderImageNode

- (instancetype)initWithGender:(BLUUserGender)gender {
    if (self = [super init]) {
        self.image = [UIImage userGenderImageWithGender:gender];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
