//
//  QGHttpDownloadConst.m
//  qiqiaoguo
//
//  Created by cws on 16/8/10.
//
//


#define QGStoreCityURLString QQG_BASE_APIURLString@"/Phone"//七巧国商城地址

#define QGStoreEduURLString QQG_BASE_APIURLString@"/Phone"//七巧国教育地址
#import "QGHttpDownloadConst.h"

@implementation QGHttpDownloadConst

NSString *const QGTelRegister = QGStoreCityURLString@"/User/telRegister";//用户通过手机注册
NSString *const QGGetNewCaptcha = QGStoreCityURLString@"/getNewCaptcha";//发送注册验证码
NSString *const QGCheckCaptcha =QGStoreCityURLString @"/Captcha/checkCaptcha";//验证验证码
NSString *const QGrRsetPassword = QGStoreCityURLString@"/User/resetPassword";// 修改密码
NSString *const QGLogin = QGStoreCityURLString@"/User/Login";//登录
NSString *const QGThirdLogin = QGStoreCityURLString@"/User/partnerLogin";//第三方登录
NSString *const  QGFindPassword  = QGStoreCityURLString@"/findPassword";//找回密码
NSString *const  QGGetUserInfo = QGStoreCityURLString@"/User/getUserDetails";//获取用户信息
NSString *const  QGUpdateUserName = QGStoreCityURLString@"/User/updateUserName";//修改昵称
NSString *const  QGlogout = QGStoreCityURLString@"/User/Logout";//注销
NSString *const  QGUpdateUserhead = QGStoreCityURLString@"/User/updateUserhead";//用户头像更新
NSString *const  QGWeiXinPayPath=QGStoreCityURLString@"/Order/getWXpayConfig";//微信支付
NSString *const  QGPaypalPath=QGStoreCityURLString@"/Order/getAlipayConfig";//支付宝支付
NSString *const  QGGetNewCaptchaPath=QGStoreCityURLString@"/Captcha/getNewCaptcha";//发送注册验证码_8
//活动
NSString *const QGActHomePath = QGStoreEduURLString@"/Activity/getActivityBanner";//活动首页
NSString *const QGActivityHomeListPath = QGStoreEduURLString@"/Activity/getActivityList";//活动列表
NSString *const QGActivityOrderDetailsPath = QGStoreEduURLString@"/Activity/applyOrder";//活动订单

NSString *const QGUserActivityListPath = QGStoreEduURLString@"/User/getParticipatedActivityList";//用户参与的活动列表
NSString *const QGCollectionActivListPath = QGStoreEduURLString@"/User/getFollowingActivityList";//用户收藏的活动列表
NSString *const QGActivetyDetailPath = QGStoreEduURLString@"/Activity/getActivityDetails";//详情

//商品
NSString *const QGStoreCityMainPagePath=QGStoreCityURLString@"/Mall/getMallIndex";//商城首页
NSString *const QGGetSeckillGoodsList=QGStoreCityURLString@"/Mall/getSeckillingGoodsListV2";//秒杀
NSString *const QGSingleStoreList= QGStoreCityURLString@"/Mall/getGoodsList";//商品列表
NSString *const QGSingleshopStoreList= QGStoreCityURLString@"/Mall/getShopGoodsList";//单个商品列表
NSString *const QGSingleStoreDetailList= QGStoreCityURLString@"/Mall/getGoodsDetails";//单店商品详情
NSString *const QGShopDetailsDetailList= QGStoreCityURLString@"/Mall/getShopDetails";//商品详情
NSString *const QGSkillStoreDetailList= QGStoreCityURLString@"/Mall/getSeckillingGoodsDetailsV2";//秒杀商品详情
NSString *const  QGMallGoodsCategory = QGStoreEduURLString@"/Mall/getGoodsCategory";//获取商城分类列表
NSString *const  QGGetMallListByCategoryId = QGStoreEduURLString@"/Mall/getSubCategoryAndBrandByReId";//商品二级分类&品牌
NSString *const QGGetSeckillGoodsInfoPath=QGStoreCityURLString@"/getSeckillingGoodsinfo";
NSString *const QGCheckSeckillingBuyCountPath=QGStoreCityURLString@"/checkSeckillingBuyCount";
NSString *const QGGetGoodsForSeckillingPath=QGStoreCityURLString@"/getGoodsForSeckilling";
NSString *const QGGetSkillInfoPath=QGStoreCityURLString@"/Home/getIndex";//首页请求
NSString *const QGGetSkillInfoPathV2=QGStoreCityURLString@"/Home/getIndexV2";//首页请求v2
NSString *const QGGetCityPath=QGStoreCityURLString@"/Home/getCityList";//首页城市定位
NSString *const QGGetLocationCityPath = QGStoreCityURLString@"/Home/getLocationCity";//首页城市定位
NSString *const QGGetSeacherGoodsPath = QGStoreEduURLString @"/Mall/getGoodsList";
// 教育
NSString *const QGGetChannelIndexPath = QGStoreEduURLString@"/Edu/getEduIndex"; // 教育频道首页
NSString *const QGCourseDetailPath = QGStoreEduURLString@"/Edu/getCourseDetails";//127.课程详情
NSString *const QGGetTeacherIndexPath = QGStoreEduURLString@"/Edu/getTeacherDetails"; // 教师频道首页
NSString *const QGGetCourseListByTeacherIdPath = QGStoreCityURLString@"/getCourseList"; // 教师课程列表
NSString *const  QGGetGoodsListByCategoryId = QGStoreEduURLString@"/Edu/getSubCategoryByReId";//获取分类下的子分类及教育列表
NSString *const QGGetSeacherCoursePath = QGStoreEduURLString@"/Edu/getCourseList"; // 搜索课程
NSString *const QGGetSeacherOrgPath = QGStoreEduURLString@"/Edu/getOrgList"; // 搜索机构
NSString *const QGGetSeacherTeacherPath = QGStoreEduURLString @"/Edu/getTeacherList"; // 搜索教师
NSString *const  QGGetGoodsCategory = QGStoreEduURLString@"/Edu/getEduCategory";//获取教育分类列表
NSString *const QGGetEduOrderDetailPath=QGStoreCityURLString@"/getEduOrderDetail";
NSString *const QGEduSignOrderDetailsPath = QGStoreEduURLString@"/Edu/placeOrder";//教育订单


//机构
NSString *const QGQrgPath = QGStoreEduURLString@"/Edu/getOrgDetails";//机构主页接口
NSString *const QGOrgCoursePath = QGStoreCityURLString@"/getCourseListByOrgId";//机构课程推荐分页列表
NSString *const QGOrgTeacherPath = QGStoreEduURLString@"/Edu/getTeacherList";//机构教师




@end
