//
//  QGActSignSaveViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/3.
//
//

#import "QGEduSignSaveViewController.h"
#import "QGContact.h"
#import "QGActSignCell.h"
#import "QGNearActSignModel.h"
@interface QGEduSignSaveViewController ()<UITextFieldDelegate>
@property (weak, nonatomic)  UITextField *nameField;

@property (weak, nonatomic)  UITextField *phoneField;
@property (nonatomic, strong)UILabel *titLabelName;
@property (nonatomic, strong)UILabel *titLabelPhone;

@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,copy) NSMutableString *lenghStr;
@end

@implementation QGEduSignSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createReturnButton];
    [self createNavTitle:@"编辑联系人"];
    [self createNavRightBtn:@"保存"];
    _nameField.delegate = self;
    _phoneField.delegate = self;
    _phoneField.returnKeyType = UIReturnKeyDone;
    _nameField.returnKeyType = UIReturnKeyDone;
    self.view.backgroundColor = COLOR(242, 243, 244, 1);
    PL_CODE_WEAK(weakSelf)
    BLUUser *user = [BLUAppManager sharedManager].currentUser;
    if(_contact.name) {
        _nameField.text = _contact.name;
        _phoneField.text = _contact.phone;
    }else {
        _nameField.text = user.nickname;
        _phoneField.text =user.mobile;
    }
    [self.rightBtn addClick:^(SAButton *button) {
        [weakSelf goSignUp];
    }];
}



- (void)goSignUp {
    [self.view endEditing:YES];
    // 更新模型
    _contact.name = _nameField.text;
    _contact.phone = _phoneField.text;
    
    QGContact *c =[QGContact contactWithName:_nameField.text phone:_phoneField.text];
    // 通知联系人刷新表格
    // 发出通知
    if (c.name.length>0 && c.phone.length >0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContact" object:nil];
        if ([_delegate respondsToSelector:@selector(addViewController:didAddContact:)]) {
            [_delegate addViewController:self didAddContact:c];
        }
        // 回到联系控制器
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self  showTopIndicatorWithWarningMessage:@"请添加联系人或联系方式"] ;
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
