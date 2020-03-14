//
//  BLUShareViewController.h
//  Blue
//
//  Created by Bowen on 31/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUShareManager.h"

@class BLUPost;
@class BLUBottomTransitioningController;

@interface BLUShareViewController : BLUViewController

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

