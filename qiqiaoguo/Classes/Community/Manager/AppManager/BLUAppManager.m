//
//  BLUAppManager.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUAppManager.h"
#import "BLUUser.h"
#import "BLUApiManager.h"
#import "BLUApiManager+User.h"

static NSString * const BLUAppManagerUserKey = @"BLUAppManagerUserKey";
static NSString * const BLUAppManagerCurrentUserID = @"BLUAppManagerCurrentUserID";
NSString *BLUAppManagerUserLoginRequiredNotification = @"BLUAppManagerUserLoginRequiredNotification";

@interface BLUAppManager ()

@end

@implementation BLUAppManager

@synthesize currentUser = _currentUser;

+ (instancetype)sharedManager {
    static BLUAppManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BLUAppManager new];
    });
    
    return manager;
}

- (BLUUser *)currentUser {
    if (_currentUser != nil) {
        return _currentUser;
    }

    NSNumber *userID = [[NSUserDefaults standardUserDefaults] objectForKey:BLUAppManagerCurrentUserID];
    if (userID.integerValue > 0) {
        BLUUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[self userPlistPathWithUserID:userID]];
        if (user) {
            _currentUser = user;
            BLULogInfo(@"Get current user success.");
        } else {
            _currentUser = nil;
            BLULogError(@"Current user not exist.");
        }
    } else {
        _currentUser = nil;
        BLULogError(@"Current user not exist.");
    }

    return _currentUser;
}

- (void)setCurrentUser:(BLUUser *)currentUser {
    _currentUser = currentUser;
    if (currentUser != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(currentUser.userID) forKey:BLUAppManagerCurrentUserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([NSKeyedArchiver archiveRootObject:currentUser toFile:[self userPlistPathWithUserID:@(currentUser.userID)]]) {
            BLULogInfo(@"Save user success");
        } else {
            BLULogError(@"Save user failed");
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:BLUAppManagerCurrentUserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)logOut {
    _currentUser = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:BLUAppManagerCurrentUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[BLUApiManager sharedManager] deleteAllCookie];
    [SAUserDefaults removeWithKey:USERDEFAULTS_COOKIE];
    BLULogInfo(@"User did logout");
}

- (NSString *)userPlistPathWithUserID:(NSNumber *)userID{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@-%@", BLUAppManagerUserKey, userID];
    path = [path MD5String];
    path = [path stringByAppendingString:@".plist"];
    path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
    return path;
}

- (BOOL)didUserLogin {
    return [[BLUAppManager sharedManager] currentUser] != nil;
}

- (RACSignal *)updateCurrentUser {
    if (_currentUser == nil) {
        return [RACSignal empty];
    } else {
        @weakify(self);
        return [[[BLUApiManager sharedManager]
                fetchUserWithUserID:_currentUser.userID] doNext:^(BLUUser *user) {
            @strongify(self);
            self.currentUser = user;
        }];
    }
}

@end
