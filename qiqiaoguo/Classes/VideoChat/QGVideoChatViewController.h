//
//  QGVideoChatViewController.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/7.
//

#import "QGViewController.h"
#import <AliRTCSdk/AliRTCSdk.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGVideoChatViewController : QGViewController

@end

@interface RTCRemoterUserView : UICollectionViewCell

/**
 @brief 用户流视图
 
 @param view renderview
 */
- (void)updateUserRenderview:(AliRenderView *)view;

/**
 @brief Switch点击事件回调
 */
@property(nonatomic,copy) void(^switchblock)(BOOL);


/**
 @brief 灰色底View
 */
@property (nonatomic,strong) UIView *view;

/**
 @brief 视频(屏幕)镜像开关
 */
@property (nonatomic,strong) UISwitch *CameraMirrorSwitch;

/**
 @brief 视频(屏幕)镜像描述
 */
@property (nonatomic,strong) UILabel *CameraMirrorLabel;

- (void)onCameraMirrorClicked:(UISwitch *)switchView;


@end

NS_ASSUME_NONNULL_END
