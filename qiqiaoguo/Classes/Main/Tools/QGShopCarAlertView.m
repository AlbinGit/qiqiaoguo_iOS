//
//  QGShopCarAlertView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//



#import "QGShopCarAlertView.h"

#define DEFAULT_ALERT_WIDTH 280
#define DEFAULT_ALERT_HEIGHT 144

@interface QGShopCarAlertView ()

@property (nonatomic, assign) BOOL isordinary;

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

@property (nonatomic, strong) UIButton *SelectButton;
@property (nonatomic, strong) UIButton *SelectButton2;
@property (nonatomic, strong) UILabel  *GlobalGoodsLabel;
@property (nonatomic, strong) UILabel  *GlobalGoodsDetailLabel;
@property (nonatomic, strong) UILabel  *GlobalCountLabel;
@property (nonatomic, strong) UILabel *ordinaryLabel;
@property (nonatomic, strong) UILabel *ordinaryCountLabel;
@property (nonatomic, strong) UIButton *StatusButton;
@property (nonatomic, strong) UIButton *StatusButton2;

@property (nonatomic, strong) UIView *whiteColorView;

@property (nonatomic, assign) NSInteger ordinarycount;
@property (nonatomic, assign) NSInteger Globalcount;

@end

@implementation QGShopCarAlertView

- (instancetype)initWithTitle:(NSString *)title ordinaryCount:(NSInteger)ordinarycount GlobalCount:(NSInteger)Globalcount cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    self.width = DEFAULT_ALERT_WIDTH;
    self.height = DEFAULT_ALERT_HEIGHT;
    
    self = [super initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (self) {
        // Initialization code
        self.ordinarycount = ordinarycount;
        self.Globalcount = Globalcount;
        self.backgroundColor = APPBackgroundColor;
        self.borderWidth = QGOnePixelLineHeight/2;
        self.borderColor = QGCellbottomLineColor;
        self.clipsToBounds = YES;
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        self.cornerRadius = 6;
        [self setupItems];
        [self buttonClick:_SelectButton];
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
    self.messageLabel.textColor = QGCellContentColor;
    
    _whiteColorView = [UIView new];
    _whiteColorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteColorView];
    
    _SelectButton = [UIButton new];
    [_SelectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _SelectButton.tag = 1;
    _SelectButton2 = [UIButton new];
    [_SelectButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _SelectButton2.tag = 2;
    
    _StatusButton = [UIButton new];
    [_StatusButton setImage:[UIImage imageNamed:@"did-select-icon"] forState:UIControlStateSelected];
    [_StatusButton setImage:[UIImage imageNamed:@"no-select-icon"] forState:UIControlStateNormal];
    
    _StatusButton2 = [UIButton new];
    [_StatusButton2 setImage:[UIImage imageNamed:@"did-select-icon"] forState:UIControlStateSelected];
    [_StatusButton2 setImage:[UIImage imageNamed:@"no-select-icon"] forState:UIControlStateNormal];
    
    _GlobalCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
    _GlobalCountLabel.text = [NSString stringWithFormat:@"%ld件",self.Globalcount];
    
    _ordinaryCountLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTime];
    _ordinaryCountLabel.text = [NSString stringWithFormat:@"%ld件",self.ordinarycount];
    
    _GlobalGoodsLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _GlobalGoodsLabel.textColor = QGMainContentColor;
    _GlobalGoodsLabel.text = @"全球购商品";
    
    
    _GlobalGoodsDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _GlobalGoodsDetailLabel.textColor = QGCellContentColor;
    _GlobalGoodsDetailLabel.attributedText = [self configTitle:@"(含  的商品)"];
    
    _ordinaryLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _ordinaryLabel.textColor = QGMainContentColor;
    _ordinaryLabel.text = @"普通商品";
    
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
    
    [self addSubview:_StatusButton];
    [self addSubview:_StatusButton2];
    [self addSubview:_SelectButton];
    [self addSubview:_SelectButton2];
    [self addSubview:_ordinaryLabel];
    [self addSubview:_ordinaryCountLabel];
    [self addSubview:_GlobalGoodsLabel];
    [self addSubview:_GlobalGoodsDetailLabel];
    [self addSubview:_GlobalCountLabel];
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

    
    [_StatusButton sizeToFit];
    [_StatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.top.equalTo(_whiteColorView).offset(BLUThemeMargin * 3);
    }];

    [_GlobalGoodsLabel sizeToFit];
    [_GlobalGoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_StatusButton.mas_right).offset(BLUThemeMargin);
        make.centerY.equalTo(_StatusButton);
        make.height.equalTo(@(_GlobalGoodsLabel.height));
    }];
    
    [_GlobalGoodsDetailLabel sizeToFit];
    [_GlobalGoodsDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_GlobalGoodsLabel.mas_right).offset(BLUThemeMargin);
        make.centerY.equalTo(_GlobalGoodsLabel);
    }];
    
    slefHeight += _GlobalGoodsLabel.height;
    slefHeight += BLUThemeMargin * 5;
    
    [_GlobalCountLabel sizeToFit];
    [_GlobalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_StatusButton.mas_right).offset(BLUThemeMargin);
        make.top.equalTo(_GlobalGoodsLabel.mas_bottom).offset(BLUThemeMargin);
        make.height.equalTo(@(_GlobalCountLabel.height));
    }];
    slefHeight += _GlobalCountLabel.height;
    slefHeight += BLUThemeMargin;
    
    [_StatusButton2 sizeToFit];
    [_StatusButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.top.equalTo(_GlobalCountLabel.mas_bottom).offset(BLUThemeMargin * 3);
    }];
    
    [_ordinaryLabel sizeToFit];
    [_ordinaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_StatusButton2.mas_right).offset(BLUThemeMargin);
        make.centerY.equalTo(_StatusButton2);
         make.height.equalTo(@(_ordinaryLabel.height));
    }];
    
    slefHeight += _ordinaryLabel.height;
    slefHeight += BLUThemeMargin * 3;
    
    [_ordinaryCountLabel sizeToFit];
    [_ordinaryCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_StatusButton2.mas_right).offset(BLUThemeMargin);
        make.top.equalTo(_ordinaryLabel.mas_bottom).offset(BLUThemeMargin);
        make.height.equalTo(@(_ordinaryCountLabel.height));
    }];
    slefHeight += _ordinaryCountLabel.height;
    slefHeight += BLUThemeMargin;
    
    [_whiteColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(BLUThemeMargin * 3);
        make.width.left.right.equalTo(self);
        make.bottom.equalTo(_ordinaryCountLabel).offset(BLUThemeMargin * 5-QGOnePixelLineHeight);
        
    }];
    
    [_SelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_StatusButton);
        make.right.equalTo(_GlobalGoodsDetailLabel);
        make.bottom.equalTo(_GlobalCountLabel);
    }];
    
    [_SelectButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_StatusButton2);
        make.right.equalTo(_GlobalGoodsDetailLabel);
        make.bottom.equalTo(_ordinaryCountLabel);
    }];

    [_horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ordinaryCountLabel.mas_bottom).offset(BLUThemeMargin * 5);
        make.left.right.equalTo(self);
        make.height.equalTo(@(QGOnePixelLineHeight));
    }];
    
    slefHeight += BLUThemeMargin * 7;
    
    
    
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
    
//    slefHeight += BLUThemeMargin * 10;
    
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

- (NSMutableAttributedString *)configTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Global-purchasing-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"Global-purchasing-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //    [attri appendAttributedString:string];
    [attri insertAttributedString:string atIndex:4];
    
    return attri;
}

#pragma mark - Actions

- (void)buttonClick:(UIButton *)button{
    
    if (button.tag == 1) {
        _StatusButton.selected = YES;
        _StatusButton2.selected = NO;
        _isordinary = NO;
    }else{
        _StatusButton2.selected = YES;
        _StatusButton.selected = NO;
        _isordinary = YES;
    }
    
}

- (void)actionWithBlocksCancelButtonHandler:(void (^)(int))cancelHandler otherButtonHandler:(void (^)(void))otherHandler
{
    self.cancelButtonAction = cancelHandler;
    self.otherButtonAction = otherHandler;
}

- (void)cancelButtonClicked:(id)sender
{
    
    [self dismiss];
    
    
    if (self.cancelButtonAction) {
        self.cancelButtonAction(self.isordinary);
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
