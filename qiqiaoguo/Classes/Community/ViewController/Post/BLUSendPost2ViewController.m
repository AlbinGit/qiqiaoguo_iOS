//
//  BLUSendPost2ViewController.m
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController.h"
#import "BLUSendPost2CircleSelector.h"
#import "BLUSendPost2Toolbar.h"
#import "BLUSendPost2ViewController+Toolbar.h"
#import "BLUSendPost2ViewController+Text.h"
#import "BLUPostTagContainer.h"
#import "BLUCircleSearchViewController.h"
#import "BLUCircle.h"
#import "BLUSendPost2ViewController+Helper.h"
#import "BLUTextView.h"
#import "BLUApiManager+Post.h"
#import "BLUSendPost2ViewModel.h"
#import "BLUPostTag.h"
#import "BLUAlertView.h"

#define kTextViewPlaceholder NSLocalizedString(@"send-post.content-text-view.placeholder", @"Content")
static NSString * const BLUSendPost2VCShouldShowTagGuide = @"BLUSendPost2VCShouldShowTagGuide";

const NSInteger BLUSendPost2MaxImageCount = 20;

@implementation BLUSendPost2ViewController

- (instancetype)init {
    if (self = [super init]) {
        _reminingImagesCount = BLUSendPost2MaxImageCount;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardChanged:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardChanged:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _viewModel = [BLUSendPost2ViewModel new];

    _circleSelector = [BLUSendPost2CircleSelector new];
    _circleSelector.delegate = self;

    _titleTextField = [UITextField new];
    _titleTextField.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
    _titleTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:NSLocalizedString(@"send-post.title-text-field.placeholder", @"Title")
     attributes:@{NSForegroundColorAttributeName: _circleSelector.sendLabel.textColor}];
    _titleTextField.returnKeyType = UIReturnKeyDone;
    _titleTextField.delegate = self;
    _titleTextField.layer.sublayerTransform = CATransform3DMakeTranslation(BLUThemeMargin * 4, 1, 0);
    _titleTextField.textColor = [UIColor colorWithRed:0.38 green:0.39 blue:0.39 alpha:1];

    _divider = [UIView new];
    _divider.backgroundColor = [UIColor colorFromHexString:@"#E3E4E5"];

    _contentTextView = [BLUTextView new];
    _contentTextView.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:kTextViewPlaceholder
     attributes:@{NSForegroundColorAttributeName: _circleSelector.sendLabel.textColor}];
    _contentTextView.returnKeyType = UIReturnKeyDone;
    _contentTextView.delegate = self;
    _contentTextView.font = _titleTextField.font;
    _contentTextView.textColor = _titleTextField.textColor;
    _contentTextView.typingAttributes = @{NSFontAttributeName: _titleTextField.font,
                                          NSForegroundColorAttributeName: _titleTextField.textColor};
    _contentTextView.allowsEditingTextAttributes = YES;
    _contentTextView.returnKeyType = UIReturnKeyDefault;
    _contentTextView.textContainerInset =
    UIEdgeInsetsMake([BLUCurrentTheme topMargin] * 2 + 3,
                     [BLUCurrentTheme leftMargin] * 2 + 3, 0,
                     [BLUCurrentTheme rightMargin] * 2 + 3);

    _toolbar = [BLUSendPost2Toolbar new];
    _toolbar.sendPost2ToolbarDelegate = self;
    _toolbar.backgroundColor = _circleSelector.backgroundColor;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleBottomMargin;
    CGFloat toolbarHeight = 44.0;
    CGFloat toolbarY = self.view.height - toolbarHeight - 64;
    _toolbar.frame = CGRectMake(0, toolbarY, self.view.width, toolbarHeight);

    _tagContainer = [BLUPostTagContainer new];
    _tagContainer.backgroundColor = [UIColor whiteColor];
    _tagContainer.selectAble = NO;
    _tagContainer.deleteAble = YES;
    _tagContainer.editable = NO;
    _tagContainer.postTagContainerDelegate = self;
    UIEdgeInsets textContainerInset = _tagContainer.textContainerInset;
    textContainerInset.left = BLUThemeMargin * 2;
    textContainerInset.right = BLUThemeMargin * 2;
    _tagContainer.textContainerInset = textContainerInset;
    _tagContainer.frame = CGRectZero;

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(tapAndDismiss:)];
    UIButton *face = [UIButton new];
    face.frame = CGRectMake(0, 0, 44, 24);
    [face setImage:[UIImage imageNamed:@"send-post-2-send-disable"] forState:UIControlStateDisabled];
    [face setImage:[UIImage imageNamed:@"send-post-2-send-enable"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:face];
    face.rac_command = self.viewModel.send;
    self.navigationItem.rightBarButtonItem = rightButton;

    @weakify(self);
    [[self.viewModel validatePost] subscribeNext:^(NSNumber *enable) {
        @strongify(self);
        self.navigationItem.rightBarButtonItem.enabled = enable.boolValue;
    }];

    [[face.rac_command executionSignals] subscribeNext:^(RACSignal *send) {
        @strongify(self);
        [self.view showIndicator];
        [send subscribeNext:^(id x) {
            [self.view hideIndicator];
            [self dismissViewControllerAnimated:YES completion:^{}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(sendPostViewControllerDidSendPost:)]) {
                    [self.delegate sendPostViewControllerDidSendPost:self];
                }
            });
        }];
    }];

    [[face.rac_command errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];

    self.viewModel.title = self.titleTextField.text;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_circleSelector];
    [self.view addSubview:_titleTextField];
    [self.view addSubview:_divider];
    [self.view addSubview:_contentTextView];
    [self.view addSubview:_tagContainer];
    [self.view addSubview:_toolbar];

    [self configureWithTags:self.tags];
    [self configureWithCircle:self.circle];

    self.title = NSLocalizedString(@"send-post-2-vc.title", @"Send post");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat circleSelectorWidth = self.view.width;
    CGFloat circleSelectorHeight = 44.0;

    _circleSelector.frame =
    CGRectMake(0, self.topLayoutGuide.length,
               circleSelectorWidth, circleSelectorHeight);

    _titleTextField.x = 0;
    _titleTextField.y = _circleSelector.bottom;
    _titleTextField.height = _circleSelector.height;
    _titleTextField.width = _circleSelector.width;

    _divider.frame = CGRectMake(BLUThemeMargin * 2,
                                _titleTextField.bottom,
                                self.view.width - BLUThemeMargin * 4,
                                BLUThemeOnePixelHeight);

    [self layoutTagContainer];
    [self layoutContentTextView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureGuide];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCircle:(BLUCircle *)circle {
    BLUAssertObjectIsKindOfClass(circle, [BLUCircle class]);
    _circle = circle;
    [self configureWithCircle:_circle];
}

- (void)setTags:(NSArray *)tags {
    BLUAssertObjectIsKindOfClass(tags, [NSArray class]);
    _tags = tags;
    [self configureWithTags:tags];
}

- (void)configureWithCircle:(BLUCircle *)circle {
    self.viewModel.circleID = circle.circleID;
    if (self.circleSelector) {
        self.circleSelector.circleTitle = _circle.name;
    }
}

- (void)configureWithTags:(NSArray *)tags {
    self.viewModel.tags = tags;
    if (self.tagContainer) {
        [self.tagContainer removeAllTags];
        [self.tagContainer addTags:_tags];
        [self layoutTagContainer];
        [self layoutContentTextView];
    }
}

- (UIScrollView *)scrollView {
    return (UIScrollView *)self.view;
}

- (void)layoutTagContainer {
    CGFloat tagContainerHeight = 0.0;
    if (_tagContainer.allTags.count > 0) {
        tagContainerHeight = _tagContainer.contentSize.height;
    } else {
        tagContainerHeight = 0.0;
    }

    CGFloat tagContainerY =
    self.view.height - self.bottomLayoutGuide.length - _toolbar.height - tagContainerHeight;

    _tagContainer.frame =
    CGRectMake(0, tagContainerY, self.view.width, tagContainerHeight);
}

- (void)layoutContentTextView {
    CGFloat tagContanerY =
    _tagContainer.height > 0 ? _tagContainer.y : CGFLOAT_MAX;
    CGFloat bottomY = tagContanerY < _toolbar.y ? tagContanerY : _toolbar.y;
    CGFloat textViewHeight = bottomY - _divider.bottom - 1;
    _contentTextView.frame =
    CGRectMake(0, _divider.bottom + _divider.height, self.view.width, textViewHeight);
}

- (void)tapAndDismiss:(id)sender {
    BLUAlertView *alertView =
    [[BLUAlertView alloc] initWithTitle:NSLocalizedString(@"send-post-2-vc.should-cancel-edit",
                                                          @"Do you want to cancel edit?")
                                message:nil
                      cancelButtonTitle:NSLocalizedString(@"send-post-2-vc.ok",
                                                          @"OK")
                       otherButtonTitle:NSLocalizedString(@"send-post-2-vc.cancel",
                                                          @"cancel")];

    alertView.messageBottomPadding = 32;

    alertView.cancelButtonAction = ^() {
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    @weakify(alertView);
    alertView.otherButtonAction = ^() {
        @strongify(alertView);
        [alertView dismiss];
    };

    [alertView show];
}

#pragma mark - Keyboard.

- (void)keyboardChanged:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *notificationName = notification.name;

    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    CGRect keyboardBeginFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [window convertRect:keyboardEndFrame toView:self.view];

    [UIView beginAnimations:nil context:nil];

    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (notificationName == UIKeyboardWillShowNotification) {
        _toolbar.y = keyboardFrame.origin.y - _toolbar.height;
        [self layoutContentTextView];
    } else {
        _toolbar.y = self.view.height - _toolbar.height - self.bottomLayoutGuide.length;
        [self layoutContentTextView];
    }

    [UIView commitAnimations];
}

#pragma mark - Guide

- (void)configureGuide {

    NSNumber *showCoinShopGuide = [[NSUserDefaults standardUserDefaults]
                                   objectForKey:BLUSendPost2VCShouldShowTagGuide];

    if (showCoinShopGuide == nil) {
        showCoinShopGuide = @(YES);
    }

    [[NSUserDefaults standardUserDefaults]
     setObject:@(NO)
     forKey:BLUSendPost2VCShouldShowTagGuide];

    [[NSUserDefaults standardUserDefaults] synchronize];

    if (showCoinShopGuide.boolValue) {
        [self showTagGuide];
    }

}

- (void)showTagGuide {
    return;
    UIView *dimView = [self dimView];

    UITapGestureRecognizer *tapDimView = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handleDimViewAction:)];
    [dimView addGestureRecognizer:tapDimView];

    for (UIView *subview in dimView.subviews) {
        subview.alpha = 0.0;
    }

    UIView *guideView = [self tagGuideViewForDimView:dimView];
    guideView.tag = 1;
    guideView.alpha = 1.0;
    dimView.alpha = 0;

    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        dimView.alpha = 1.0;
    }];
}

- (void)handleDimViewAction:(UITapGestureRecognizer *)tap {
    UIView *dimView = tap.view;

    UIView * (^currentAppearingSubview)(UIView *dv) = ^UIView *(UIView *dv) {
        for (UIView *subView in dv.subviews) {
            if (subView.alpha == 1.0) {
                return subView;
            }
        }
        return nil;
    };

    UIView *lastGuideView = currentAppearingSubview(dimView);
    UIView *nextGuideView = [dimView viewWithTag:lastGuideView.tag + 1];

    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        if (nextGuideView) {
            lastGuideView.alpha = 0.0;
            nextGuideView.alpha = 1.0;
        } else {
            dimView.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        if (nextGuideView) {
            [lastGuideView removeFromSuperview];
        } else {
            [dimView removeFromSuperview];
        }
    }];
}

- (UIView *)tagGuideViewForDimView:(UIView *)dimView {

    UIView *guideView = [UIView new];
    guideView.frame = dimView.bounds;
    [dimView addSubview:guideView];

    UIImageView *guideImageView = [UIImageView new];
    guideImageView.image = [UIImage imageNamed:@"user-guide-tag"];

    UIImageView *tagImageView = [UIImageView new];
    tagImageView.image = [UIImage imageNamed:@"send-post-tag"];
    CGRect tagRect = [self.toolbar.tagButton
                      convertRect:self.toolbar.tagButton.bounds
                      toView:dimView];
    tagImageView.frame = tagRect;

    CGFloat guideY = tagImageView.y - guideImageView.image.size.height - BLUThemeMargin;
    CGFloat guideX = -20;
    CGSize guideSize = guideImageView.image.size;

    guideImageView.frame = CGRectMake(guideX, guideY,
                                      guideSize.width, guideSize.height);

    [guideView addSubview:tagImageView];
    [guideView addSubview:guideImageView];

    return guideView;
}

- (UIView *)dimView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *dimView = [UIView new];
    dimView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];

    [window addSubview:dimView];
    dimView.frame = window.bounds;
    return dimView;
}

@end
