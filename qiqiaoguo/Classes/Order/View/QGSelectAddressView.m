//
//  QGSelectAddressView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGSelectAddressView.h"

@interface QGSelectAddressView ()

@property (nonatomic, strong)UILabel *shippingAddressLabel;
@property (nonatomic, strong)UILabel *UserinfoLabel;
@property (nonatomic, strong)UILabel *AddressDetailLabel;
@property (nonatomic, strong)UIImageView *arrowImage;
@property (nonatomic, strong)UIButton *idCardEditorButton;
@property (nonatomic, strong)UIView *bottmLineView;
@property (nonatomic, strong)UIView *BackgrandView;

@end

@implementation QGSelectAddressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _shippingAddressLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _shippingAddressLabel.text = @"收货地址:";
        _shippingAddressLabel.textColor = QGMainContentColor;
        
        _UserinfoLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _UserinfoLabel.textColor = QGMainRedColor;
        _UserinfoLabel.text = @"未添加";
        
        _AddressDetailLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _AddressDetailLabel.numberOfLines = 2;
        _AddressDetailLabel.text = @"                                   ";
        _AddressDetailLabel.textColor = QGCellContentColor;
        
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow_icon"]];
        
        _idCardTextField = [[UITextField alloc]init];
        _idCardTextField.backgroundColor = [UIColor whiteColor];
        _idCardTextField.font = [UIFont systemFontOfSize:14];
        _idCardTextField.cornerRadius = 5;
        _idCardTextField.placeholder = @"  身份证号码(海关部门要求收货人与身份证号码匹配)";
        _idCardTextField.returnKeyType = UIReturnKeyDone;
        [_idCardTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        
//        _idCardTextButton = [UIButton new];
//        _idCardTextButton.titleFont = [UIFont systemFontOfSize:15];
//        _idCardTextButton.title = @"保存";
//        [_idCardTextButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        _idCardTextButton.cornerRadius = 5;
//        [_idCardTextButton setTitleColor:QGCellContentColor forState:UIControlStateDisabled];
//        [_idCardTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_idCardTextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"c1c1c1"] ] forState:UIControlStateDisabled];
//        [_idCardTextButton setBackgroundImage:[UIImage imageWithColor:QGMainRedColor] forState:UIControlStateNormal];
//        _idCardTextButton.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
//        
//        
//        
//        _idCardEditorButton = [UIButton new];
//        _idCardEditorButton.image = [UIImage imageNamed:@"idCard_icon"];
//        [_idCardEditorButton addTarget:self action:@selector(EditorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _bottmLineView = [UIView new];
        _bottmLineView.backgroundColor = QGTitleColor;
        
        _BackgrandView = [UIView new];
        _BackgrandView.backgroundColor = APPBackgroundColor;
        
        _idCardEditorButton.hidden = YES;
        _bottmLineView.hidden = YES;
        
        _SelectAddressButton = [UIButton new];
        
        [self addSubview:_BackgrandView];
        [self addSubview:_shippingAddressLabel];
        [self addSubview:_UserinfoLabel];
        [self addSubview:_AddressDetailLabel];
        [self addSubview:_arrowImage];
        [self addSubview:_idCardTextField];
        [self addSubview:_bottmLineView];
        [self addSubview: _idCardTextButton];
        [self addSubview:_idCardEditorButton];
        [self addSubview:_SelectAddressButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [_shippingAddressLabel sizeToFit];
    _shippingAddressLabel.X = BLUThemeMargin * 4;
    _shippingAddressLabel.Y = BLUThemeMargin * 4;
    
    [_UserinfoLabel sizeToFit];
    _UserinfoLabel.X = _shippingAddressLabel.maxX + BLUThemeMargin* 2;
    _UserinfoLabel.Y = _shippingAddressLabel.Y;
    
    [_arrowImage sizeToFit];
    _arrowImage.X = self.width - _arrowImage.width - BLUThemeMargin * 4;
    
    [_AddressDetailLabel sizeToFit];
    CGSize AddressSize = [_AddressDetailLabel sizeThatFits:CGSizeMake(_arrowImage.x - _UserinfoLabel.X , MAXFLOAT)];
    _AddressDetailLabel.X = _UserinfoLabel.X;
    _AddressDetailLabel.Y = _UserinfoLabel.maxY + BLUThemeMargin;
    _AddressDetailLabel.width = AddressSize.width;
    _AddressDetailLabel.height = _UserinfoLabel.height * 2;

    _arrowImage.centerY = (_AddressDetailLabel.maxY + BLUThemeMargin * 4)/2;
    
    _BackgrandView.X = 0;
    _BackgrandView.Y = _AddressDetailLabel.maxY + BLUThemeMargin *4;
    _BackgrandView.width = self.width;
    
    _idCardTextField.X = BLUThemeMargin * 4;
    _idCardTextField.Y = _BackgrandView.Y + 6;
    
//    [_idCardTextButton sizeToFit];
//    _idCardTextButton.X = self.width - _idCardTextButton.width - BLUThemeMargin * 4;
//    _idCardTextButton.centerY = _idCardTextField.centerY;
    
    _idCardTextField.height = 30;
    _idCardTextField.width = self.width - BLUThemeMargin * 8;
    
    if (self.type == QGConfirmOrderTypeGlobal || self.type == QGConfirmOrderTypeGlobalAndBuyNow) {
        
        _BackgrandView.height = _idCardTextField.height + BLUThemeMargin * 3;
        _idCardTextField.hidden = NO;
//        _idCardTextButton.hidden = NO;
    }else{
        _BackgrandView.height = 10;
        _idCardEditorButton.hidden = YES;
        _idCardTextField.hidden = YES;
        _idCardTextButton.hidden = YES;
        _bottmLineView.hidden = YES;
    }
    
    
    _SelectAddressButton.X = 0;
    _SelectAddressButton.Y = 0;
    _SelectAddressButton.width = self.width;
    _SelectAddressButton.height = _AddressDetailLabel.maxY;
    
    [_idCardEditorButton sizeToFit];
    _idCardEditorButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _idCardEditorButton.x = self.width - _idCardEditorButton.width - BLUThemeMargin * 4;
    _idCardEditorButton.centerY = _idCardTextField.centerY;
    
    _bottmLineView.x = _idCardEditorButton.x - BLUThemeMargin * 4;
    _bottmLineView.centerY = _idCardTextField.centerY;
    _bottmLineView.height = 30;
    _bottmLineView.width = QGOnePixelLineHeight;
    
    _headHeight = _BackgrandView.maxY;
    
}

- (void)setAddress:(QGAddressModel *)address{
    _address = address;
    if (address.details) {
        _UserinfoLabel.text = [NSString stringWithFormat:@"%@  %@",address.contact,address.phone];
        _UserinfoLabel.textColor = QGTitleColor;
        _AddressDetailLabel.text = address.fullAddress;
    }else{
         _UserinfoLabel.text = @"未添加";
        _UserinfoLabel.textColor = QGMainRedColor;
        _AddressDetailLabel.text = nil;
    }
    self.idCardTextField.text = address.idCard;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setType:(QGConfirmOrderType)type{
    
    _type = type;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)saveButtonClick:(UIButton *)button{
    
    self.idCardTextField.enabled = NO;
    self.idCardTextField.backgroundColor = APPBackgroundColor;
    self.idCardTextButton.hidden = YES;
    _idCardEditorButton.hidden = NO;
    _bottmLineView.hidden = NO;
    
}

- (void)EditorButtonClick:(UIButton *)button{
    self.idCardTextField.enabled = YES;
    self.idCardTextField.backgroundColor = [UIColor whiteColor];
    self.idCardTextButton.hidden = NO;
    _idCardEditorButton.hidden = YES;
    _bottmLineView.hidden = YES;
    [self.idCardTextField becomeFirstResponder];
}

@end
