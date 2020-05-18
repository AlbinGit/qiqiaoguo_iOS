//
//  PLUtilsDefine.h
//  ToysOnline
//
//  Created by Albin on 14-8-21.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

// 枚举
typedef NS_ENUM(NSInteger, SARefreshType)
{
    SARefreshPullUpType = 0,//上拉
    SARefreshPullDownType//下拉
};

//---------------------环境切换---------------1测试 0 正式
#define QGDEBUG 1
//#warning 切换正式环境时需修改极光推送的plist文件中的APS_FOR_PRODUCTION设置成生产环境(1)

#if QGDEBUG
//#define QQG_BASE_APIURLString  @"http://api.qiqiaoguo.com"
//#define QQG_BASE_APIURLString  @"http://api.qqg.blue69.cn"
////#define QQG_BASE_APIURLString  @"http://192.168.2.186:8001"
#define QQG_BASE_APIURLString  @"http://t.api.qiqiaoguo.com"

//#define QG_NEW_APIURLString  @"http://t.api.qiqiaoguo.com"

#else
//#define QQG_BASE_APIURLString  @"http://api.qiqiaoguo.com"
#define QQG_BASE_APIURLString  @"http://api.qiqiaoguo.com"

//#define QG_NEW_APIURLString  @"http://t.api.qiqiaoguo.com"

#endif

// 单例
#define SASDB [SADatabase sharedDatabase]

//唯一标示
#define PL_UTILS_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//版本号
#define PL_UTILS_VERSION [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 判断是否是iOS7    #define PL_UTILS_IOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0
// 是否是Reatna4
#define PL_UTILS_RETAINA4 ([UIScreen mainScreen].bounds.size.height == 568)
// RGB背景色
#define PL_UTILS_COLORRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
// RGB CGCOLOR背景色
#define PL_UTILS_COLORRGB_CG(r,g,b) [[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] CGColor]
//获取十六进制颜色值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//-------------------获取设备大小-------------------------

// NavBar高度
#define NAVHEIGHT ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0 ? 64 : 10)
// 是否是IOS7以上
#define ISIOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)


// 获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//打电话、发邮件
#define callPhone(number)[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",number]]]
#define callEmail(email)[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",email]]]
//-------------------获取设备大小-------------------------


//-------------------打印日志-------------------------

// 重写NSLog,非发布模式下打印日志和当前行数


// NSLOG打印
#define SADEBUG 1
#if SADEBUG
#define NLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NLog(FORMAT, ...) nil


#endif

// 打印返回responsedata
#define PLLogData(obj,content) \
if(SADEBUG) \
{ \
NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil]; \
NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]; \
NSLog(@"%@----->%@",content,string); \
}

//---------------------打印日志--------------------------


//----------------------系统----------------------------
//提示框
#define ALERT(msg)   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];\
[alertView show];\



// 获取沙盒
#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0]

// 获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CURRENTSYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
// 获取系统唯一标示符
#define DEVICESERIAL_NO [[[UIDevice currentDevice] identifierForVendor] UUIDString]

// 获取当前语言
#define CURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

#define PL_UTILS_IOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0
// 判断是否 Retina屏、设备是否Iphone 5、是否是iPad
#define ISRETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


// 判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

// 检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 从AppStore获取应用信息和下载地址
#define APP_INFO(v)     [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",v]
#define APP_DOWNLOAD(v) [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",v]

//----------------------系统----------------------------



//----------------------图片----------------------------

// 读取本地图片
#define ImageWithContentsOfFile(A,T) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:T]]

// 读取图片（带缓存）
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

// 建议使用前一种宏定义,性能高于后者

//----------------------图片----------------------------



//----------------------属性定义----------------------------

#define PropertyString(p) @property (nonatomic, copy)   NSString *p
//#define PropertyMutableArray(p) @property (nonatomic,retain) NSMutableArray *p

#define PropertyFloat(p)  @property (nonatomic, assign) float p
#define PropertyDouble(p) @property (nonatomic, assign) double p

#define PropertyInt(p)    @property (nonatomic, assign) NSInteger p
#define PropertyUInt(p)   @property (nonatomic, assign) NSUInteger p
#define PropertyBool(p)   @property (nonatomic, assign) BOOL p

#define PropertyStrong(T,P) @property(nonatomic,strong) T *P
#define PropertyAssign(T,P) @property(nonatomic,assign) T P

//----------------------属性定义----------------------------



//----------------------颜色类---------------------------

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

// 清除背景色
#define CLEARCOLOR [UIColor clearColor]

//自定义字体
//[UIFont fontWithName:@"DFPShaoNvW5-GB" size:f]
#define FONT_CUSTOM(f)  [UIFont systemFontOfSize:f]
#define FONT_SYSTEM(f)  [UIFont systemFontOfSize:f]
#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//----------------------颜色类--------------------------



//----------------------其他----------------------------
#define MainSB  [UIStoryboard storyboardWithName:@"Main" bundle:nil]
// 设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
// 程序的本地化,引用国际化的文件
#define MyLocal(x, ...)               NSLocalizedString(x, nil)

// G－C－D
#define GCD_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

// NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

// 由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

/*
 SuppressPerformSelectorLeakWarning(
 [_target performSelector:_action withObject:self]
 );
 */

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

// 收键盘
#define PL_CODE_RETURNKEYBOARD [[[UIApplication sharedApplication]keyWindow]endEditing:YES];

// 弱引用
#define PL_CODE_WEAK(varName)\
__weak __typeof(self)varName = self;

#define PL_CODE_SAFEREMOVEW(varName) \
[varName removeFromSuperview]; \
varName = nil;

// 添加通知
#define PL_CODE_NOTIFICATION_ADD(notificationName,method) \
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method) name:notificationName object:nil];

// 调用通知
#define PL_CODE_NOTIFICATION_POST(notificationName,param) \
[[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:param];

// 删除通知
#define PL_CODE_NOTIFICATION_REMOVE(notificationName) \
[[NSNotificationCenter defaultCenter]removeObserver:self name:notificationName object:nil];

/*
 专门用来保存单例代码
 最后一行不要加 \
 */

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

/*
 内存代码监测
 */
#define printfMemorySize \
vm_statistics_data_t vmStats; \
mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT; \
kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount); \
if(kernReturn != KERN_SUCCESS) \
{ \
return NSNotFound; \
} \
double power = ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0; \
printf("剩余内存 %ld M\n",(long) power)

/*
 动态视图控制器跳转
 */
#define kNavController_Push(v) \
id class = [[NSClassFromString(v) alloc] init]; \
[self.navigationController pushViewController:class animated:YES]

/*
 视图跳转动画
 */
#define kNavController_Push_Animation(v) \
CATransition* transition = [CATransition animation]; \
transition.duration = 0.8f; \
transition.type = v; \
transition.subtype = kCATransitionFromLeft; \
[self.navigationController.view.layer addAnimation:transition forKey:nil]

/*
 圆角
 */
#define kRadius(v) \
[v.layer setMasksToBounds:YES]; \
[v.layer setCornerRadius:5.0f]

/*
 边框
 */
#define kBorder(T,V) \
V.layer.borderColor = T.CGColor; \
V.layer.borderWidth = 1

/*
圆形
*/
#define KRound(v)\
v.layer.masksToBounds = YES;\
v.layer.cornerRadius = CGRectGetHeight(v.frame) / 2.0;\

/*
 隐藏横向和纵向滚动条
 */
#define kHideScrollLine(v) \
v.showsHorizontalScrollIndicator = NO; \
v.showsVerticalScrollIndicator = NO

/*
 清空背景颜色
 */
#define kClearBackground(v) v.backgroundColor = [UIColor clearColor]


/*
 常用代码
 */
#define PL_CELL_CREATE(cellClass) \
static NSString *cellName = @"cell"; \
cellClass *cell  = [tableView dequeueReusableCellWithIdentifier:cellName]; \
if(cell == nil) \
{ \
cell = [[cellClass alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellName]; \
}


//从nib加载cell
#define PL_CELL_NIB_CREATE(cellClass);\
static NSString *cellName = @"cell";\
NSString* nibName = NSStringFromClass([cellClass class]);\
cellClass *cell = [tableView dequeueReusableCellWithIdentifier:cellName];\
if (cell == nil)\
{\
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];\
    cell = [nib objectAtIndex:0];\
}\

#define PL_CELL_CREATEMETHOD(cellClass,staticCellName) \
cellClass *cell  = [tableView dequeueReusableCellWithIdentifier:staticCellName]; \
if(cell == nil) \
{ \
cell = [[cellClass alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:staticCellName]; \
}
//加载nib
#define PL_NIBCELL_CREATEMETHOD(cellClass,staticCellName,number);\
NSString* nibName = NSStringFromClass([cellClass class]);\
cellClass *cell = [tableView dequeueReusableCellWithIdentifier:staticCellName];\
if (cell == nil)\
{\
NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];\
cell = [nib objectAtIndex:number];\
}

#define PL_PUSH_VCNAME(vcname);\
[self.navigationController pushViewController:vcname animated:YES];\

#define PL_PRICE_COLOR RGB(254, 24, 83)
#define PL_NAVIMAGE_COLOR  RGB(235, 25, 68)
#define formalOrTest @"formalOrTest"
//badge0
#define BADGE @"badge0"
//购物车id
#define CART_ID @"cart_id"
//秒杀id
#define SKILLCART_ID @"cart_id2"
#define BUYCURRENTLYCART_ID @"buycurrently_cartId"

#define skillType  @"seckilling"
#define buyNowType @"buycurrently"
//badge
#define CART_BADGE @"badge0"
#define PL_COLOR_245 RGB(245, 245, 245)
#define PL_PRICE_COLOR RGB(254, 24, 83)
//灰色
#define PL_COLOR_160 RGB(160,160,160)
//背景红
#define PL_COLOR_243  RGB(243, 27, 27)
//黑色字体
#define PL_COLOR_30  RGB(60,60,60)
//边框、
#define PL_COLOR_220  RGB(220,220,220)
//画横线的字体
#define PL_COLOR_200  RGB(200,200,200)
//购物底部View的背景颜色
#define PL_COLOR_240  RGB(240,240,240)
//字体红
#define PL_COLOR_237  RGB(237,0,0)
//白色
#define PL_COLOR_255  RGB(255,255,255)
//评论背景灰
#define PL_COLOR_230  RGB(230,230,230)
//橙色
#define PL_COLOR_orange RGB(255,98,7)
//灰色
#define PL_COLOR_gray RGB(153,153,153)
//教育黑色
#define PL_COLOR_black RGB(30,30,30)
//红色
#define PL_COLOR_red RGB(243,27,27)

