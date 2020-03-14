//
//  QGActSignSaveViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/3.
//
//

#import "QGActSignSaveViewController.h"
#import "QGContact.h"
#import "QGActSignCell.h"
#import "QGNearActSignModel.h"
@interface QGActSignSaveViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)NSMutableDictionary *infoDic;
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,copy) NSMutableString *lenghStr;
@end

@implementation QGActSignSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createReturnButton];
    [self createNavTitle:@"编辑联系人"];
    [self createNavRightBtn:@"保存"];
    _infoDic = [NSMutableDictionary dictionary];
    PL_CODE_WEAK(weakSelf)
    self.view.backgroundColor =COLOR(243, 243, 243, 1);

    [self.rightBtn addClick:^(SAButton *button) {
        
        [weakSelf goSignUp];
        ;
    }];
    
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,self.navImageView.maxY , SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = COLOR(242, 243, 244, 1);
       // _tableView.bounces = NO;
        _tableView.separatorStyle = NO;
        [self.view addSubview:_tableView];
   
        
   
}



- (void)goSignUp {
    [self.view endEditing:YES];
    _lenghStr = [[NSMutableString alloc] init];
    

    
    for ( QGActlistQuantityModel *mm in _applyFieldList) {
        
       NSString *str = [_infoDic objectForKey:mm.id];
        _lenghStr = str;
        
    }
    NSLog(@"ssssoooosss %@",_infoDic);
    if (_infoDic.count == _applyFieldList.count && _lenghStr.length>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContact" object:nil];
        if ([_delegate respondsToSelector:@selector(addViewController:didAddContact:)]) {
            [_delegate addViewController:self didAddContact:_infoDic];
        }
        // 回到联系控制器
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        [self  showTopIndicatorWithWarningMessage:@"亲！请完善内容"] ;
    }
   
    
}



#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _applyFieldList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    QGActSignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[QGActSignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    QGNearActSignModel *model = _applyFieldList[indexPath.row];
    // QGActlistQuantityModel *mm = [QGActlistQuantityModel mj_objectWithKeyValues:_applyArr];
     NSArray *userArray = [QGActlistQuantityModel mj_objectArrayWithKeyValuesArray:_applyArr];
       BLUUser *user = [BLUAppManager sharedManager].currentUser;
    
    if([model.name isEqualToString:@"姓名"]) {
        
        cell.textField.text  = user.nickname;
        
        [_infoDic setObject:cell.textField.text forKey:model.id];
        }else if ([model.name  isEqualToString:@"手机"]){
        
         cell.textField.text = user.mobile;
         [_infoDic setObject:cell.textField.text forKey:model.id];
        
    }
    for ( QGActlistQuantityModel *mm in userArray) {
        
        if ([model.id isEqualToString:mm.id]) {
             cell.textField.text = mm.value;
               [_infoDic setObject:cell.textField.text forKey:mm.id];
        }
       
    }

    cell.applyArr = _applyArr;
    cell.signModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row + 333;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    QGNearActSignModel *sModel = _applyFieldList[textField.tag - 333];
    if (textField.text.length>0) {
         [_infoDic setObject:textField.text forKey:sModel.id];
    }else {
        
        [_infoDic removeObjectForKey:sModel.id];
    }
 
   
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
