//
//  BLUAlterUserViewModel.h
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUAlterUserViewModel : BLUViewModel

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) BLUUserMarriage marriage;
@property (nonatomic, strong) UIImage *avatarImage;

- (RACSignal *)alter;
- (RACSignal *)updateNickname;
- (RACSignal *)updateHeadImage;
@end
