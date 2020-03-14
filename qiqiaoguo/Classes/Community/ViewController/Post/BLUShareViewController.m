//
//  BLUShareViewController.m
//  Blue
//
//  Created by Bowen on 31/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUShareViewController.h"
#import "BLUShareManager.h"
#import "BLUPost.h"
#import "BLUBottomTransitioningController.h"

@implementation BLUShareViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _shareManager = [BLUShareManager new];
        _shareManager.presentedViewController = self;

        _cancelButtonHeight = 60.0;
        _contentVerticalMargin = BLUThemeMargin * 4;

        _shareContainer = [UIToolbar new];
        _shareContainer.clipsToBounds = YES;
        _shareContainer.translucent = YES;

        _cancelButton = [UIButton new];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setAttributedTitle:[self attributedCancel]
                                 forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tapAndCancel:)
                forControlEvents:UIControlEventTouchUpInside];

        _wechatTimelineButton =
        [self makeButtonWithImage:[UIImage imageNamed:@"post-detail-share-weichat-timeline"]
                         selector:@selector(tapAndShareToWechatTimeline)];
        _wechatSessionButton =
        [self makeButtonWithImage:[UIImage imageNamed:@"post-detail-share-wechat-session"]
                         selector:@selector(tapAndShareToWechatSession)];
        _sinaButton =
        [self makeButtonWithImage:[UIImage imageNamed:@"post-detail-share-weibo"]
                         selector:@selector(tapAndShareToSina)];

        _qZoneButton =
        [self makeButtonWithImage:[UIImage imageNamed:@"post-detail-share-qq-zone"]
                         selector:@selector(tapAndShareToQZone)];
        _qqButton =
        [self makeButtonWithImage:[UIImage imageNamed:@"post-detail-share-qq-friend"]
                         selector:@selector(tapAndShareToQQ)];
        _linkButton =
        [self makeButtonWithImage:[UIImage imageNamed:@"post-detail-share-url"]
                         selector:@selector(tapAndShareURL)];

        _wechatTimelineButton.enabled = [QGSocialService isSupportWX];
        _wechatSessionButton.enabled = [QGSocialService isSupportWX];
//        _qqButton.enabled = [BLUSocialService isSupportQQ];
//        _qZoneButton.enabled = [BLUSocialService isSupportQQ];
//        _sinaButton.enabled = [BLUSocialService isSupportSina];

        NSString *wechatTimelineTitle =
        NSLocalizedString(@"post-detail-share-vc.wechat-timeline.title",
                          @"Wechat timeline");
        NSString *wechatSesstionTitle =
        NSLocalizedString(@"post-detail-share-vc.wechat-session.title",
                          @"Wechat sesstion");
        NSString *sinaTitle =
        NSLocalizedString(@"post-detail-share-vc.sina.title",
                          @"Sina");
        NSString *qZoneTitle =
        NSLocalizedString(@"post-detail-share-vc.qzone.title",
                          @"QZone");
        NSString *qqTitle =
        NSLocalizedString(@"post-detail-share-vc.qq.title",
                          @"QQ");
        NSString *linkTitle =
        NSLocalizedString(@"post-detail-share-vc.link.title",
                          @"Share link");

        _wechatTimelineLabel = [self makeLabelWithTitle:wechatTimelineTitle];
        _wechatSessionLabel = [self makeLabelWithTitle:wechatSesstionTitle];
        _sinaLabel = [self makeLabelWithTitle:sinaTitle];
        _qZoneLabel = [self makeLabelWithTitle:qZoneTitle];
        _qqLabel = [self makeLabelWithTitle:qqTitle];
        _linkLabel = [self makeLabelWithTitle:linkTitle];

        _separator = [UIView new];
        _separator.backgroundColor = [UIColor whiteColor];

        _transitioningController = [BLUBottomTransitioningController new];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.transitioningController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *recognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAndDismiss:)];
    [self.view addGestureRecognizer:recognizer];

    [self.view addSubview:_shareContainer];
    [self.view addSubview:_cancelButton];

//    [_shareContainer addSubview:_separator];

    [_shareContainer addSubview:_wechatTimelineButton];
    [_shareContainer addSubview:_wechatSessionButton];
//    [_shareContainer addSubview:_sinaButton];
//    [_shareContainer addSubview:_qZoneButton];
//    [_shareContainer addSubview:_qqButton];
    [_shareContainer addSubview:_linkButton];

    [_shareContainer addSubview:_wechatTimelineLabel];
    [_shareContainer addSubview:_wechatSessionLabel];
//    [_shareContainer addSubview:_sinaLabel];
//    [_shareContainer addSubview:_qZoneLabel];
//    [_shareContainer addSubview:_qqLabel];
    [_shareContainer addSubview:_linkLabel];

    [_shareContainer setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
    [_shareContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(_cancelButton.mas_top);
    }];

    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareContainer.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@([self cancelButtonHeight]));
    }];

    [_wechatTimelineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareContainer).offset([self contentVerticalMargin]);
        make.centerX.equalTo(self.shareContainer).multipliedBy(1.0 / 3.0);
    }];

    [_wechatSessionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatTimelineButton);
        make.centerX.equalTo(self.shareContainer);
    }];

//    [_sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.wechatTimelineButton);
//        make.centerX.equalTo(self.shareContainer).multipliedBy(5.0 / 3.0);
//    }];

    [_wechatTimelineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatTimelineButton.mas_bottom).offset([self contentVerticalMargin]);
        make.centerX.equalTo(self.wechatTimelineButton);
    }];
    

    [_wechatSessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatTimelineLabel);
        make.centerX.equalTo(self.wechatSessionButton);
    }];

//    [_sinaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.wechatTimelineLabel);
//        make.centerX.equalTo(self.sinaButton);
//    }];

//    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.wechatTimelineLabel.mas_bottom).offset([self contentVerticalMargin]);
//        make.left.right.equalTo(self.shareContainer);
//        make.height.equalTo(@(BLUThemeOnePixelHeight));
//    }];

//    [_qZoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.separator.mas_bottom).offset([self contentVerticalMargin]);
//        make.centerX.equalTo(self.wechatTimelineButton);
//    }];
//
//    [_qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.qZoneButton);
//        make.centerX.equalTo(self.wechatSessionButton);
//    }];

    [_linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.qZoneButton);
//        make.centerX.equalTo(self.sinaButton);
        make.top.equalTo(self.wechatTimelineButton);
        make.centerX.equalTo(self.shareContainer).multipliedBy(5.0 / 3.0);

    }];

//    [_qZoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.qZoneButton.mas_bottom).offset([self contentVerticalMargin]);
//        make.centerX.equalTo(self.qZoneButton);
//        make.bottom.equalTo(self.shareContainer).offset(-[self contentVerticalMargin]);
//    }];
//
//    [_qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.qZoneLabel);
//        make.centerX.equalTo(self.qqButton);
//    }];

    [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.qZoneLabel);
        make.top.equalTo(self.wechatTimelineLabel);
        make.centerX.equalTo(self.linkButton);
        make.bottom.equalTo(self.shareContainer).offset(-[self contentVerticalMargin]);
    }];
}

- (UIButton *)makeButtonWithImage:(UIImage *)image selector:(SEL)selector {
    UIButton *button = [UIButton new];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UILabel *)makeLabelWithTitle:(NSString *)title {
    UILabel *label = [UILabel new];
    label.attributedText = [self attributedButtonTitle:title];
    return label;
}

- (NSAttributedString *)attributedButtonTitle:(NSString *)title {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.58 saturation:0.02 brightness:0.41 alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};

    return
    [[NSAttributedString alloc] initWithString:title
                                    attributes:attributed];
}

- (NSAttributedString *)attributedCancel {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.58 saturation:0.01 brightness:0.64 alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    NSString *cancelTitle =
    NSLocalizedString(@"post-detail-share-vc.cancel-title", @"Cancel");

    return
    [[NSAttributedString alloc] initWithString:cancelTitle
                                    attributes:attributed];
}

- (void)tapAndShareToWechatTimeline {
    [self.shareManager shareContentWithObject:self.shareObject
                                    shareType:BLUShareTypeWechatTimeline];
    [self cancelOptions];
}

- (void)tapAndShareToWechatSession {
    [self.shareManager shareContentWithObject:self.shareObject
                                    shareType:BLUShareTypeWechatSession];
    [self cancelOptions];
}

//- (void)tapAndShareToSina {
//    [self.shareManager shareContentWithObject:self.shareObject
//                                    shareType:BLUShareTypeSina];
//    [self cancelOptions];
//}

//- (void)tapAndShareToQZone {
//    [self.shareManager shareContentWithObject:self.shareObject
//                                    shareType:BLUShareTypeQZone];
//    [self cancelOptions];
//}
//
//- (void)tapAndShareToQQ {
//    [self.shareManager shareContentWithObject:self.shareObject
//                                    shareType:BLUShareTypeQQSession];
//    [self cancelOptions];
//}

- (void)tapAndShareURL {
    [self.shareManager copyURLToPasteboardWithShareObject:self.shareObject];
    [self cancelOptions];
}

- (void)tapAndCancel:(UIButton *)button {
    [self cancelOptions];
}

- (void)tapAndDismiss:(UITapGestureRecognizer *)recognizer {
    [self cancelOptions];
}

- (void)cancelOptions {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
