//
//  QGSelectOrderCancelReasonViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGSelectOrderCancelReasonViewController.h"

@interface QGSelectOrderCancelReasonViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,strong)UIPickerView *pickView;
@property (nonatomic, copy) NSString *reason;

@end

@implementation QGSelectOrderCancelReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cannel)];
    
    [self.view addGestureRecognizer:tap];
    self.pickView = [UIPickerView new];
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickView];
    self.pickView.frame = CGRectMake(0, self.view.height - 260, self.view.width, 216);
    
    self.pickView.delegate = self;
    self.pickView.dataSource =self;
    
    UIToolbar *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.height - 304, self.view.width, 44)];
    UIBarButtonItem *donebtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    donebtn.tintColor = QGMainContentColor;
    UIBarButtonItem *specebtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    tool.items = @[specebtn,donebtn];
    [self.view addSubview:tool];
    
}

- (void)done{
    @weakify(self);
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        @strongify(self);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(SelectOrderCancelReason:andType:)]) {
            [self.delegate SelectOrderCancelReason:self.reason andType:self.type];
        }
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];

    }];
}

- (void)cannel{
    [UIView animateWithDuration:BLUThemeNormalAnimeDuration animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.pickViewDataArray.count;
}

#pragma mark UIPickerView Delegate Method 代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickViewDataArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.reason = _pickViewDataArray[row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    label.textColor = QGTitleColor;
    label.textAlignment =  NSTextAlignmentCenter;
    label.text = self.pickViewDataArray[row];
    return label;
}

-(void)setPickViewDataArray:(NSArray *)pickViewDataArray{
    _pickViewDataArray = pickViewDataArray;
    _reason = [_pickViewDataArray firstObject];
    [self.pickView reloadAllComponents];
}

@end
