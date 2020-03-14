//
//  QGAddressSelectViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/27.
//
//

#import "QGAddressSelectViewController.h"
#import "BLUAddressManager.h"

@interface QGAddressSelectViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,strong)UIPickerView *pickView;

@property (nonatomic) NSMutableArray *districts;
@property (nonatomic) BLUAddressManager *addressManager;
@end

@implementation QGAddressSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"999999" alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cannel)];
    
    [self.view addGestureRecognizer:tap];
    self.pickView = [UIPickerView new];
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickView];
    self.pickView.frame = CGRectMake(0, self.view.height - 260, self.view.width, 216);
    
    self.pickView.delegate = self;
    self.pickView.dataSource =self;
    
    UIToolbar *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.height - 304, self.view.width, 44)];
    tool.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *donebtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    donebtn.tintColor = QGMainContentColor;
    UIBarButtonItem *specebtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    tool.items = @[specebtn,donebtn];
    [self.view addSubview:tool];
    
    if (self.address) {
        NSMutableArray *districts = [NSMutableArray new];
        _districts = districts;
        NSArray *proviceDistricts =
        [self.addressManager districtsWithParrentID:@(0)];
        NSArray *cityDistricts = nil;
        NSArray *countyDistricts = nil;
        [districts addObject:proviceDistricts];
        
        if (self.address.provinceID) {
            cityDistricts =
            [self.addressManager districtsWithParrentID:self.address.provinceID];
            [districts addObject:cityDistricts];
        } else {
            NSDictionary *proviceDistrict = proviceDistricts.firstObject;
            cityDistricts =
            [self.addressManager districtsWithParrentID:
             [self districtIDForDistrict:proviceDistrict]];
            [districts addObject:cityDistricts];
        }
        
        if (self.address.cityID) {
            countyDistricts =
            [self.addressManager districtsWithParrentID:self.address.cityID];
            [districts addObject:countyDistricts];
        } else {
            NSDictionary *countyDistrict = cityDistricts.firstObject;
            countyDistricts =
            [self.addressManager districtsWithParrentID:
             [self districtIDForDistrict:countyDistrict]];
            [districts addObject:countyDistricts];
        }
        
        NSInteger provinceRow = -1;
        NSInteger cityRow = -1;
        NSInteger countyRow = -1;
        
        NSInteger (^getParedDistrictID)(NSInteger , NSArray *) =
        ^NSInteger(NSInteger targetID, NSArray *componentDistricts) {
            __block NSInteger paredDistrictID = -1;
            
            [componentDistricts enumerateObjectsUsingBlock:^(NSDictionary *district,
                                                             NSUInteger idx,
                                                             BOOL * _Nonnull stop) {
                NSNumber *districtID = [self districtIDForDistrict:district];
                if (districtID.integerValue == targetID) {
                    paredDistrictID = idx;
                    *stop = YES;
                }
            }];
            
            return paredDistrictID;
        };
        
        if (self.address.provinceID) {
            provinceRow = getParedDistrictID(self.address.provinceID.integerValue,
                                             proviceDistricts);
        }
        
        if (self.address.cityID) {
            cityRow = getParedDistrictID(self.address.cityID.integerValue,
                                         cityDistricts);
        }
        
        if (self.address.countyID) {
            countyRow = getParedDistrictID(self.address.countyID.integerValue,
                                           countyDistricts);
        }
        
        [self.pickView reloadAllComponents];
        
        if (provinceRow > 0) {
            NSInteger proviceComponent =
            [districts indexOfObject:proviceDistricts];
            [self.pickView selectRow:provinceRow
                           inComponent:proviceComponent
                              animated:YES];
        }
        
        if (cityRow > 0) {
            NSInteger cityComponent =
            [districts indexOfObject:cityDistricts];
            [self.pickView selectRow:cityRow
                           inComponent:cityComponent
                              animated:YES];
        }
        
        if (countyRow > 0) {
            NSInteger countyComponent =
            [districts indexOfObject:countyDistricts];
            [self.pickView selectRow:countyRow
                           inComponent:countyComponent
                              animated:YES];
        }
        
        [self didUpdateDistrictIDs:[self generateDistrictIDsForPickerView:self.pickView]];
    } else {
        NSArray *districts = [self districtsForParentID:@(0)];
        _districts = [NSMutableArray arrayWithArray:districts];
        [self updateDistritIDsForFirstTime];
        [self.pickView reloadAllComponents];
    }

}

- (void)didUpdateDistrictIDs:(NSArray *)districtIDs {
    if ([self.delegate respondsToSelector:
         @selector(addressSelectorVC:didUpdateDistrictIDs:)]) {
        [self.delegate addressSelectorVC:self
                    didUpdateDistrictIDs:districtIDs];
    }
}

- (void)done{
    [self dismiss];
    if ([self.delegate respondsToSelector:
         @selector(addressSelectorVCFinishUpdateDistrictIDs:)]) {
        [self.delegate addressSelectorVCFinishUpdateDistrictIDs:self];
    }
}

- (void)cannel{
    [self dismiss];
    if ([self.delegate respondsToSelector:
         @selector(addressSelectorVCCancelUpdateDistrictIDs:)]) {
        [self.delegate addressSelectorVCCancelUpdateDistrictIDs:self];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (BLUAddressManager *)addressManager {
    if (_addressManager == nil) {
        _addressManager = [BLUAddressManager sharedManager];
    }
    return _addressManager;
}

- (void)updateDistritIDsForFirstTime {
    NSMutableArray *districtIDs = [NSMutableArray new];
    for (NSArray *componentDistricts in self.districts) {
        NSDictionary *district = componentDistricts.firstObject;
        NSNumber *districtID = [self districtIDForDistrict:district];
        if (districtID) {
            [districtIDs addObject:districtID];
        } else {
            break;
        }
    }
    
    [self didUpdateDistrictIDs:districtIDs];
}

- (NSArray *)districtsForParentID:(NSNumber *)districtID {
    NSMutableArray *districts = [NSMutableArray new];
    
    NSNumber *parentID = districtID;
    
    while (1) {
        if (parentID) {
            NSArray *componentDistricts =
            [self.addressManager districtsWithParrentID:parentID];
            
            if (componentDistricts.count > 0) {
                [districts addObject:componentDistricts];
                NSDictionary *district = componentDistricts.firstObject;
                parentID = [self districtIDForDistrict:district];
            } else {
                parentID = nil;
            }
        } else {
            break;
        }
    }
    
    return districts;
}

- (NSNumber *)districtIDForDistrict:(NSDictionary *)districts {
    return districts[[BLUAddressManager districtIDColumn]];
}

- (NSString *)nameForDistrict:(NSDictionary *)districts {
    return districts[[BLUAddressManager nameColumn]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.districts.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    NSArray *districts = self.districts[component];
    return districts.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    NSArray *districts = self.districts[component];
    NSDictionary *district = districts[row];
    return [self nameForDistrict:district];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    NSMutableArray *allDistricts = [NSMutableArray new];
    
    for (NSUInteger i = 0; i <= component; ++i) {
        [allDistricts addObject:self.districts[i]];
    }
    
    NSArray *districts = self.districts[component];
    NSDictionary *district = districts[row];
    NSNumber *districtID = [self districtIDForDistrict:district];
    
    NSArray *changedDistricts = [self districtsForParentID:districtID];
    
    if (changedDistricts.count > 0) {
        [allDistricts addObjectsFromArray:changedDistricts];
    }
    self.districts = allDistricts;
    [pickerView reloadAllComponents];
    
    
    
    [self didUpdateDistrictIDs:[self generateDistrictIDsForPickerView:pickerView]];
}

- (NSArray *)generateDistrictIDsForPickerView:(UIPickerView *)pickerView {
    NSMutableArray *districtIDs = [NSMutableArray new];
    
    NSUInteger numberOfCompontents = [[pickerView dataSource]
                                      numberOfComponentsInPickerView:pickerView];
    
    for (NSUInteger i = 0; i < numberOfCompontents; ++i) {
        NSUInteger selectedRow = [pickerView selectedRowInComponent:i];
        NSArray *compontentDistricts = self.districts[i];
        NSDictionary *district = compontentDistricts[selectedRow];
        NSNumber *districtID = [self districtIDForDistrict:district];
        [districtIDs addObject:districtID];
    }
    
    return districtIDs;
}

@end
