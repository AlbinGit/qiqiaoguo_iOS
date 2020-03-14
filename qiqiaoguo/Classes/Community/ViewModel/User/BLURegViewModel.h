//
//  BLURegViewModel.h
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLURegViewModel : BLUViewModel

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BLUUserGender gender;
@property (nonatomic, strong) UIImage *avatarImage;

- (RACCommand *)reg;

@end
