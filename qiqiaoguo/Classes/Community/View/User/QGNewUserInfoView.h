//
//  QGNewUserInfoView.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QGNewUserInfoView;

@protocol QGNewUserInfoViewDelegate <NSObject>

@optional
- (void)shouldSignActionfromUserInfoView:(QGNewUserInfoView *)userInfoView;
- (void)shouldUnfollowUser:(BLUUser *)user fromUserInfoView:(QGNewUserInfoView *)userInfoView;
- (void)shouldChatWithUser:(BLUUser *)user fromUserInfoView:(QGNewUserInfoView *)userInfoView;
- (void)shouldSettingUesrInfoFromUserInfoView:(QGNewUserInfoView *)userInfoView;
- (void)shouldLoginFromUserInfoView:(QGNewUserInfoView *)userInfoView;
//收藏
- (void)shouldCollectionfromUserInfoView:(QGNewUserInfoView *)userInfoView;

@required
- (void)shouldShowFollowingsFromUserInfoView:(QGNewUserInfoView *)userInfoView;
- (void)shouldShowFollowersFromUserInfoView:(QGNewUserInfoView *)userInfoView;
- (void)shouldShowNewsFromUserInfoView:(QGNewUserInfoView *)userInfoView;

@end
@interface QGNewUserInfoView : UIView

@property (nonatomic, weak) id <QGNewUserInfoViewDelegate> delegate;

@property (nonatomic, copy) BLUUser *user;

@property (nonatomic,strong) UIImageView *personImgView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *signBtn;
@property (nonatomic,strong) UILabel *messageLabel;

@end

NS_ASSUME_NONNULL_END
