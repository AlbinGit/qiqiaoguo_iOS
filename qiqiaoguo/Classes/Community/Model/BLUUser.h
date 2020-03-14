//
//  BLUUserInfo.h
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"
#import "QGSocialService.h"

@class BLUImageRes;

typedef NS_ENUM(NSInteger, BLUUserInfoType) {
    BLUUserInfoTypeAvatar = 0,
    BLUUserInfoTypeMobile,
    BLUUserInfoTypeNickname,
    BLUUserInfoTypeAge,
    BLUUserInfoTypeMarriage,
    BLUUserInfoTypeLocation,
    BLUUserInfoTypeSignature,
    BLUUserInfoTypeCount,
};

typedef NS_ENUM(NSInteger, BLUUserGender) {
    BLUUserGenderFemale = 0,
    BLUUserGenderMale,
    BLUUserGenderSecret,
};

typedef NS_ENUM(NSInteger, BLUUserMarriage) {
    BLUUserMarriageSecrecy = 0,
    BLUUserMarriageSingle,
    BLUUserMarriageInLove,
    BLUUserMarriageMarried,
    BLUUserMarriageDivorced,
};

UIKIT_EXTERN NSInteger BLUUserSignatureMaxLength;
UIKIT_EXTERN NSInteger BLUUserNicknameMaxLength;

UIKIT_EXTERN NSString * const BLUUserKeyUserID;
UIKIT_EXTERN NSString * const BLUUserKeyUser;
UIKIT_EXTERN NSString * const BLUUserKeyCreateDate;
UIKIT_EXTERN NSString * const BLUUserKeyModifyDate;
UIKIT_EXTERN NSString * const BLUUserKeyAccessDate;
UIKIT_EXTERN NSString * const BLUUserKeyMobile;
UIKIT_EXTERN NSString * const BLUUserKeyPassword;
UIKIT_EXTERN NSString * const BLUUserKeyEmail;
UIKIT_EXTERN NSString * const BLUUserKeyNickname;
UIKIT_EXTERN NSString * const BLUUserKeyBirthday;
UIKIT_EXTERN NSString * const BLUUserKeyGender;
UIKIT_EXTERN NSString * const BLUUserKeySignature;
UIKIT_EXTERN NSString * const BLUUserKeyAvatar;
UIKIT_EXTERN NSString * const BLUUserKeyLocation;
UIKIT_EXTERN NSString * const BLUUserKeyMarriage;
UIKIT_EXTERN NSString * const BLUUserKeyFollowingCount;
UIKIT_EXTERN NSString * const BLUUserKeyFollowerCount;
UIKIT_EXTERN NSString * const BLUUserKeyFollowingCircleCount;
UIKIT_EXTERN NSString * const BLUUserKeyCollectionPostCount;
UIKIT_EXTERN NSString * const BLUUserKeyMac;
UIKIT_EXTERN NSString * const BLUUserKeyIP;
UIKIT_EXTERN NSString * const BLUUserKeyAccessTimes;
UIKIT_EXTERN NSString * const BLUUserKeyLoginTimes;

UIKIT_EXTERN NSInteger BLUUserLevelMinimum;


@interface BLUUser : BLUObject

@property (nonatomic, assign, readonly) NSInteger userID;

@property (nonatomic,strong) NSURL* WechatHeadimgURL;
@property (nonatomic, copy, readonly) NSString *mobile;
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, copy, readonly) NSDate *birthday;
@property (nonatomic, assign, readonly) BLUUserGender gender;
@property (nonatomic, copy, readonly) NSString *signature;
@property (nonatomic, copy, readonly) BLUImageRes *avatar;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, assign, readonly) BLUUserMarriage marriage;
@property (nonatomic, assign, readonly) NSInteger level;

@property (nonatomic, assign, readonly) NSInteger notifyCount;

@property (nonatomic, copy, readonly) NSString * openID;
@property (nonatomic, copy, readonly) NSString * unionID;
@property (nonatomic, assign, readonly) BLUOpenPlatformTypes openPlatformType;
@property (nonatomic, copy, readonly) NSString *accessToken;

@property (nonatomic, assign, readonly) NSInteger followingCount;
@property (nonatomic, assign, readonly) NSInteger followerCount;

@property (nonatomic, assign, readonly) NSInteger coin;
@property (nonatomic, assign, readonly) NSInteger experience;
@property (nonatomic, assign, readonly) NSInteger isCheckIn;

@property (nonatomic, assign) BOOL didFollow;


@end

@interface BLUUser (SNS)

- (instancetype)initWithSnsInfo:(NSDictionary *)info platformType:(BLUOpenPlatformTypes)type;

@end

@interface BLUUser (Desc)

- (NSString *)marriageDesc;
- (NSString *)birthdayDesc;
- (NSString *)genderDesc;
- (NSString *)signatureDesc;
- (NSString *)levelDesc;

+ (NSString *)descForMarriage:(BLUUserMarriage)marriage;
+ (NSString *)descForBirtyday:(NSDate *)birthday;
+ (NSString *)descForGender:(BLUUserGender)gender;
+ (NSString *)descForSignature:(NSString *)signature;

@end

@interface BLUUser (Info)

+ (NSDictionary *)userInfoWithUser:(BLUUser *)user;
+ (NSDictionary *)userInfoWithUSerID:(NSInteger)userID;

@end

@interface BLUUser (Validation)

+ (RACSignal *)validateMobile:(RACSignal *)mobileSignal;
+ (RACSignal *)validateEmail:(RACSignal *)emailSignal;
+ (RACSignal *)validateNickname:(RACSignal *)nicknameSignal;
+ (RACSignal *)validatePassword:(RACSignal *)passwordSignal;
+ (RACSignal *)validateSignature:(RACSignal *)signatureSignal;
- (BOOL)hasMobile;

@end

@interface BLUUser (Default)

@property (nonatomic, assign, readonly) BOOL isDefaultUser;

+ (BLUUser *)defaultUser;
+ (NSString *)defaultSignature;
+ (NSString *)defaultGenderDesc;
+ (NSString *)defaultBirthdayDesc;
+ (NSString *)defaultMarriageDesc;

@end

@interface NSString (BLUUser)

- (NSString *)standardMobile;
- (BOOL)isMobile;
- (BOOL)isEmail;
- (BOOL)isNickname;
- (BOOL)isPassword;
- (BOOL)isSignature;
- (BOOL)isIDCard;
@end

@interface NSDate (BLUUser)

- (NSInteger)age;
- (NSString *)constellation;
- (NSString *)ageAndConstellation;

@end

@interface BLUUser (Anonymous)

+ (NSString *)anonymousNickname;

@end

@interface BLUUser (Test)

+ (instancetype)testUser;

@end
