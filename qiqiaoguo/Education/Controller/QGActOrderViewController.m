//
//  QGActOrderViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGActOrderViewController.h"
#import "QGActOrderCell.h"
#import "QGActOrderListCell.h"
#import "QGPayResultViewController.h"
#import "QGOrderPayViewController.h"
#import "QGActOrderInfoModel.h"
#import "QGActSignSaveViewController.h"
#import "QGContact.h"
#import "QGTicklistModel.h"
#import "QGNearActSignModel.h"
@interface QGActOrderViewController ()<UITableViewDelegate,UITableViewDataSource,QGActSignSaveViewControllerDelegate,QGActOrderCellDelegate,UITextViewDelegate>
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
@property(nonatomic ,assign)NSInteger indexRow;
@property (nonatomic,strong)NSArray *ticketArr;
@property (nonatomic,strong) NSMutableArray *ticketArrM;
@property (nonatomic,strong) NSMutableArray *ticketArr1;
@property (nonatomic,strong) NSMutableArray *applyArr;
@property (nonatomic,strong) UILabel *callable;
@property (nonatomic,strong) QGActOrderInfoModel *item;
@property (nonatomic,strong)  UIButton  *button;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) QGContact *contact;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,copy) NSString *quantity;


@end

@implementation QGActOrderViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self addManlab:_signInfo];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    _ticketArr = [NSMutableArray array];
     _ticketArrM = [NSMutableArray array];

    for (QGActlistTicketListModel  *model in _ticketList) {

        model.pricecount = 1;
        model.quantitycCount = @"1";
    }
    [self createReturnButton];
    [self createNavTitle:@"确认订单"];
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"updateContact" object:nil];
    
    _tableView =[[SATableView  alloc]initWithFrame:CGRectMake(0,self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY) style:UITableViewStyleGrouped];
    self.totalPriceLabel = [[UILabel alloc] init];
    _tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - 54-self.navImageView.maxY) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR(243, 245, 246, 1);
    _tableView.delegate = self;
  //  _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
  
    UIButton  *button = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW*2/3, MQScreenH-54, MQScreenW/3 , 54)];
    // button.backgroundColor = COLOR(224, 225, 226, 1);
    button.backgroundColor = COLOR(250, 29, 73, 1);
    PL_CODE_WEAK(weakSelf)
    [button setTitle:@"提交订单"];
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
    
    
    UIButton *lab = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, MQScreenW, 44)];
    
    
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
    
    UILabel *call = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 44)];
    call.textColor = [UIColor redColor];
    call.font = [UIFont systemFontOfSize:15];
    // 获取模型
    
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
        QGActSignSaveViewController *vc = [[QGActSignSaveViewController alloc] init];
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

- (NSMutableArray *)contacts
{
    if (_contacts == nil) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) addsignBtn {
    
    if (_applyArr.count == 0) {
      
      [self  showTopIndicatorWithErrorMessage:@"亲！您还没选择联系人呢"] ;
        
    }else {

        [self requestDataMethod];
    }
}

- (void)requestDataMethod{

    NSMutableArray *arrM = [NSMutableArray array];

    for (QGActlistTicketListModel  *model in _ticketList) {

       NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.id forKey:@"id"];
        [dict setObject:model.quantitycCount forKey:@"quantity"];

        [arrM addObject:dict];

    }
    QGActOrderDownload *pa = [QGActOrderDownload new];
    pa.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    pa.applyDataList = _applyArr;
    pa.ticketList = arrM;
    pa.activity_id = _activity_id;
    if (_remark.length >0) {
        pa.remark = _remark;
    }
   [QGHttpManager actlistOrderWithParam:pa success:^(id responseObj) {

           QGActOrderInfoModel *model = [QGActOrderInfoModel mj_objectWithKeyValues:responseObj];
           _model = model;
       
       if ([model.pay_status isEqualToString:@"2"]) {
           QGPayResultViewController*order=[QGPayResultViewController  new];
           order.orderID = model.order_id.integerValue;
           order.activity_id = _activity_id;
           order.type = QGPayResultTypeActiv;
           [self.navigationController pushViewController:order animated:NO];
       }else {
       
           QGOrderPayViewController *vc =[[QGOrderPayViewController alloc] init];
           vc.order_type = model.order_type;
           vc.order_id = model.order_id;
           vc.pay_amount = model.pay_amount;
           vc.activity_id = _activity_id;
      
           [self.navigationController pushViewController:vc animated:YES];}
   } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
   }];

}

#pragma mark ----- tableDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       if (section==0){
        
        return _ticketList.count;
    }else {
        
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0){
           static NSString *ActOrderCell=@"ActOrderCell";
        QGActOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:ActOrderCell];
        if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"QGActOrderCell" owner:self options:nil][0];
        }
        QGActlistTicketListModel *ticketList =_ticketList[indexPath.row] ;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        ticketList.limitquantity = ticketList.quantity.integerValue - ticketList.sale_quantity.integerValue;
        cell.indexminRow = indexPath;
        cell.ticketList =  ticketList;
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
        cell.item = _items;
  
        return cell;
    }
    
}

- (void)orderCellDidClickPlusButton:(QGActOrderCell*)cell{
    NSLog(@"n  llllllcell.ticketList.pricecount== %d %d %d ",cell.ticketList.quantity.intValue,cell.ticketList.limitquantity,cell.ticketList.sale_quantity.intValue );
    QGActlistTicketListModel *ticketList = _ticketList[cell.indexminRow.row];
    ticketList.quantitycCount = cell.countLabel.text;
    float totalPrice=0.00;
    totalPrice = [self.totalPriceLabel.text floatValue] +[cell.ticketList.price floatValue];
    // 设置总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
    self.totalPriceLabel1.text = [NSString stringWithFormat:@"%0.2f",totalPrice];
}
- (void)orderCellDidClickMinusButton:(QGActOrderCell *)cell{
    QGActlistTicketListModel *ticketList = _ticketList[cell.indexminRow.row];
    ticketList.quantitycCount = cell.countLabel.text;
    float totalPrice=0.00;
    // 计算总价
    totalPrice = self.totalPriceLabel.text.floatValue - cell.ticketList.price.floatValue;
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
        [lab1 setTitle:_name];
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
      //  [QGCommon setLableColorAndSize:[NSString stringWithFormat:@"%@",strprce] andLab:lab];
        CGRect rect  =  [QGCommon rectForString:lab.text withFont:15 WithWidth:150];
        UILabel *price = [[UILabel alloc] init];
        price.textColor = [UIColor redColor] ;
         price.text =_totalPriceLabel.text;
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
        UILabel *lab1 = [[UILabel alloc] init];
    _ticketArr = [NSMutableArray array];
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
    float totalPrice=0.00;

    // 设置总价

    for (QGActlistTicketListModel *ticketList in _ticketList) {
        NSLog(@"uuuuuuuuuuu %@",ticketList.price);
        totalPrice = lab1.text.floatValue  +ticketList.price.floatValue;
        lab1.text =[NSString stringWithFormat:@"%0.2f",totalPrice];

    }
    price.text =[NSString stringWithFormat:@"%0.2f",totalPrice];
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


- (void)addViewController:(QGActSignSaveViewController *)infoVc didAddContact:(NSMutableDictionary *)contact {
//    _contact = contact;
   _signInfo = [NSMutableString string];
    _applyArr = [NSMutableArray array];

    for (QGNearActSignModel *signModel in _applyFieldList) {
        NSString *str = [contact objectForKey:signModel.id];
        [_signInfo appendFormat:@"%@ ",str];
    }
    
        for (QGActlistApplyFieldListModel *signModel in _applyFieldList) {
              NSString *str = [contact objectForKey:signModel.id];
        
               NSMutableDictionary *shopDic = [NSMutableDictionary dictionary];
           
                [shopDic setObject:signModel.id forKey:@"id"];
                [shopDic setObject:str forKey:@"value"];
                [_applyArr addObject:shopDic];
      
            }
    
   [self addCallMan];

   
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    NSLog(@"textView===%@",textView.text);
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
@end
