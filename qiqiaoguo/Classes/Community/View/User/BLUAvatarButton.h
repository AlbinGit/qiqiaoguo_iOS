//
//  BLUAvatarButton.h
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUAvatarButton : UIButton

@property (nonatomic, assign) BLUUserGender gender;
@property (nonatomic, strong) BLUUser *user;

- (void)setUser:(BLUUser *)user anonymous:(BOOL)anonymous;

@end
