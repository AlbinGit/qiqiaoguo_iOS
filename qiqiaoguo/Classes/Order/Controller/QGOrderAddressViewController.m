//
//  QGOrderAddressViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/26.
//
//

#import "QGOrderAddressViewController.h"
#import "QGAddressSelectViewController.h"
#import "QGAddressModel.h"
#import "QGHttpManager+ShopCar.h"
#import "QGHttpManager.h"

@interface QGOrderAddressViewController () <UITextFieldDelegate,QGAddressSelectViewControllerDelegate>

@property (nonatomic, strong)UILabel *consigneeLabel;
@property (nonatomic, strong)UITextField *userNameField;
@property (nonatomic, strong)UILabel *DisplayModeLabel;
@property (nonatomic, strong)UITextField *phoneNumField;
@property (nonatomic, strong)UILabel *regionLabel;
@property (nonatomic, strong)UITextField *regionField;
@property (nonatomic, strong)UIButton *districtButton;

@property (nonatomic, strong)UILabel *AddressLabel;
@property (nonatomic, strong)UITextField *AddressField;

@property (nonatomic, strong)UIView *lineView1;
@property (nonatomic, strong)UIView *lineView2;
@property (nonatomic, strong)UIView *lineView3;
@property (nonatomic, strong)UIView *bottomView;


@end

@implementation QGOrderAddressViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"编辑收货地址";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
     target:self
     action:@selector(save)];
    
    [self configUI];
    [self validate];
    
    
}

- (void)configUI{
    
    _consigneeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _consigneeLabel.textColor = QGMainContentColor;
    _consigneeLabel.text = @"收货人:";
    
    _userNameField = [UITextField new];
    _userNameField.font = _consigneeLabel.font;
    _userNameField.textColor = QGTitleColor;
    [_userNameField
     addTarget:self
     action:@selector(updateAddress)
     forControlEvents:UIControlEventEditingChanged];
    
    _DisplayModeLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _DisplayModeLabel.textColor = QGMainContentColor;
    _DisplayModeLabel.text = @"联系方式:";
    
    _phoneNumField = [UITextField new];
    _phoneNumField.font = _consigneeLabel.font;
    _phoneNumField.textColor = QGTitleColor;
    [_phoneNumField
     addTarget:self
     action:@selector(updateAddress)
     forControlEvents:UIControlEventEditingChanged];
    
    _regionLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _regionLabel.textColor = QGMainContentColor;
    _regionLabel.text = @"所在地区:";
    
    _regionField = [UITextField new];
    _regionField.tag = 3;
    _regionField.delegate = self;
    _regionField.font = _consigneeLabel.font;
    _regionField.textColor = QGTitleColor;
    
    _AddressLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _AddressLabel.textColor = QGMainContentColor;
    _AddressLabel.text = @"详细地址:";
    
    _AddressField = [UITextField new];
    _AddressField.font = _consigneeLabel.font;
    _AddressField.textColor = QGTitleColor;
    [_AddressField
     addTarget:self
     action:@selector(updateAddress)
     forControlEvents:UIControlEventEditingChanged];
    
    _districtButton = [UIButton new];
    [_districtButton
     addTarget:self
     action:@selector(tapAndShowAddressSelector:)
     forControlEvents:UIControlEventTouchUpInside];
    
    _lineView1 = [UIView new];
    _lineView1.backgroundColor = QGCellbottomLineColor;
    _lineView2 = [UIView new];
    _lineView2.backgroundColor = QGCellbottomLineColor;
    _lineView3 = [UIView new];
    _lineView3.backgroundColor = QGCellbottomLineColor;
    _bottomView = [UIView new];
    _bottomView.backgroundColor = APPBackgroundColor;
    
    [self.view addSubview:_consigneeLabel];
    [self.view addSubview:_userNameField];
    [self.view addSubview:_DisplayModeLabel];
    [self.view addSubview:_phoneNumField];
    [self.view addSubview:_regionLabel];
    [self.view addSubview:_regionField];
    [_regionField addSubview:_districtButton];
    [self.view addSubview:_AddressLabel];
    [self.view addSubview:_AddressField];
    [self.view addSubview:_lineView1];
    [self.view addSubview:_lineView2];
    [self.view addSubview:_lineView3];
    [self.view addSubview:_bottomView];
  
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateUI];
    
    [_consigneeLabel sizeToFit];
    _consigneeLabel.X = BLUThemeMargin * 4;
    _consigneeLabel.Y = BLUThemeMargin * 3;
    
    _userNameField.X = _consigneeLabel.maxX + BLUThemeMargin;
    _userNameField.Y = _consigneeLabel.Y;
    _userNameField.height = _consigneeLabel.height;
    _userNameField.width = self.view.width - _consigneeLabel.width - BLUThemeMargin * 6;
    
    _lineView1.X = 0;
    _lineView1.Y = _consigneeLabel.maxY + BLUThemeMargin  * 3;
    _lineView1.width = self.view.width;
    _lineView1.height = QGOnePixelLineHeight;
    
    [_DisplayModeLabel sizeToFit];
    _DisplayModeLabel.X = _consigneeLabel.X;
    _DisplayModeLabel.Y = _lineView1.maxY + BLUThemeMargin * 3;
    
    _phoneNumField.X = _DisplayModeLabel.maxX + BLUThemeMargin;
    _phoneNumField.Y = _DisplayModeLabel.Y;
    _phoneNumField.height = _DisplayModeLabel.height;
    _phoneNumField.width = self.view.width - _DisplayModeLabel.width - BLUThemeMargin * 6;
    
    _lineView2.X = 0;
    _lineView2.Y = _DisplayModeLabel.maxY + BLUThemeMargin  * 3;
    _lineView2.width = self.view.width;
    _lineView2.height = QGOnePixelLineHeight;
    
    [_regionLabel sizeToFit];
    _regionLabel.X = _consigneeLabel.X;
    _regionLabel.Y = _lineView2.maxY + BLUThemeMargin * 3;
    
    _regionField.X = _regionLabel.maxX + BLUThemeMargin;
    _regionField.Y = _regionLabel.Y;
    _regionField.height = _regionLabel.height;
    _regionField.width = self.view.width - _regionLabel.width - BLUThemeMargin * 6;
    
    self.districtButton.frame = self.regionField.bounds;
    
    _lineView3.X = 0;
    _lineView3.Y = _regionLabel.maxY + BLUThemeMargin  * 3;
    _lineView3.width = self.view.width;
    _lineView3.height = QGOnePixelLineHeight;
    
    [_AddressLabel sizeToFit];
    _AddressLabel.X = _consigneeLabel.X;
    _AddressLabel.Y = _lineView3.maxY + BLUThemeMargin * 3;

    _AddressField.X = _AddressLabel.maxX + BLUThemeMargin;
    _AddressField.Y = _AddressLabel.Y;
    _AddressField.height = _AddressLabel.height;
    _AddressField.width = self.view.width - _AddressLabel.width - BLUThemeMargin * 6;
    
    _bottomView.X = 0;
    _bottomView.Y = _AddressLabel.maxY + BLUThemeMargin * 3;
    _bottomView.width = self.view.width;
    _bottomView.height = self.view.height - _AddressLabel.maxY - BLUThemeMargin * 3;
    
}

- (void)setAddress:(QGAddressModel *)address{
    _address = address;
    if (address == nil) {
        _address = [QGAddressModel new];
    }
    [self updateOldDistrictIDsWithAddress:address];
    if (address) {
        self.phoneNumField.text = address.phone;
        self.userNameField.text = address.contact;
        self.AddressField.text = address.details;
        self.regionField.text = address.fullAddress;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)updateUI {
    if (self.address) {
        self.userNameField.text = self.address.contact;
        self.phoneNumField.text = self.address.phone;
        
        NSMutableString *district = [NSMutableString new];
        
        NSString *province = self.address.provinceDetail;
        NSString *city = self.address.cityDetail;
        NSString *county = self.address.areaDetail;
        
        if (province) {
            [district appendFormat:@"%@ ", province];
        }
        if (city) {
            [district appendFormat:@"%@ ", city];
        }
        if (county) {
            [district appendFormat:@"%@", county];
        }
        
        if(district.length < 1){
            if (self.address.province) {
                [district appendFormat:@"%@ %@ %@",self.address.province,self.address.city,self.address.area ];
            }else{
                district = nil;
            }
        }
        
        self.regionField.text = district;
        self.AddressField.text = self.address.details;
    }
    [self validate];
}

#pragma mark - Action

- (void)save{
    @weakify(self);
    [QGHttpManager saveAddressDetailsWithAddress:_address Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        if (responseObject[@"id"] != nil) {
            self.address.addressID = responseObject[@"id"];
        }
        if ([self.delegate respondsToSelector:
             @selector(logisticsEditViewController:updateAddressSuccess:)]) {
            [self.delegate logisticsEditViewController:self
                                  updateAddressSuccess:self.address];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
//        if ([self.delegate respondsToSelector:
//             @selector(logisticsEditViewController:updateAddressFailed:)]) {
//            [self.delegate logisticsEditViewController:self updateAddressFailed:error];
//        }
    }];
    
}

- (void)tapAndShowAddressSelector:(UIButton *)button {
    [self tapAndResign:nil];
    
    QGAddressSelectViewController *vc = [QGAddressSelectViewController new];
    vc.delegate = self;
    vc.address = self.address;
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    vc.view.alpha = 0.0;
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        vc.view.alpha = 1.0;
    }];

}

- (void)tapAndResign:(id)sender {
    [self.userNameField resignFirstResponder];
    [self.phoneNumField resignFirstResponder];
    [self.regionField resignFirstResponder];
    [self.AddressField resignFirstResponder];
}

- (void)validate {
    if (self.userNameField.text.length > 0 &&
        self.phoneNumField.text.length > 0 &&
        self.regionField.text.length > 0 &&
        self.AddressField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)updateAddress {
    self.address.contact = self.userNameField.text;
    self.address.phone = self.phoneNumField.text;
    self.address.details = self.AddressField.text;
    [self validate];
}



- (void)updateOldDistrictIDsWithAddress:(QGAddressModel *)address {
    NSMutableArray *districtIDs = [NSMutableArray new];
    
    if (address.provinceID) {
        [districtIDs addObject:address.provinceID];
    }
    if (address.cityID) {
        [districtIDs addObject:address.cityID];
    }
    if (address.countyID) {
        [districtIDs addObject:address.countyID];
    }
    
    self.oldDistrictIDs = districtIDs;
}

- (void)updateAddressDistrictIDs:(NSArray *)districtIDs {
    NSInteger districtLevel = [QGAddressModel districtLevel];
    for (NSUInteger i = 0; i < districtIDs.count && i < districtLevel; ++i) {
        switch (i) {
            case 0: {
                self.address.provinceID = districtIDs[0];
            } break;
            case 1: {
                self.address.cityID = districtIDs[1];
            } break;
            case 2: {
                self.address.countyID = districtIDs[2];
            } break;
        }
    }
    
    for (NSUInteger i = districtIDs.count; i < districtLevel; ++i) {
        switch (i) {
            case 0: {
                self.address.provinceID = nil;
            } break;
            case 1: {
                self.address.cityID = nil;
            } break;
            case 2: {
                self.address.countyID = nil;
            } break;
        }
    }
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        return NO;
    }
    return YES;
}

#pragma mark - QGAddressSelectViewControllerDelegate

- (void)addressSelectorVCCancelUpdateDistrictIDs:(QGAddressSelectViewController *)vc {
    [self updateAddressDistrictIDs:self.oldDistrictIDs];
    [self updateUI];
}

- (void)addressSelectorVC:(QGAddressSelectViewController *)vc
     didUpdateDistrictIDs:(NSArray *)districtIDs {
    [self updateAddressDistrictIDs:districtIDs];
    [self updateUI];
}

- (void)addressSelectorVCFinishUpdateDistrictIDs:(QGAddressSelectViewController *)vc {
    [self updateOldDistrictIDsWithAddress:self.address];
}




@end
