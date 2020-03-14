//
//  QGHttpManager+User.m
//  qiqiaoguo
//
//  Created by cws on 16/6/23.
//
//

#import "QGHttpManager+User.h"
#import "QGLoginUser.h"
#import "BLUUserProfit.h"
#import "BLUPost.h"
#import "QGSearchResultGoodsModel.h"

#define QGUserChechin         (BLUApiString(@"/Phone/User/checkIn"))
#define QGUserboundMobile     (BLUApiString(@"/Phone/User/boundMobile"))
#define QGUserPostPublished   (BLUApiString(@"/Phone/User/getPublishedPostList"))
#define QGUserPostCollection  (BLUApiString(@"/Phone/User/getFollowingPostList"))
#define QGUserPostParticipated      (BLUApiString(@"/Phone/User/getParticipatedPostList"))

#define QGUserCollectionGoods       (BLUApiString(@"/Phone/User/getFollowingGoodsList"))

#define QGUserCollection            (BLUApiString(@"/Phone/User/addFollow"))
#define QGCannelCollection          (BLUApiString(@"/Phone/User/removeFollow"))
#define QGUpdateDeviceToken         (BLUApiString(@"/Phone/User/updateDeviceToken"))
#define QGUserMessageCount          (BLUApiString(@"/Phone/Message/getNotifyCount"))
#define QGDelegatePost              (BLUApiString(@"/posts/user"))

@implementation QGHttpManager (User)
+ (void)loginWithMobile:(NSString *)mobile Password:(NSString *)password Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSParameterAssert(mobile);
    NSParameterAssert(password);
    NSDictionary *parameters = @{@"username": mobile, @"password": password};
    
    [self POST:QGLogin params:parameters resultClass:[BLUUser class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:QGLogin]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [SAUserDefaults saveValue:data forKey:USERDEFAULTS_COOKIE];
        
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
    

}

+ (void)thirdLoginWithUser:(BLUUser *)user Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSParameterAssert(user);
    NSLog(@"%@",[user class]);
    NSDictionary *dic =@{@"headUrl": user.avatar.thumbnailURL,
                         @"sex": @(user.gender),
                         @"openId":user.openID,
                         @"partner_type":@(user.openPlatformType),
                         @"username":user.nickname};
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    if (user.unionID) {
        [parameters setValue:user.unionID forKey:@"unionid"];
    }

    
    [self POST:QGThirdLogin params:parameters resultClass:[BLUUser class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:QGThirdLogin]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            [SAUserDefaults saveValue:data forKey:USERDEFAULTS_COOKIE];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(task,error);
        }
    }];
    
}

+ (void)getValidationCodeWithMobile:(NSString *)mobile AndType:(Codetype)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSString *typeString = nil;
    switch (type) {
        case Codetyperegister:
            typeString = @"register";
            break;
        case Codetypepassword:
            typeString = @"password";
            break;
        case Codetypebinding:
            typeString = @"bound";
            break;
        default:
            break;
    }
    NSDictionary *params = @{@"tel":mobile,@"type":typeString};
    [self POST:QGGetNewCaptchaPath params:params resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(task,error);
        }
    }];
    
    
}

+ (void)checkValidationCodeWithMobile:(NSString *)mobile AndCode:(NSString *)code Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSDictionary *params = @{@"tel":mobile,@"captcha":code};
    
    [self POST:QGCheckCaptcha params:params resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(task,error);
        }
    }];
    
}


+ (void)registerWithMobile:(NSString *)mobile Code:(NSString *)code Nickname:(NSString *)nickname Password:(NSString *)password Headimage:(UIImage *)image Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSDictionary *params = @{@"tel":mobile,
                             @"password":password,
                             @"nickname":nickname,
                             @"captcha":code};
    
    [self POST:QGTelRegister params:params image:image resultClass:[BLUUser class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)resetPasswordWithMobile:(NSString *)mobile Code:(NSString *)code NewPassword:(NSString *)password Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSDictionary *params = @{@"tel":mobile,
                             @"password":password,
                             @"captcha":code};
    
    [self POST:QGrRsetPassword params:params resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

/**用户注销*/
+ (void)UserLogoutSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    NSDictionary *params = @{@"uid":@(user.userID)};
    [self POST:QGlogout params:params resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

/**修改用户昵称*/
+ (void)UserUpdateNicknameWithNewNickname:(NSString *)nickname Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    NSDictionary *params = @{@"uid":@(user.userID),@"uname":nickname};
    [self POST:QGUpdateUserName params:params resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

/**更新用户头像*/
+ (void)UserUpdateHeadImageWithNewImage:(UIImage *)image Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    NSDictionary *params = @{@"uid":@(user.userID)};
    
    [self POST:QGUpdateUserhead params:params image:image resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

/**获取用户详情*/
+ (void)getUserDetaileWithUserID:(NSInteger)uid Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSDictionary *params = @{@"user_id":@(uid)};
    
    [self GET:QGGetUserInfo params:params resultClass:[BLUUser class] objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)UserCheckInSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self POST:QGUserChechin params:@{@"platform_id":PLATFORMID} resultClass:[BLUUserProfit class] objectKeyPath:QGApiObjectKeyUserProfit success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

/**获取用户消息数*/
+ (void)getUserMessageConutSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self GET:QGUserMessageCount params:@{@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:QGApiObjectKeyItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

/**用户绑定手机*/
+ (void)UserBoundMobile:(NSString *)mobile Code:(NSString *)code password:(NSString *)password Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSDictionary *params = @{@"platform_id":PLATFORMID,@"tel":mobile,@"captcha":code,@"pwd":password};
    
    [self POST:QGUserboundMobile params:params resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];

}

/**获取用户发表的帖子*/
+ (void)getUserPostsWithType:(UserPostType)type page:(NSInteger)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSString *url = nil;
    switch (type) {
        case UserPostTypePublished: {
            url = QGUserPostPublished;
            break;
        }
        case UserPostTypeCollection: {
            url = QGUserPostCollection;
            break;
        }
        case UserPostTypeParticipated:{
            url = QGUserPostParticipated;
        }break;
    }
    
    [self GET:url params:nil resultClass:[BLUPost class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}
/**删除帖子*/
+ (void)delegateUserPostWithPostID:(NSInteger)postID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self Delegate:QGDelegatePost params:@{@"post_id":@(postID)} resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

// 获取用户收藏的商品列表
+ (void)getUserCollectionGoodsWithPage:(NSInteger)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    [self GET:QGUserCollectionGoods params:@{@"page":@(page)} resultClass:[QGSearchResultGoodsModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)CollectionWithCollectType:(UserCollectionType)type objectID:(NSInteger)objectID isCollection:(BOOL)isCollect Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    
    NSString *URLStr = nil;
    if (isCollect) {
        URLStr = QGUserCollection;
    }else{
        URLStr = QGCannelCollection;
    }
    
    
    [self POST:URLStr params:@{@"type":@(type),@"object_id":@(objectID)} resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}

+ (void)updateDeviceToken:(NSString *)token Success:(QGResponseSuccess)success failure:(QGResponseFail)failure{
    NSLog(@"%@",token);
    if (!token) {
        return;
    }
    
    [self POST:QGUpdateDeviceToken params:@{@"token":token} resultClass:nil objectKeyPath:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
}


@end
