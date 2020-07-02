//
//  QGFindController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/12.
//

#import "QGFindController.h"
#import "QGFindCell.h"
#import "QGActivityHomeViewController.h"
#import "BLUCircleMainViewController.h"
#import "QGSerachViewController.h"
#import "QGMessageCenterViewController.h"
@interface QGFindController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong)UIButton *messeageLab;

@end

@implementation QGFindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_titleArray = @[@"大家都在玩",@"大家都在聊"];
	[self p_creatNav];
	[self add_viewUI];
	
}
- (void)p_creatNav
{
	PL_CODE_WEAK(ws);
	UIView * navView = [[UIView alloc]init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
	navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Height_TopBar);
	
    //搜索图片
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, Height_StatusBar+12, 20, 20)];
//    searchImg.image = [UIImage imageNamed:@"ic_搜索"];
    [navView addSubview:searchImg];
	UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	searchBtn.frame = searchImg.frame;
	[self.view addSubview:searchBtn];
//	[searchBtn addClick:^(UIButton *button) {
//		[ws gotoSeachViewController];
//	}];
	
	UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(searchImg.right,Height_TopBar-30-10, (SCREEN_WIDTH-20-16-20-50), 30)];
	titleLabel.text = @"发现";
	titleLabel.font = FONT_CUSTOM(18);
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [UIColor colorFromHexString:@"333333"];
	[navView addSubview:titleLabel];
	
	
	[self addMesseageBtnInTheView:navView];

}

- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-50, Height_TopBar-50-5, 50, 50);
    bottomView.backgroundColor = [UIColor clearColor];
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"ic_咨询"] forState:UIControlStateNormal];
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn sizeToFit];
    messageBtn.centerX = 25;
    messageBtn.centerY = 33;
    _messageicon = messageBtn;
    _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(11, -4, 15, 15)];
    _messeageLab.cornerRadius = _messeageLab.height/2;
    _messeageLab.backgroundColor = [UIColor redColor];
    _messeageLab.titleFont = [UIFont systemFontOfSize:10];
    _messeageLab.hidden = YES;
    [_messageicon addSubview:_messeageLab];
    [bottomView addSubview:_messageicon];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
}

- (void)updateUserMessageCount{
    if (self.messageCount > 0) {
        _messeageLab.title = @(self.messageCount).stringValue;
    }
    _messeageLab.hidden = self.messageCount == 0;
}
- (void)gotoSeachViewController
{
    [self.view endEditing:YES];
    QGSerachViewController *cvc = [[QGSerachViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void) btnClick{
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)add_viewUI {
    if (_tableView==nil) {
        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =COLOR(242, 243, 244, 1);

    }else {
        
        [_tableView reloadData];
    }
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PL_CELL_CREATEMETHOD(QGFindCell,@"QGFindCell") ;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.contentLabel.text = _titleArray[indexPath.section];
	return cell;
}



#pragma make - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	  
	return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    if ([self loginIfNeeded]) {
//        return;
//    }
	if (indexPath.section == 0) {
		QGActivityHomeViewController * vc = [[QGActivityHomeViewController alloc]init];
		[self.navigationController pushViewController:vc animated:NO];
	}else
	{
		BLUCircleMainViewController * vc = [[BLUCircleMainViewController alloc]init];
		[self.navigationController pushViewController:vc animated:NO];
	}
}

@end
