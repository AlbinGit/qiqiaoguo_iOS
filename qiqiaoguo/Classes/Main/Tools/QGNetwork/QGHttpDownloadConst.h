//
//  QGHttpDownloadConst.h
//  qiqiaoguo
//
//  Created by cws on 16/8/10.
//
//

#import <Foundation/Foundation.h>



@interface QGHttpDownloadConst : NSObject


extern NSString *const BLUBaseURLString;

extern NSString *const QGBaseURLString;
extern NSString *const QGStoreCityURLString;
extern NSString *const QGStoreCityMainPagePath;//QGSingleStoreList
extern NSString *const QGSingleStoreList;//QGSingleStoreDetailList
extern NSString *const QGSingleStoreDetailList;//QGSkillStoreDetailList
extern NSString *const QGSkillStoreDetailList;//QGShopDetailsDetailList
extern NSString *const QGShopDetailsDetailList;//QGSingleshopStoreList
extern NSString *const QGSingleshopStoreList;
extern NSString *const QGStoreCityComboPath;
extern NSString *const QGSaveCartInfoPath;
extern NSString *const QGCommitOrderPath;
extern NSString *const QGGetSeckillGoodsList;
extern NSString *const QGGetSeckillGoodsInfoPath;
extern NSString *const QGCheckSeckillingBuyCountPath;
extern NSString *const QGGetUsefulCouponPath;
extern NSString *const  QGGetStoreDetailPath;
extern NSString *const QGGetSkillInfoPath;//QGGetCityPath
extern NSString *const QGGetSkillInfoPathV2;//QGGetCityPath
extern NSString *const QGGetCityPath;//QGGetLocationCityPath
extern NSString *const QGGetLocationCityPath;
extern NSString *const QGSaveGoodsPromotionInfo;
extern NSString *const QGGetShopCityListPath;
extern NSString *const QGGetSelfDeliveryAddressListBySidPath;
extern NSString *const QGTelRegister;
extern NSString *const QGrRsetPassword;//QGGetNewCaptchaPath
extern NSString *const QGGetNewCaptchaPath;
extern NSString *const QGLogin;
extern NSString *const QGThirdLogin;
extern NSString *const  QGFindPassword;//QGCheckCaptcha
extern NSString *const  QGCheckCaptcha;
extern NSString *const  QGGetUserInfo;
extern NSString *const  QGFeedback;
extern NSString *const  QGUpdateUserName;


extern NSString *const  QGlogout;
extern NSString *const  QGUpdateUserhead;
extern NSString *const  QGGetGoodsCategory;
extern NSString *const  QGMallGoodsCategory;
extern NSString *const  QGGetGoodsListByCategoryId;//QGGetMallListByCategoryId
extern NSString *const  QGGetMallListByCategoryId;
extern NSString *const  QGGetProvince;
extern NSString *const  QGWechatBindUser;
extern NSString *const  QGGetCheckInInfoByMonthPath;
extern NSString *const  QGUserCheckInPath;
extern NSString *const  QGGetOrderDetailV2Path;
extern NSString *const  QGGetOrderPacketNumPath;
extern NSString *const  QGGetGuanZhuStoreListPath;
extern NSString *const  QGWeiXinPayPath;
extern NSString *const  QGPaypalPath;
extern NSString *const  QGBindCardMobile;
extern NSString *const QGGetSeacherGoodsPath;//搜索商品列表
extern NSString *const QGActivityHomeListPath;//活动列表//QGActivityOrderDetailsPath
extern NSString *const QGActivityOrderDetailsPath;//活动订单//
extern NSString *const QGEduSignOrderDetailsPath;//教育订单

extern NSString *const QGActHomePath;//活动
extern NSString *const QGActivetyDetailPath;//详情
extern NSString *const QGUserActivityListPath;// 用户参与的活动列表
extern NSString *const QGCollectionActivListPath;
// 教育频道
extern NSString *const QGGetChannelIndexPath; // 教育频道首页
extern NSString *const QGCourseDetailPath;//课程详情
extern NSString *const QGGetTeacherIndexPath; // 教师频道首页
extern NSString *const QGGetCourseListByTeacherIdPath; // 教师课程列表
extern NSString *const QGGetSeacherCoursePath; // 搜索课程
extern NSString *const QGGetSeacherOrgPath; // 搜索机构
extern NSString *const QGGetSeacherTeacherPath; // 搜索教师
//机构
extern NSString *const QGQrgPath;//机构主页接口
extern NSString *const QGOrgCommentPath;//机构评论分页列表
extern NSString *const QGOrgCoursePath;//机构课程推荐分页列表
extern NSString *const QGOrgTeacherPath;//机构教师推荐分页列表
extern NSString *const QGCancelCollectPath;//取消机构、教师、课程收藏
extern NSString *const QGOrgSubbranchPath;//机构连锁分店



@end
