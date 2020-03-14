//
//  BLUUserInfo.m
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUUser.h"
#import "WeiboUser.h"

NSInteger BLUUserSignatureMaxLength = 30;
NSInteger BLUUserNicknameMaxLength = 16;
NSInteger BLUUserLevelMinimum = 1;

NSString * const BLUUserKeyUserID                   = @"userID";
NSString * const BLUUserKeyUser                     = @"user";
NSString * const BLUUserKeyCreateDate               = @"createDate";
NSString * const BLUUserKeyModifyDate               = @"modifyDate";
NSString * const BLUUserKeyAccessDate               = @"accessDate";
NSString * const BLUUserKeyMobile                   = @"mobile";
NSString * const BLUUserKeyPassword                 = @"password";
NSString * const BLUUserKeyEmail                    = @"email";
NSString * const BLUUserKeyNickname                 = @"nickname";
NSString * const BLUUserKeyBirthday                 = @"birthday";
NSString * const BLUUserKeyGender                   = @"gender";
NSString * const BLUUserKeySignature                = @"signature";
NSString * const BLUUserKeyAvatar                   = @"avatar";
NSString * const BLUUserKeyLocation                 = @"location";
NSString * const BLUUserKeyMarriage                 = @"marriage";
NSString * const BLUUserKeyFollowingCount           = @"followingCount";
NSString * const BLUUserKeyFollowerCount            = @"followerCount";
NSString * const BLUUserKeyFollowingCircleCount     = @"followingCircleCount";
NSString * const BLUUserKeyCollectionPostCount      = @"collectionPostCount";
NSString * const BLUUserKeyMac                      = @"mac";
NSString * const BLUUserKeyIP                       = @"ip";
NSString * const BLUUserKeyAccessTimes              = @"accessTimes";
NSString * const BLUUserKeyLoginTimes               = @"loginTimes";

@implementation BLUUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userID": @"user_id",
             @"mobile": @"mobile",
             @"birthday": @"birthday",
             @"gender": @"gender",
             @"nickname": @"nickname",
             
             @"signature": @"signature",
             @"avatar": @"avatar",
             @"location": @"location",
             @"marriage": @"marriage",

             @"followingCount": @"following_count",
             @"followerCount": @"follower_count",
             @"level": @"rank",

             @"didFollow": @"is_follow_status",

             @"coin": @"coin",
             @"experience": @"experience",
             
             @"notifyCount":@"notifyCount",
             @"isCheckIn" : @"is_checkIn_status",
             

#ifdef BLUUserPropertyUnavailable
             @"createDate": @"create_date",
             @"modifyDate": @"modify_date",
             @"accessDate": @"access_date",
             
             @"password": @"password",
             @"email": @"email",
             
             @"mac": @"mac",
             @"ip": @"ip",
             @"accessTimes": @"access_times",
             @"loginTimes": @"login_times",
             
             @"followingCircleCount": @"following_circle_count",
             @"collectionPostCount": @"collect_post_count",

#endif
    };
}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"nil value detect for key=%@", key);
    
    if ([key isEqualToString:@"level"]) {
        
        [self setValue:@1 forKey:@"level"];
        
    }else {
        
        [super setNilValueForKey:key];
        
    }
    

}
+ (NSValueTransformer *)modifyDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)accessDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedModelDateFormater] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)birthdayJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedBirthdayDateFormater] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSDateFormatter sharedBirthdayDateFormater] stringFromDate:date];
    }];
}



//+ (NSValueTransformer *)notifyCountJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//+ (NSValueTransformer *)levelJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}
//
//
//
//+ (NSValueTransformer *)genderJSONTransformer{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
//        return [number stringValue];
//    }];
//}

+ (NSValueTransformer *)avatarJSONTransformer {
    return [self imageResJSONTransformer];
}

@end

@implementation BLUUser (Info)

+ (NSDictionary *)userInfoWithUser:(BLUUser *)user {
    NSParameterAssert(user);
    return @{BLUUserKeyUser: user};
}

+ (NSDictionary *)userInfoWithUSerID:(NSInteger)userID {
    NSParameterAssert(userID > 0);
    return @{BLUUserKeyUserID: @(userID)};
}

@end

@implementation BLUUser (SNS)

- (instancetype)initWithSnsInfo:(NSDictionary *)info platformType:(BLUOpenPlatformTypes)type {
    if (self = [super init]) {
        switch (type) {
            case BLUOpenPlatformTypeWechat: {
                [self configWithWechatInfo:info];
            } break;
            case BLUOpenPlatformTypeQQ: {
                [self configWithQQInfo:info];
            } break;
            case BLUOpenPlatformTypeSina: {
                [self configWithSinaInfo:info];
            } break;
        }
    }
    return self;
}

- (void)configWithWechatInfo:(NSDictionary *)info {

    if (info) {
        _nickname = info[@"thirdPlatformUserProfile"][@"nickname"];
        NSURL *avatarURL = [NSURL URLWithString:info[@"thirdPlatformUserProfile"][@"headimgurl"]];
        _avatar = [[BLUImageRes alloc] initWithThumbnailURL:avatarURL originURL:avatarURL];
        _openID = info[@"thirdPlatformUserProfile"][@"openid"];
        _openPlatformType = BLUOpenPlatformTypeWechat;
        _accessToken = info[@"data"][@"wxsession"][@"accessToken"];
        _unionID = info[@"thirdPlatformUserProfile"][@"unionid"];
        NSInteger gender = ((NSNumber *)info[@"thirdPlatformUserProfile"][@"sex"]).integerValue;
        switch (gender) {
            case 1: {
                _gender = BLUUserGenderMale;
            } break;
            case 2: {
                _gender = BLUUserGenderFemale;
            } break;
            default: {
                _gender = BLUUserGenderMale;
            } break;
        }
    }
}

- (void)configWithSinaInfo:(NSDictionary *)info {
    static NSString * const kSinaNicknameKey = @"username";
    static NSString * const kSinaAvatarURLKey = @"profile_image_url";
    static NSString * const kSinaOpenIDKey = @"usid";
    static NSString * const kSinaGenderKey = @"gender";
    static NSString * const kSinaAccessTokenKey = @"accessToken";
    
    if (info) {
        NSDictionary *dic = info[@"data"][@"sina"];
        WeiboUser *userProfile = info[@"thirdPlatformUserProfile"];
        _nickname = dic[kSinaNicknameKey];
        NSURL *avatarURL = [NSURL URLWithString:userProfile.profileImageUrl];
        _avatar = [[BLUImageRes alloc] initWithThumbnailURL:avatarURL originURL:avatarURL];
        _openID = dic[kSinaOpenIDKey];
        _openPlatformType = BLUOpenPlatformTypeSina;
        _accessToken = dic[kSinaAccessTokenKey];
        NSInteger gender = [userProfile.gender isEqualToString:@"m"] ? YES : NO;
        if (gender == 1) {
            _gender = BLUUserGenderMale;
        } else {
            _gender = BLUUserGenderFemale;
        }
    }
}

- (void)configWithQQInfo:(NSDictionary *)info {
    
    if (info) {
        _nickname = info[@"thirdPlatformUserProfile"][@"nickname"];
        NSURL *avatarURL = [NSURL URLWithString:info[@"thirdPlatformUserProfile"][@"figureurl_qq_2"]];
        _avatar = [[BLUImageRes alloc] initWithThumbnailURL:avatarURL originURL:avatarURL];
        _openID = info[@"data"][@"qq"][@"usid"];
        _openPlatformType = BLUOpenPlatformTypeWechat;
        _accessToken = info[@"data"][@"qq"][@"accessToken"];
        NSString *gender = info[@"thirdPlatformUserProfile"][@"gender"];
        if ([gender isEqualToString:@"男"] || !gender) {
            _gender = BLUUserGenderMale;
        }else
        {
            _gender = BLUUserGenderFemale;
        }
    }
}

@end

@implementation BLUUser (Default)

+ (BLUUser *)defaultUser {
    NSDictionary *defaultUserDict = @{
      BLUUserKeyUserID: @(0),
      BLUUserKeyNickname: NSLocalizedString(@"user.not-logged-in", @"Not logged in"),
      BLUUserKeyGender: @(BLUUserGenderMale),
      BLUUserKeySignature: NSLocalizedString(@"user.empty-signature-prompt", @"Empty sigature prompt"),
    };
    BLUUser *user = [[BLUUser alloc] initWithDictionary:defaultUserDict error:nil];
    return user;
}

- (BOOL)isDefaultUser {
    return self.userID <= 0;
}

+ (NSString *)defaultSignature {
    return NSLocalizedString(@"user.default-signature", @"Default signature");
}

+ (NSString *)defaultGenderDesc {
    return NSLocalizedString(@"user.default-gender", @"Unknown");
}

+ (NSString *)defaultBirthdayDesc {
    return NSLocalizedString(@"user.default-birthday", @"Unknown");
}

+ (NSString *)defaultMarriageDesc {
    return NSLocalizedString(@"user.default-marriage", @"Unknown");
}

@end

@implementation BLUUser (Desc)

- (NSString *)marriageDesc {
    return [BLUUser descForMarriage:self.marriage];
}

- (NSString *)birthdayDesc {
    return [BLUUser descForBirtyday:self.birthday];
}

- (NSString *)genderDesc {
    return [BLUUser descForGender:self.gender];
}

- (NSString *)signatureDesc {
    return [BLUUser descForSignature:self.signature];
}

- (NSString *)levelDesc {
    return [NSString stringWithFormat:@"LV%@", @(self.level)];
}

+ (NSString *)descForMarriage:(BLUUserMarriage)marriage {
    NSString *desc = nil;
    switch (marriage) {
        case BLUUserMarriageInLove: {
            desc = NSLocalizedString(@"user.marriage.in-love", @"In love");
        } break;
        case BLUUserMarriageSingle: {
            desc = NSLocalizedString(@"user.marriage.single", @"Signal");
        } break;
        case BLUUserMarriageMarried: {
            desc = NSLocalizedString(@"user.marriage.married", @"Married");
        } break;
        case BLUUserMarriageSecrecy: {
            desc = NSLocalizedString(@"user.marriage.secrecy", @"Secrecy");
        } break;
        case BLUUserMarriageDivorced: {
            desc = NSLocalizedString(@"user.marriage.divorced", @"Divorced");
        } break;
        default: {
            desc = [BLUUser defaultMarriageDesc];
        } break;
    }
    return desc;
}

+ (NSString *)descForGender:(BLUUserGender)gender {
    NSString *desc = nil;
    switch (gender) {
        case BLUUserGenderMale: {
            desc = NSLocalizedString(@"user.gender.male", @"Male");
        } break;
        case BLUUserGenderFemale: {
            desc = NSLocalizedString(@"user.gender.female", @"Female");
        } break;
        default: {
            desc = [BLUUser defaultGenderDesc];
        } break;
    }
    return desc;
}

+ (NSString *)descForBirtyday:(NSDate *)birthday {
    NSString *desc = nil;
    if (birthday) {
        desc = [birthday ageAndConstellation];
    } else {
        desc = [BLUUser defaultBirthdayDesc];
    }
    return desc;
}

+ (NSString *)descForSignature:(NSString *)signature {
    NSString *desc = nil;
    if (signature.length != 0) {
        desc = signature;
    } else {
        desc = [BLUUser defaultSignature];
    }
    return desc;
}

@end

@implementation BLUUser (Validation)

+ (RACSignal *)validateMobile:(RACSignal *)mobileSignal {
    return [mobileSignal map:^id(NSString *mobile) {
        BOOL ret = NO;
        if ([mobile isKindOfClass:[NSString class]]) {
            ret = [mobile isMobile];
        }
        return @(ret);
    }];
}

+ (RACSignal *)validateNickname:(RACSignal *)nicknameSignal {
    return [nicknameSignal map:^id(NSString *nickname) {
        BOOL ret = NO;
        if ([nickname isKindOfClass:[NSString class]]) {
            ret = [nickname isNickname];
        }
        return @(ret);
    }];
}

+ (RACSignal *)validatePassword:(RACSignal *)passwordSignal {
    return [passwordSignal map:^id(NSString *password) {
        BOOL ret = NO;
        if ([password isKindOfClass:[NSString class]]) {
            ret = [password isPassword];
        }
        return @(ret);
    }];
}

+ (RACSignal *)validateEmail:(RACSignal *)emailSignal {
    return [emailSignal map:^id(NSString *email) {
        BOOL ret = NO;
        if ([email isKindOfClass:[NSString class]]) {
            ret = [email isEmail];
        }
        return @(ret);
    }];
}

+ (RACSignal *)validateSignature:(RACSignal *)signatureSignal {
    return [signatureSignal map:^id(NSString *signature) {
        BOOL ret = NO;
        if ([signatureSignal isKindOfClass:[NSString class]]) {
            ret = [signature isSignature];
        }
        return @(ret);
    }];
}

- (BOOL)hasMobile {
    return [self.mobile isMobile];
}

@end

@implementation NSString (BLUUser)

- (NSString *)standardMobile {
    NSMutableString *standard = [NSMutableString stringWithString:self];
    NSRange prefixRange = [standard rangeOfString:@"+86"];
    if (prefixRange.location!=NSNotFound) {
        
        [standard deleteCharactersInRange:prefixRange];
    }
    NSCharacterSet *symbolSet = [NSCharacterSet characterSetWithCharactersInString:@"- ()"];
    NSRange symbolRange = [standard rangeOfCharacterFromSet:symbolSet];
    while (symbolRange.location!=NSNotFound) {
        
        [standard deleteCharactersInRange:symbolRange];
        symbolRange = [standard rangeOfCharacterFromSet:symbolSet];
    }
    return standard;
}

- (BOOL)isMobile {
    BOOL result = NO;
    NSError *error = nil;
    NSString *mobileRegex = @"^[1][2-8]\\d{9}$";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:mobileRegex options:0 error:&error];
    NSRange mobileMatchRange = [regularExpression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if ((mobileMatchRange.location!=NSNotFound)&&(mobileMatchRange.length==[self length])) {
        
        result = YES;
    }
    
    return result;
}

- (BOOL)isEmail {
    BOOL result = NO;
    NSError *error = nil;
    NSString *emailRegex = @"^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:emailRegex options:0 error:&error];
    NSRange emailMatchRange = [regularExpression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if ((emailMatchRange.location!=NSNotFound)&&(emailMatchRange.length==[self length])) {
        result = YES;
    }
    return result;
}

- (BOOL)isNickname {
    BOOL result = NO;
    NSError *error = nil;
    NSString *nicknameRegex = [NSString stringWithFormat:@"^[a-zA-Z\\d\\_\\u2E80-\\u9FFF]{1,%@}$", @(BLUUserNicknameMaxLength)];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:nicknameRegex options:0 error:&error];
    NSRange nicknameMatchRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if ((nicknameMatchRange.location != NSNotFound) && (nicknameMatchRange.length == self.length)) result = YES;
    return result;
}

- (BOOL)isPassword {
    return (self.length >= 6 && self.length <= 16);
}

- (BOOL)isSignature {
    return (self.length <= BLUUserSignatureMaxLength);
}

- (BOOL)isIDCard{
    BOOL flag;
    if (self.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:self];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(self.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod = idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}

@end

@implementation NSDate (BLUUser)

- (NSInteger)age {
    NSDateComponents *curComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return [curComponents year] - [components year];
}

- (NSString *)constellation {
    
    NSInteger days[12] = {20, 19, 21, 20, 21, 22, 23, 23, 23, 24, 23, 22};
    NSArray *constellations = @[
                                NSLocalizedString(@"date-addition.capricorn", @"Capricorn"),
                                NSLocalizedString(@"date-addition.aquarius", @"Aquarius"),
                                NSLocalizedString(@"date-addition.pisces", @"Pisces"),
                                NSLocalizedString(@"date-addition.aries", @"Aries"),
                                NSLocalizedString(@"date-addition.taurus", @"Taurus"),
                                NSLocalizedString(@"date-addition.gemini", @"Gemini"),
                                NSLocalizedString(@"date-addition.cancer", @"Cancer"),
                                NSLocalizedString(@"date-addition.leo", @"Leo"),
                                NSLocalizedString(@"date-addition.virgo", @"Virgo"),
                                NSLocalizedString(@"date-addition.libra", @"Libra"),
                                NSLocalizedString(@"date-addition.scorpio", @"Scorpio"),
                                NSLocalizedString(@"date-addition.sagittarius", @"Sagittarius"),
                                NSLocalizedString(@"date-addition.capricorn", @"Capricorn"),
                                ];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    
    return day < days[month - 1] ? constellations[month - 1] : constellations[month];
}

- (NSString *)ageDesc {
    return [NSString stringWithFormat:NSLocalizedString(@"user.birtyday.age-%@", @"age"), @(self.age)];
}

- (NSString *)ageAndConstellation {
    return [NSString stringWithFormat:@"%@ %@", self.ageDesc, self.constellation];
}

@end

@implementation BLUUser (Anonymous)

+ (NSString *)anonymousNickname {
    return NSLocalizedString(@"user.anonymous.nickname", @"Anonymous");
}

@end

@implementation BLUUser (Test)

+ (instancetype)testUser {
    NSDictionary *testUserDict = @{
        BLUUserKeyUserID: @(0),
        BLUUserKeyNickname: [NSString randomLorumIpsumWithLength:arc4random() % 15],
        BLUUserKeyGender: @(arc4random() & 2),
        BLUUserKeySignature: [NSString randomLorumIpsumWithLength:arc4random() % 40],
    };
    BLUUser *user = [[BLUUser alloc] initWithDictionary:testUserDict error:nil];
    return user;
}



@end
