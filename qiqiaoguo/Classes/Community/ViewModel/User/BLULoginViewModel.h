//
//  BLULoginViewModel.h
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLULoginViewModel : BLUViewModel

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, weak) BLUViewController *viewController;

- (RACCommand *)login;
- (RACCommand *)wechatLogin;
//- (RACCommand *)qqLogin;
//- (RACCommand *)sinaLogin;

@end
