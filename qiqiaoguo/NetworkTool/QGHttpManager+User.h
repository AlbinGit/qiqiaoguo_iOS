//
//  QGHttpManager+User.h
//  qiqiaoguo
//
//  Created by cws on 16/6/23.
//
//

#import "QGHttpManager.h"
#import "BLUUser.h"

typedef enum : NSUInteger {
    Codetyperegister = 1,
    Codetypepassword,
    Codetypebinding,
} Codetype;

typedef NS_ENUM(NSUInteger, UserPostType) {
    UserPostTypePublished, // 发表
    UserPostTypeParticipated,// 参与
    UserPostTypeCollection,// 收藏
};

typedef NS_ENUM(NSUInteger, UserCollectionType) {
    UserCollectionTypeGoods =  1,
    UserCollectionTypeActiv = 13,
    UserCollectionTypeOrg = 18,
    UserCollectionTypeTeacher,
    UserCollectionTypeCourse,
    UserCollectionTypeStore = 50,
};


@interface QGHttpManager (User)

/**更新推送id*/
+ (void)updateDeviceToken:(NSString *)token Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**普通登录*/
+ (void)loginWithMobile:(NSString *)mobile Password:(NSString *)password Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**第三方登录*/
+ (void)thirdLoginWithUser:(BLUUser *)user Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取验证码*/
+ (void)getValidationCodeWithMobile:(NSString *)mobile AndType:(Codetype)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**验证验证码*/
+ (void)checkValidationCodeWithMobile:(NSString *)mobile AndCode:(NSString *)code Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**注册用户*/
+ (void)registerWithMobile:(NSString *)mobile Code:(NSString *)code Nickname:(NSString *)nickname Password:(NSString *)password Headimage:(UIImage *)image Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**重置密码*/
+ (void)resetPasswordWithMobile:(NSString *)mobile Code:(NSString *)code NewPassword:(NSString *)password Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**用户注销*/
+ (void)UserLogoutSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**修改用户昵称*/
+ (void)UserUpdateNicknameWithNewNickname:(NSString *)nickname Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**更新用户头像*/
+ (void)UserUpdateHeadImageWithNewImage:(UIImage *)image Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取用户详情*/
+ (void)getUserDetaileWithUserID:(NSInteger)uid Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**用户签到*/
+ (void)UserCheckInSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**用户绑定手机*/
+ (void)UserBoundMobile:(NSString *)mobile Code:(NSString *)code password:(NSString *)password Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取用户发表的帖子*/
+ (void)getUserPostsWithType:(UserPostType)type page:(NSInteger)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取用户收藏的商品*/
+ (void)getUserCollectionGoodsWithPage:(NSInteger)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**获取用户消息数*/
+ (void)getUserMessageConutSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**删除帖子*/
+ (void)delegateUserPostWithPostID:(NSInteger)postID Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

/**
 *  用户关注或取消的方法
 *
 *  @param type      关注类型
 *  @param objectID  关注的id
 *  @param isCollect yes为关注,no为取消关注
 */
+ (void)CollectionWithCollectType:(UserCollectionType)type objectID:(NSInteger)objectID isCollection:(BOOL)isCollect Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;


@end


