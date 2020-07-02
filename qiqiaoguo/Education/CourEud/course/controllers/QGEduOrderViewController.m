//
//  QGActOrderViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGEduOrderViewController.h"
#import "QGEduOrderCell.h"
#import "QGActOrderListCell.h"
#import "QGPayResultViewController.h"
#import "QGOrderPayViewController.h"
#import "QGActOrderInfoModel.h"
#import "QGEduSignSaveViewController.h"
#import "QGContact.h"
#import "QGTicklistModel.h"
#import "QGNearActSignModel.h"
#import "QGShoppingCartModel.h"
#import "QGGoodsListModel.h"
@interface QGEduOrderViewController ()<UITableViewDelegate,UITableViewDataSource,QGEduSignSaveViewControllerDelegate,QGEduOrderCellDelegate,UITextViewDelegate>
{
    NSMutableArray *ArrLabel;
    UILabel *label;
    UILabel *label1;
    
}
@property (nonatomic, strong) SASRefreshTableView * tableView;
@property (nonatomic,strong) UILabel *labName;
@property (nonatomic, copy)NSMutableString *signInfo;
@property (nonatomic,strong) QGActOrderInfoModel *model ;

/** 总价*/
@property (strong, nonatomic)  UILabel *totalPriceLabel;
/** 总价*/
@property (strong, nonatomic)  UILabel *totalPriceLabel1;
@property (nonatomic,strong) NSMutableArray *applyArr;
@property (nonatomic,strong) UILabel *callable;
@property (nonatomic,strong) QGActOrderInfoModel *item;
@property (nonatomic,strong)  UIButton  *button;
@property (nonatomic, strong) QGContact *contact;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,copy) NSString *quantity;
@property (nonatomic,strong) NSMutableArray * shoppingCart;
@property (nonatomic,strong) QGShoppingCartModel *shopModel;
@property (nonatomic,strong) NSMutableArray *goodsList;

@end

@implementation QGEduOrderViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self addManlab:_signInfo];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    _goodsList = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_eduId forKey:@"id"];
    [dict setObject:@"1" forKey:@"quantity"];
    [ _goodsList addObject:dict];
    _shopModel = [QGShoppingCartModel new];
    QGGoodsListModel *good = _shopModel.goodsList[0];
    good.quantity = @"1";
    good.id = _eduId;
    [self createReturnButton];
    [self createNavTitle:@"确认订单"];
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"updateContact" object:nil];
    _tableView =[[SATableView  alloc]initWithFrame:CGRectMake(0,self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY) style:UITableViewStyleGrouped];
    self.totalPriceLabel = [[UILabel alloc] init];
    _tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - 54-self.navImageView.maxY) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR(243, 245, 246, 1);
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    UIButton  *button = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW*2/3, MQScreenH-54, MQScreenW/3 , 54)];
    // button.backgroundColor = COLOR(224, 225, 226, 1);
    button.backgroundColor = COLOR(250, 29, 73, 1);
    PL_CODE_WEAK(weakSelf)
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
    [button addClick:^(UIButton *button) {
        [weakSelf  addsignBtn];
        
    }];
    [button setTitleColor:[UIColor whiteColor]];
    [self.view addSubview:button];
    _button = button;
    [self addfooterbar];
    ArrLabel = [NSMutableArray array];
    [self addCallMan];
}

- (void)addCallMan {
    UIButton *lab = [[UIButton alloc] initWithFrame:CGRectMake(0, 64+kTopEdgeHeight, MQScreenW, 44)];
    lab.backgroundColor = [UIColor whiteColor];
    [lab setTitleFont:[UIFont systemFontOfSize:15]];
    lab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [lab setImage:[UIImage imageNamed:@"cell_right_arrow"]];
    lab.imageEdgeInsets = UIEdgeInsetsMake(0, MQScreenW-30, 0, 0);
    UILabel *ma = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    ma.textColor = [UIColor colorFromHexString:@"666666"];
    ma.font = [UIFont systemFontOfSize:15];
    ma.text = @"联系人 :";
    [lab addSubview:ma];
    
    UILabel *call = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, MQScreenW-100, 44)];
    call.textColor = [UIColor redColor];
    call.font = [UIFont systemFontOfSize:15];

    if (_signInfo.length>0) {
        call.text = _signInfo;
        call.textColor = [UIColor colorFromHexString:@"666666"];
    }else {
        call.text = @"未添加";
        call.textColor = [UIColor colorFromHexString:@"ff3859"];
        
    }
    [lab addSubview:call];
    _callable = call;
      UIView *lineView1 = [UIView new];
    lineView1.frame = CGRectMake(0, 43, self.view.width, 1);
    lineView1.backgroundColor = RGB(242, 242, 242);
    [lab addSubview:lineView1];
    PL_CODE_WEAK(weakSelf)
    [lab addClick:^(UIButton *button) {
        QGEduSignSaveViewController *vc = [[QGEduSignSaveViewController alloc] init];
        vc.delegate =weakSelf;
        vc.contact = weakSelf.contact;
        vc.applyFieldList = weakSelf.applyFieldList;
        vc.applyArr = _applyArr;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:lab];
}
- (void)reloadTableView
{
[self addCallMan];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) addsignBtn {
 
   if ([_callable.text isEqualToString:@"未添加"]) {
      
      [self  showTopIndicatorWithErrorMessage:@"亲！您还没选择联系人呢"] ;
        
    }else {
    [self requestDataMethod];
       
    }
}

- (void)requestDataMethod{
    _shoppingCart = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_eduSid forKey:@"sid"];
    [dict setObject:_goodsList forKey:@"goodsList"];
    if (_remark.length>0) {
    [dict setObject:_remark forKey:@"remark"];
    }
    [_shoppingCart addObject:dict];
    QGEduOrderDownload *pa =[QGEduOrderDownload new];
    pa.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    pa.shoppingCart = _shoppingCart;
    pa.username =_contact.name;
    pa.tel = _contact.phone;

    [QGHttpManager edulistOrderWithParam:pa success:^(id responseObj) {
    QGActOrderInfoModel *model = [QGActOrderInfoModel mj_objectWithKeyValues:responseObj];
                   _model = model;
        
               if ([model.pay_status isEqualToString:@"2"]) {
                   QGPayResultViewController*order=[QGPayResultViewController  new];
                   order.orderID = model.order_id.integerValue;
                   order.edu_id = _eduId;
                   order.type = QGPayResultTypeEdu;
                   [self.navigationController pushViewController:order animated:NO];
               }else {
        
                    QGOrderPayViewController *vc =[[QGOrderPayViewController alloc] init];
                    vc.order_type = model.order_type;
                    vc.order_id = model.order_id;
                    vc.pay_amount = model.pay_amount;
                    vc.edu_id =_eduId;
                   [self.navigationController pushViewController:vc animated:YES];
               }
        
    } failure:^(NSError *error) {
            [self showTopIndicatorWithError:error];
    }];


}
#pragma mark ----- tableDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0){
    
        static NSString *OrderCell=@"OrderCell";
        QGEduOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:OrderCell];
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"QGEduOrderCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.avilibale_student_number = _avilibale_student_number;
        cell.class_price = _class_price;
        cell.delegate = self;
        return cell;
        
    }else {
        
        static NSString *ActOrderListCell= @"QGActOrderListCell";
        QGActOrderListCell *cell =[tableView dequeueReusableCellWithIdentifier:ActOrderListCell];
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"QGActOrderListCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.textNote.delegate = self;
        if ([_type isEqualToString:@"3"] || [_type isEqualToString:@"4"]) {
            cell.title.attributedText = [self configTitle:_name];
        }else {
            cell.title.text = _name;
        }

        [cell.icon sd_setImageWithURL:[NSURL URLWithString:_cover_path] placeholderImage:nil];
         cell.sign.text = _sign;
        return cell;
    }
    
}
- (void)orderCellDidClickPlusButton:(QGEduOrderCell*)cell{
    _goodsList = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_eduId forKey:@"id"];
    [dict setObject:cell.countLabel.text forKey:@"quantity"];
    [ _goodsList addObject:dict];
    float totalPrice=0.00;
    totalPrice = [self.totalPriceLabel1.text floatValue] +[cell.class_price floatValue];
    // 设置总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
    self.totalPriceLabel1.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
}
- (void)orderCellDidClickMinusButton:(QGEduOrderCell *)cell{
    _goodsList = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_eduId forKey:@"id"];
    [dict setObject:cell.countLabel.text forKey:@"quantity"];
    [ _goodsList addObject:dict];
    float totalPrice=0.00;
    // 计算总价
    totalPrice = self.totalPriceLabel.text.floatValue - cell.class_price.floatValue;
    // 设置总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
    self.totalPriceLabel1.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0){
        return 44;
    }else {
        
        return 130;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{     UIButton *lab1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 44)];
    if (section == 1) {
        
        lab1.backgroundColor = [UIColor whiteColor];
        [lab1 setTitle:_org_name];
        [lab1 setTitleFont:[UIFont systemFontOfSize:16]];
        lab1.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [lab1 setTitleColor:[UIColor colorFromHexString:@"333333"] forState:(UIControlStateNormal)];
        lab1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIView *lineView1 = [UIView new];
        lineView1.frame = CGRectMake(0, 43, self.view.width, 1);
        lineView1.backgroundColor = RGB(242, 242, 242);
        [lab1 addSubview:lineView1];
       
    }
     return lab1;
}

- (void)addManlab:(NSString *)title{
    title = _signInfo;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 54;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MQScreenW, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab =[[UILabel alloc] init];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        NSString *strprce = @"￥";
        lab.text = [NSString stringWithFormat:@"合计:%@",strprce];
        [QGCommon setLableColor:[NSString stringWithFormat:@"%@",strprce] andLab:lab  foot:[UIFont systemFontOfSize:15] color:@"ff3859"];
        CGRect rect  =  [QGCommon rectForString:lab.text withFont:15 WithWidth:150];
        UILabel *price = [[UILabel alloc] init];
        price.textColor = [UIColor redColor] ;
        // 设置总价
           float totalPrice=0.00;
        totalPrice = [_class_price floatValue] ;
        price.text =  [NSString stringWithFormat:@"%0.2f",totalPrice];
        price.font = [UIFont systemFontOfSize:15];
        CGRect rectp  =  [QGCommon rectForString:price.text withFont:15 WithWidth:250];
        lab.frame = CGRectMake(MQScreenW -rect.size.width-rectp.size.width-40, 0, rect.size.width+5, 44);
        price.frame = CGRectMake(MQScreenW - rectp.size.width-30 , 0, rectp.size.width+10, 44);
        lab.frame = CGRectMake(MQScreenW -rectp.size.width-30-rect.size.width, 0, rect.size.width+5, 44);
          [view addSubview:lab];
        [view addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.height.equalTo(@44);
            make.right.equalTo(view.mas_right).offset(-15);
        }];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(price.mas_left).offset(2);
    
            make.top.equalTo(@0);
            make.height.equalTo(@44);
        }];
        UILabel *ll =[[UILabel alloc] initWithFrame:CGRectMake(0, price.maxY, MQScreenW, 10)];
        ll.backgroundColor =COLOR(244, 244, 244, 1);
        [view addSubview:ll];
        UIView *lineView1 = [UIView new];
        lineView1.frame = CGRectMake(0, 0, self.view.width, 1);
        lineView1.backgroundColor = RGB(242, 242, 242);
        [view addSubview:lineView1];
        self.totalPriceLabel1 = price;
    }
    return view;
}
- (void)addfooterbar {
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 1)];
    line.backgroundColor = QGBottomBackgroundColor;
    [self.view addSubview:line];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, line.maxY,MQScreenW*2/3, 54)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UILabel *lab =[[UILabel alloc] init];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:15];
    NSString *strprce = @"￥";
    lab.text = [NSString stringWithFormat:@"合计:%@",strprce];
   [QGCommon setLableColor:[NSString stringWithFormat:@"%@",strprce] andLab:lab  foot:[UIFont systemFontOfSize:15] color:@"ff3859"];
    CGRect rect  =  [QGCommon rectForString:lab.text withFont:15 WithWidth:150];
    UILabel *price = [[UILabel alloc] init];
  
    // 设置总价
    float totalPrice=0.00;
    totalPrice = [_class_price floatValue] ;
    price.text =  [NSString stringWithFormat:@"%0.2f",totalPrice];
    price.textColor = [UIColor colorFromHexString:@"ff3859"] ;
    price.font = [UIFont systemFontOfSize:15];
    CGRect rectp  =  [QGCommon rectForString:price.text withFont:15 WithWidth:150];
    [view addSubview:lab];
    [view addSubview:price];
    self.totalPriceLabel = price;
    lab.frame = CGRectMake(view.width -rect.size.width-rectp.size.width-40, 0, rect.size.width+5, 54);
    price.frame = CGRectMake(lab.maxX-5, 0, rectp.size.width+20, 54);
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@54);
        make.right.equalTo(view.mas_right).offset(-15);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(price.mas_left).offset(2);
        
        make.top.equalTo(@0);
        make.height.equalTo(@54);
    }];
    
}


- (void)addViewController:(QGEduSignSaveViewController *)infoVc didAddContact:(QGContact *)contact {
   _contact = contact;
   _signInfo = [NSMutableString string];
   [_signInfo appendFormat:@"%@ %@",contact.name,contact.phone];

   [self addCallMan];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remark = textView.text;
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
 
    return YES;
}


- (NSMutableAttributedString *)configTitle:(NSString *)title{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"audition-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"audition-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}

@end
