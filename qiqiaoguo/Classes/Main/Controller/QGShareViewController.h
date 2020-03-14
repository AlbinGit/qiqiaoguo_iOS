//
//  QGShareViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/6/20.
//
//  分享页

#import "QGViewController.h"
#import "BLUShareManager.h"

@class BLUPost;
@class BLUBottomTransitioningController;


@interface QGShareViewController : QGViewController

@property (nonatomic, strong) UIToolbar *shareContainer;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *wechatTimelineButton;
@property (nonatomic, strong) UIButton *wechatSessionButton;
@property (nonatomic, strong) UIButton *sinaButton;
@property (nonatomic, strong) UIButton *qZoneButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *linkButton;

@property (nonatomic, strong) UILabel *wechatTimelineLabel;
@property (nonatomic, strong) UILabel *wechatSessionLabel;
@property (nonatomic, strong) UILabel *sinaLabel;
@property (nonatomic, strong) UILabel *qZoneLabel;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UILabel *linkLabel;

@property (nonatomic, strong) UIView *separator;

@property (nonatomic, assign) CGFloat contentVerticalMargin;
@property (nonatomic, assign) CGFloat cancelButtonHeight;

@property (nonatomic, strong) BLUShareManager *shareManager;

@property (nonatomic, strong) id <BLUShareObject> shareObject;

@property (nonatomic, strong) BLUBottomTransitioningController *transitioningController;



@end
