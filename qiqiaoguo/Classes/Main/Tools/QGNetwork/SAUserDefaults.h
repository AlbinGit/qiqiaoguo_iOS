//
//  SAUserDefaults.h
//  SaleAssistant
//
//  Created by Albin on 14-10-30.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#define USERDEFAULTS_USERNAME @"username" // 用户名
#define USERDEFAULTS_PASSWORD @"password" // 密码
#define USERDEFAULTS_UID @"uid"//客户的uid
#define USERDEFAULTS_id @"id" //用户ID
#define USERDEFAULTS_en_uid @"en_uid"
#define USERDEFAULTS_username @"username"
#define USERDEFAULTS_email @"email"
#define USERDEFAULTS_uname @"uname"
#define USERDEFAULTS_sex @"sex"
#define USERDEFAULTS_phonenumber @"phonenumber"
#define USERDEFAULTS_rank @"rank"
#define USERDEFAULTS_scores @"scores"
#define USERDEFAULTS_openId @"openId"
#define USERDEFAULTS_SESSIONId @"sessionId"
#define USERDEFAULTS_COOKIE @"Cookie"
#define USERDEFAULTS_TEAM_CHAT_NOTICE @"teamChatNotice"//群组聊天提醒
#define USERDEFAULTS_IM_TOKEN @"imUserName"//im登陆账号
#define USERDEFAULTS_IM_ACCID @"imPassword"//im登陆密码
#define USERDEFAULTS_Platform_id @"platform_id"//平台ID
#define USERDEFAULTS_registrationID @"registrationID"//推送的toukenId
#define USERDEFAULTS_Version @"version"//平台ID
#define USERINFONEEDUPDATE @"userInfoNeedUpdate"//用户信息需要刷新
#define USERDEFAULTS_Class @"userClass" // 用户班级
#define USERDEFAULTS_IndexPath @"indexPath" // 记录选中
#define USERDEFAULTS_ClassID @"userClassID" // 用户班级ID

#define USERDEFAULTS_City @"USERDEFAULTS_City" //城市

#define PLATFORMID [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id]

/**店铺id*/
#define USERDEFAULTS_SID @"sid"
#import <Foundation/Foundation.h>

@interface SAUserDefaults : NSObject

+ (void)saveValue:(id)value forKey:(NSString *)key;
+ (id)getValueWithKey:(NSString *)key;
+ (void)removeWithKey:(NSString *)key;
+ (void)removeAllKey;

@end
