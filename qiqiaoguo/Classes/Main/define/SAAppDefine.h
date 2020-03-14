//
//  SAAppDefine.h
//  SaleAssistant
//
//  Created by Albin on 14-10-15.
//  Copyright (c) 2014年 platomix. All rights reserved.
//


//定义一个枚举类型，判断用户修改的是那个信息
typedef enum {
    EditUserTypeIcon=0,        //头像
    EditUserTypeNike,             /// 昵称
    EditUserTypeSingel,               /// 个性签名
    EditUserTypeName,      //姓名
    EditUserTypePhone,    /// 手机
    EditUserTypeEmail,    /// 邮箱
    EditUserTypeQQ,    /// QQ
    EditUserTypeWeixin,    /// 微信
} EditUserType;


/*
 1=单选(是/否)
 2=文本框
 3=文本区域
 4=多媒体
 5=日期
 6=图片
 7=数量加减框
 8=视频
 9=单选
 10=多选
 11=金额（输入数字）
 12=拍照+本地图片浏览
 
 市场调研专用类型
 13=调研文本类型
 14=调研单选框

 */
typedef NS_ENUM(NSInteger, SAListType)
{
    SAWhetherType = 1,
    SATextFieldType,
    SATextViewType,
    SAMediaType,
    SADateType,
    
    SAImageType,
    SACountType,
    SAVideoType,
    SASingleSelectType,
    SAMultipleSelectType,
    SATextFieldIntType,
    SACameraImageType,
    
    // 市场调研用类型
    SAMarketSurveyTextFieldType,
    SAMarketSurveySingleSelectType
};

typedef void(^CameraClickBlock)(NSIndexPath *indexPath);
typedef void(^VoiceClickBlock)(NSIndexPath *indexPath);
typedef void(^CameraStorageClickBlock)(NSIndexPath *indexPath);


//#define kCorporateAccount 1 // 企业账号(非上传到appStore)

// 主背景色
#define APPBackgroundColor [UIColor colorFromHexString:@"f5f5f5"]
#define QGlineBackgroundColor [UIColor colorFromHexString:@"c1c1c1"]
#define QGBottomBackgroundColor COLOR(242, 243, 244, 1)
// 辅助背景色
#define APPOtherColor [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]

#define User_version  1
// 三方相关key
#if User_version
// 微信
#define kWXAppId @"wx4663f0a434546015"
// 百度地图用户版
#define kBMKMapKey @"0KZd7VfcbQp6TnxTfArdtsWZ"

// 友盟测试key
//#define kUMSocialKey @"5639a463e0f55a6cfc0016fa"
// 友盟正式KEY
#define kUMSocialKey @"5729a4bc67e58eed120007fa"

#endif
// 字号
#define KAPPTextFont 13.0f

// 圆角
#define kCornerRadius 5.0f
// 按钮文字颜色
#define kButtonTitleColor [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1]
#define kGreenColor [UIColor colorWithRed:48/255.0f green:192/255.0f blue:178/255.0f alpha:1]
//button背景颜色
#define K_ButtonBackColor_DarkGreen PL_UTILS_COLORRGB(0, 192, 87)
#define K_ButtonBackColor_LightGreen PL_UTILS_COLORRGB(47, 192, 177)
#define K_ButtonBackColor_Red PL_UTILS_COLORRGB(249, 29, 54)
#define K_ButtonBackColor_Orange PL_UTILS_COLORRGB(254, 130, 51)

// 获取商家名字g
#define GET_SELLERID [[SAUserManager sharedInstance]readUserInfoFromFile].userSellerId
// 获取用户名
#define GET_USERID [[SAUserManager sharedInstance]readUserInfoFromFile].userId
// 获取登录时效
#define GET_USERSID [[SAUserManager sharedInstance]readUserInfoFromFile].userSid


// 巡店流程
#define KEY_FILEARRAY @"fileArray"// 图片录音数组
#define KEY_CONTENTARRAY @"contentArray"// 巡店所有流程内容

// 调研商品流程
#define KEY_SURVEYFILEARRAY @"surveyFileArray"// 图片录音数组
#define KEY_SURVEYCONTENTARRAY @"surveyContentArray"// 图片内容数组
#define KEY_SURVEYUPLOADJSON @"surveyUploadJson"// 上传拼接Json

// 产品属性和父属性
#define KEY_TAGARRAY @"tagArray"
#define KEY_TAGSUPERARRAY @"tagSuperArray"

// 底部视图高度
#define kBottomViewHeight 50.0f

// 产品属性界面header高度
#define kTagHeaderViewHight 30.0f

// tableViewCell Height
#define kVisitStoreTabelViewCellHeight 80.0f
#define kStoreListTableViewCellHeight 60.0f

//用户信息
#define kUserId @"9000013"
#define kCode @"1"

//请求method参数宏
#define kLan @"lan"
#define kHomePicList @"homePicList"
#define kList @"list"
#define kMyCategories @"myCategories"
#define kAllCategories @"allCategories"
#define kSubOrUnSubCategory @"subOrUnSubCategory"
#define kDetail @"detail"

// 创建图片集合视图layout(本项目用)
#define PL_FLOWLAYOUTIMAGE_CREATE(flowLayout) \
UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];\
flowLayout.itemSize = CGSizeMake(85, 85);\
flowLayout.minimumInteritemSpacing = 0;\
flowLayout.minimumLineSpacing = 10;\
flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

#define PL_ADDCORNER(varName) \
varName.layer.cornerRadius = kCornerRadius; \
varName.layer.borderWidth = 1.0f; \
varName.layer.borderColor = PL_UTILS_COLORRGB_CG(220, 220, 220); \
varName.layer.masksToBounds = YES; \

#define PL_ADDCORNER_10(varName) \
varName.layer.cornerRadius = 10; \
varName.layer.borderWidth = 1.0f; \
varName.layer.borderColor = PL_UTILS_COLORRGB_CG(220, 220, 220); \
varName.layer.masksToBounds = YES; \


#define PL_ADDCORNERGREEN(varName) \
varName.layer.cornerRadius = kCornerRadius; \
varName.layer.borderWidth = 1.0f; \
varName.layer.borderColor = PL_UTILS_COLORRGB_CG(47, 192, 177); \
varName.layer.masksToBounds = YES; \


#define PL_UIViewLine(varName,cellHeight) \
UIView *line=[[UIView alloc]initWithFrame:CGRectMake( 0,cellHeight-1,SCREEN_WIDTH, 1)];\
[line setBackgroundColor:PL_UTILS_COLORRGB(238, 238, 238)];\
[varName addSubview:line];
// lable color
#define GREEN PL_UTILS_COLORRGB(45, 187, 173)
#define GRAYDark UIColorFromRGB(0x666666)
#define GRAYLight PL_UTILS_COLORRGB(177, 177, 177)
#define GREENDark PL_UTILS_COLORRGB(119, 150, 168)
#define GREENLight UIColorFromRGB(0x05c8b8)
#define CUSTOM_VIEW_COLOR  RGB(236, 236, 236)

//平台sid
#define GETSID [SAUserDefaults getValueWithKey:USERDEFAULTS_SID]
#define GETPLATFORM_ID [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
#define GETUID [SAUserDefaults getValueWithKey:USERDEFAULTS_UID]
#define GETMEMBER_ID [SAUserDefaults getValueWithKey:USERDEFAULTS_id] //
#define sawtoothImage [UIImage imageNamed:@"new_icon_dividing_line"]//锯齿图片
