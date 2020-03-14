//
//  BLUPostDetailOptionsViewController.m
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailOptionsViewController.h"
#import "BLUPost.h"
#import "BLUBottomTransitioningController.h"

@implementation BLUPostDetailOptionsViewController

- (instancetype)initWithPost:(BLUPost *)post {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(post, [BLUPost class]);

        _post = post;

        _optionContainer = [UIToolbar new];
        _optionContainer.clipsToBounds = YES;

        _cancelButton = [UIButton new];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setAttributedTitle:[self attributedCancel]
                                 forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tapAndCancel:)
                forControlEvents:UIControlEventTouchUpInside];

        _collectButton = [UIButton new];
        [_collectButton addTarget:self
                           action:@selector(tapAndCollect:)
                 forControlEvents:UIControlEventTouchUpInside];

        _collectLabel = [UILabel new];

        [self configureCollectSection];

        _reportButton = [UIButton new];
        [_reportButton setImage:[UIImage imageNamed:@"post-detail-option-report"]
                       forState:UIControlStateNormal];
        [_reportButton addTarget:self
                          action:@selector(tapAndReport:)
                forControlEvents:UIControlEventTouchUpInside];

        _reportLabel = [UILabel new];
        _reportLabel.attributedText =
        [self attributedButtonTitle:
         NSLocalizedString(@"post-detail-options-vc.report-label.title",
                           @"Report")];

        _reverseButton = [UIButton new];
        [_reverseButton setImage:[UIImage imageNamed:@"post-detail-option-reverse"]
                        forState:UIControlStateNormal];
        [_reverseButton addTarget:self
                           action:@selector(tapAndReverse:)
                 forControlEvents:UIControlEventTouchUpInside];

        _reverseLabel = [UILabel new];
        [self configureReverseLabel];

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

    [self.view addSubview:_optionContainer];
    [self.view addSubview:_cancelButton];

    [_optionContainer addSubview:_collectButton];
    [_optionContainer addSubview:_collectLabel];
    [_optionContainer addSubview:_reportButton];
    [_optionContainer addSubview:_reportLabel];
    [_optionContainer addSubview:_reverseButton];
    [_optionContainer addSubview:_reverseLabel];

    [_collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionContainer).offset([self contentVerticalMargin]);
        make.centerX.equalTo(self.optionContainer.mas_centerX).multipliedBy(1.0 / 3.0);
    }];

    [_collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectButton.mas_bottom).offset(BLUThemeMargin * 2);
        make.centerX.equalTo(self.collectButton);
        make.bottom.equalTo(self.optionContainer).offset(-[self contentVerticalMargin]);
    }];

    [_reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectButton);
        make.centerX.equalTo(self.optionContainer.mas_centerX);
    }];

    [_reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectLabel);
        make.centerX.equalTo(self.reportButton);
    }];

    [_reverseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectButton);
        make.centerX.equalTo(self.optionContainer.mas_centerX).multipliedBy(5.0 / 3.0);
    }];

    [_reverseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectLabel);
        make.centerX.equalTo(self.reverseButton);
    }];

    [_optionContainer setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
    [_optionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
    }];

    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionContainer.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@([self cancelButtonHeight]));
    }];
}

- (CGFloat)contentVerticalMargin {
    return BLUThemeMargin * 4;
}

- (CGFloat)cancelButtonHeight {
    return 60.0;
}

- (void)configureCollectSection {
    [self configureCollectLabel];
    [self configureCollectButton];
}

- (void)configureCollectLabel {
    NSString *title = nil;
    if (self.post.didCollect) {
        title = NSLocalizedString(@"post-detail-options.collect-button.did-collect",
                                  @"Did collect");
    } else {
        title = NSLocalizedString(@"post-detail-options.collect-button.collect",
                                  @"Collect");
    }

    [self.collectLabel setAttributedText:[self attributedButtonTitle:title]];
}

- (void)configureCollectButton {
    UIImage *image = nil;
    if (self.post.didCollect) {
        image = [UIImage imageNamed:@"post-detail-option-did-collect"];
    } else {
        image = [UIImage imageNamed:@"post-detail-option-collect"];
    }

    [self.collectButton setImage:image forState:UIControlStateNormal];
}

- (void)configureReverseLabel {
    NSString *title = nil;
    if (self.commentReverse) {
        title = NSLocalizedString(@"post-detail-option-reverse-label.Ascending",
                                  @"Ascending");
    } else {
        title = NSLocalizedString(@"post-detail-option-reverse-label.Descending",
                                  @"Descending");
    }
    [self.reverseLabel setAttributedText:[self attributedButtonTitle:title]];
}

- (NSAttributedString *)attributedCancel {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.58 saturation:0.01 brightness:0.64 alpha:1],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};

    NSString *cancelTitle =
    NSLocalizedString(@"post-detail-options-vc.cancel-title", @"Cancel");

    return
    [[NSAttributedString alloc] initWithString:cancelTitle
                                    attributes:attributed];
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

- (void)tapAndCollect:(UIButton *)button {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldChangeCollectionStateForPost:fromViewController:sender:)]) {
        [self.delegate shouldChangeCollectionStateForPost:self.post
                                       fromViewController:self
                                                   sender:button];
    }
    [self cancelOptions];
}

- (void)tapAndReport:(UIButton *)button {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldReportPost:fromViewController:sender:)]) {
        [self.delegate shouldReportPost:self.post
                     fromViewController:self
                                 sender:button];
    }
    [self cancelOptions];
}

- (void)tapAndReverse:(UIButton *)button {
    if ([self.delegate
         respondsToSelector:
         @selector(shouldReverseCommentFromViewController:sender:)]) {
        [self.delegate shouldReverseCommentFromViewController:self
                                                       sender:button];
    }
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
