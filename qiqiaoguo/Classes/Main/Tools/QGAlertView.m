//
//  QGAlertView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//


#define DEFAULT_ALERT_WIDTH 280
#define DEFAULT_ALERT_HEIGHT 144


#import "QGAlertView.h"

@interface QGAlertView ()

@property (nonatomic, strong) UIView * alertContentView;

@property (nonatomic, strong) UIView * horizontalSeparator;
@property (nonatomic, strong) UIView * verticalSeparator;

@property (nonatomic, strong) UIView * topRedView;

@property (nonatomic, strong) UIView * blackOpaqueView;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * cancelButtonTitle;
@property (nonatomic, strong) NSString * otherButtonTitle;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIColor *originCancelButtonColor;
@property (nonatomic, strong) UIColor *originOtherButtonColor;

@end

@implementation QGAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    self.width = DEFAULT_ALERT_WIDTH;
    self.height = DEFAULT_ALERT_HEIGHT;
    
    self = [super initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (self) {
        // Initialization code
        
        self.backgroundColor = APPBackgroundColor;
        self.borderWidth = QGOnePixelLineHeight/2;
        self.borderColor = QGCellbottomLineColor;
        self.clipsToBounds = YES;
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        self.cornerRadius = 6;
        [self setupItems];
    }
    return self;
}

- (void)setupItems
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Setup Title Label
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = QGTitleColor;
    
    // Setup Message Label
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.text = self.message;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = QGCellContentColor;;
    
    //Setup Cancel Button
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    [self.cancelButton setTitleColor:QGMainRedColor forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Setup Other Button
    self.otherButton.backgroundColor = [UIColor whiteColor];
    [self.otherButton setTitleColor:QGMainRedColor forState:UIControlStateNormal];
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
    [self.otherButton addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set up Seperator
    self.horizontalSeparator = [UIView new];
    self.horizontalSeparator.backgroundColor = QGCellbottomLineColor;
    self.verticalSeparator = [UIView new];
    self.verticalSeparator.backgroundColor = QGCellbottomLineColor;
    
    

    self.titleLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
    self.messageLabel.textColor = QGCellContentColor;
    
    self.cancelButton.titleColor = QGMainRedColor;
    self.cancelButton.titleFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
    
    self.otherButton.titleColor = QGMainRedColor;
    self.otherButton.titleFont = self.cancelButton.titleFont;
    
    self.topRedView = [UIView new];
    _topRedView.backgroundColor = QGMainRedColor;
    
    
    [self addSubview:_topRedView];
    [self addSubview:_titleLabel];
    [self addSubview:_messageLabel];
    [self addSubview:_cancelButton];
    [self addSubview:_otherButton];
    [self addSubview:_horizontalSeparator];
    [self addSubview:_verticalSeparator];
}

- (void)show
{
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    
    self.blackOpaqueView = [[UIView alloc] initWithFrame:window.bounds];
    self.blackOpaqueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [window addSubview:self.blackOpaqueView];
    
    [self setupConstraint];
    
    NSTimeInterval timeAppear = 0.2;
    NSTimeInterval timeDelay = 0;
    
    [window addSubview:self];
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = .6;
    [UIView animateWithDuration:timeAppear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished){
        
    }];

}

- (void)setupConstraint{
    
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat slefHeight = 0.0;
    
    [_topRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(self.cornerRadius/2));
    }];
    
    if (_title) {
        [_titleLabel sizeToFit];
        CGFloat titleHeight = _titleLabel.height;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(BLUThemeMargin * 6);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.centerX.equalTo(self);
            make.height.equalTo(@(titleHeight));
        }];
        slefHeight += titleHeight;
        slefHeight += BLUThemeMargin * 5;
    }
    
    if (_title && _message) {
       CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(self.width - 24, CGFLOAT_MAX)];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(BLUThemeMargin * 3);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.centerX.equalTo(self);
            make.height.equalTo(@(messageSize.height));
        }];
        slefHeight += messageSize.height;
        slefHeight += BLUThemeMargin * 3;
    }else if(_message){
        CGSize messageSize = [_messageLabel sizeThatFits:CGSizeMake(self.width - 24, CGFLOAT_MAX)];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(BLUThemeMargin * 6);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.centerX.equalTo(self);
            make.height.equalTo(@(messageSize.height));
        }];
        slefHeight += messageSize.height;
        slefHeight += BLUThemeMargin * 6;
    }

    if (_message) {
        [_horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_messageLabel.mas_bottom).offset(BLUThemeMargin * 5);
            make.left.right.equalTo(self);
            make.height.equalTo(@(QGOnePixelLineHeight));
        }];
            slefHeight += BLUThemeMargin * 5;
    }else{
        [_horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(16);
            make.left.right.equalTo(self);
            make.height.equalTo(@(QGOnePixelLineHeight));
            
        }];
            slefHeight += 16;
    }

    slefHeight += _horizontalSeparator.height;

    
    if (_otherButtonTitle && _cancelButtonTitle) {
        
        [_verticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_horizontalSeparator.mas_bottom);
            make.width.equalTo(@(QGOnePixelLineHeight));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [_otherButton sizeToFit];
        [_otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_horizontalSeparator.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(_verticalSeparator);
            make.bottom.equalTo(self);
        }];
        
        [_cancelButton sizeToFit];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_horizontalSeparator.mas_bottom);
            make.left.equalTo(_verticalSeparator.mas_right);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        slefHeight += _cancelButton.height;
        
    }else{
        
        if (_otherButtonTitle) {
            [_otherButton sizeToFit];
            [_otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_horizontalSeparator.mas_bottom);
                make.left.equalTo(self);
                make.right.equalTo(self);
                  make.bottom.equalTo(self);
            }];
            slefHeight += _otherButton.height;
        }else{
            [_cancelButton sizeToFit];
            [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_horizontalSeparator.mas_bottom);
                make.left.equalTo(self);
                make.right.equalTo(self);
                  make.bottom.equalTo(self);
            }];
            slefHeight += _cancelButton.height;
        }
    }
    
    slefHeight += 16;
    
    self.frame = CGRectMake((window.frame.size.width - self.frame.size.width )/2, (window.frame.size.height - slefHeight) /2, self.frame.size.width, slefHeight);
}


- (void)dismiss
{
    NSTimeInterval timeDisappear = 0.08;
    NSTimeInterval timeDelay = .02;
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:timeDisappear delay:timeDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.blackOpaqueView.alpha = 0;
        self.alpha = .0;
    } completion:^(BOOL finished){
        [self.blackOpaqueView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Actions

- (void)actionWithBlocksCancelButtonHandler:(void (^)(void))cancelHandler otherButtonHandler:(void (^)(void))otherHandler
{
    self.cancelButtonAction = cancelHandler;
    self.otherButtonAction = otherHandler;
}

- (void)cancelButtonClicked:(id)sender
{
    
    [self dismiss];
    
    if (self.cancelButtonAction) {
        self.cancelButtonAction();
    }

}

- (void)otherButtonClicked:(id)sender
{
    
        [self dismiss];
    
    if (self.otherButtonAction) {
        self.otherButtonAction();
    }

}

@end
