//
//  BLUSettingViewController+Private.h
//  Blue
//
//  Created by Bowen on 2/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#ifndef Blue_BLUSettingViewController_Private_h
#define Blue_BLUSettingViewController_Private_h


typedef NS_ENUM(NSInteger, SettingSection) {
    SettingSectionPushMessage = 0,
    SettingSectionSecurity,
    SettingSectionClearCache,
    SettingSectionAbout,
    SettingSectionLogOut,
    SettingSectionRecommand,
    SettingSectionCount,
};

typedef NS_ENUM(NSInteger, Security) {
    SecurityPrivacyPassword = 0,
    SecurityCount,
};

typedef NS_ENUM(NSInteger, PushMessage) {
    PushMessageSwitch = 0,
    PushMessageCount,
};

typedef NS_ENUM(NSInteger, About) {
    AboutIdea = 0,
    AboutInfo,
    AboutCount,
    AboutQA = 0,
    AboutMark,
};

typedef NS_ENUM(NSInteger, Recommand) {
    RecommandApp,
    RecommandCount,
};

typedef NS_ENUM(NSInteger, LogOut) {
    LogOutAccount = 0,
    LogOutCount,
};

#endif
