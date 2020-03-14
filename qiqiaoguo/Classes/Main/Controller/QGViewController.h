//
//  QGViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/6/6.
//
//

#import <UIKit/UIKit.h>

@interface QGViewController : UIViewController

@property (nonatomic,assign)NSInteger page;

- (void)initBaseData;
@property (nonatomic,strong)SAImageView *navImageView;
@property (nonatomic,strong)SALabel *navTitleLabel;

@property (nonatomic,assign)CGFloat progress;// 进度条
@property (nonatomic,strong)SAImageView *emptyImageView;
@property (nonatomic,strong)SAButton *rightBtn;

@property (nonatomic,strong)SAImageView *emptyPic;//内容为空的提示图片


@property (nonatomic, assign) NSInteger messageCount;
// 创建本项目背景图
- (void)createBgImageView;
// 导航栏
- (void)createNavImageView;

- (void)createNavTitle:(NSString *)text;

- (void)createNavLeftImageBtn:(NSString *)imageName;
- (void)createNavRightBtn:(NSString *)textName;


- (void)navRightBtnClick;
- (void)navCustomLeftBtnClick;
- (void)navRightImageViewIsNullBtnClick;

- (void)getUserMessageCount;
- (void)updateUserMessageCount;

// 返回按钮
- (void)createReturnButton;
- (void)createCustomReturnButton;
// 添加键盘弹起通知
- (void)addKeyboardNotification;

- (void)viewWillFirstAppear;
// 下拉刷新控件停止动画
- (void)tableViewEndRefreshing:(UITableView *)tableView;
- (void)tableViewEndRefreshing:(UITableView *)tableView noMoreData:(BOOL)noMoreData;

// 登录
- (void)loginRequired:(NSNotificationCenter *)userInfo;
- (BOOL)loginIfNeeded;
// 空记录提示
- (void)showEmpty;
- (void)hiddenEmpty;

- (void)handleRemoteNotification:(NSNotification *)userInfo;

- (void)showUserRewardPromptIndicatorWithUserProfit:(id)profit;

- (void)showEmptyString:(NSString *)imagename;

- (void)addTiledLayoutConstrantForView:(UIView *)view;

// 无数据提示页
- (void)showCannotViewIfNeed:(BOOL)hidden;


@property (nonatomic,strong)UITapGestureRecognizer *baseTap;
@property (nonatomic,strong)SAButton *leftBtn;
@property (nonatomic,strong)UIButton *customLeftBtn;
@property (nonatomic, readonly, assign) CGFloat statusBarHeight;
@property (nonatomic, readonly, assign) CGFloat navigationBarHeight;
@property (nonatomic, readonly, assign) CGFloat tabBarHeight;

- (void)showTopIndicatorWithSuccessMessage:(NSString *)message;
- (void)showTopIndicatorWithError:(NSError *)error;
- (void)showTopIndicatorWithMessage:(NSString *)message image:(UIImage *)image;
- (void)showTopIndicatorWithErrorMessage:(NSString *)errorMessage;
- (void)showTopIndicatorWithWarningMessage:(NSString *)message;

@end
