//
//  QGStoreListViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import "QGStoreListViewController.h"

#import "QGMillSingleStoreCell.h"
#import "QGProductDetailsViewController.h"
#import "QGHttpManager+User.h"
#import "QGShareViewController.h"
#import "BLUChatViewController.h"

#define  kBtnHeight 54
@interface QGStoreListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) SASRefreshTableView * tableView;
/**头视图*/
@property (nonatomic, strong) UIView * headerView;
/**背景图片*/
@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIImageView * faceImageView1;
@property (nonatomic, strong) UIImageView * faceImageView;
@property (nonatomic,strong) QGSingleStoreResult *singModel;
@property (nonatomic,strong) QGShopDetailsModel *result;
/**机构*/
@property (nonatomic, strong) UILabel * nameLabel;
/**签名*/
@property (nonatomic, strong) UILabel * signLabel;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation QGStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createReturnButton];
    _dataArray = [[NSMutableArray alloc]init];
    [self createNavTitle:@"店铺主页"];
    [self addQG_UI];
        [self requestFirstDataMethod:SARefreshPullUpType];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)addQG_UI {
    
    _tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - kBtnHeight-self.navImageView.maxY) style:UITableViewStyleGrouped];
     PL_CODE_WEAK(weakSelf);

    _tableView.backgroundColor = COLOR(243, 245, 246, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {

        [weakSelf requestFirstDataMethod:SARefreshPullDownType];
    }];
    
    [_tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {

        [weakSelf requestFirstDataMethod:SARefreshPullUpType];
    }];
    [_tableView reloadData];
    // 头视图
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH/2)];
    // 背景图
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    _backImageView.image = [UIImage imageNamed:@"店铺主页-背景"];
    [_headerView addSubview:_backImageView];
    // 头像
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 27, SCREEN_WIDTH / 4-47, 54, 54)];
    _faceImageView.layer.cornerRadius = 3.f;
    _faceImageView.layer.masksToBounds = YES;
    [_headerView addSubview:_faceImageView];
    _faceImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_WIDTH / 4-50, 60, 60)];
    _faceImageView1.layer.cornerRadius = 5.f;
    _faceImageView1.backgroundColor = COLOR(255, 255, 255, 0.5);
    _faceImageView1.layer.masksToBounds = YES;
    [_headerView addSubview:_faceImageView1];
    // 名字
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _faceImageView.maxY + 10, SCREEN_WIDTH, 20)];
    _nameLabel.font = FONT_CUSTOM(17);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text =@"七巧国自营";
    [_headerView addSubview:_nameLabel];
    
    // 签名
    _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _nameLabel.maxY-10 , SCREEN_WIDTH-30, 50)];
    _signLabel.text = @"一站式儿童成长陪伴中心";
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.textColor = [UIColor whiteColor];
    _signLabel.numberOfLines = 0;
    _signLabel.font = FONT_CUSTOM(13);
    [_headerView addSubview:_signLabel];
    _tableView.tableHeaderView = _headerView;
    // 线
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -54, SCREEN_WIDTH, 1)];
    line.backgroundColor = APPBackgroundColor;
    [self.view addSubview:line];
    // 底部收藏分享客服按钮
    NSArray * btnImageArr = @[@"teather_consult",@"teather_share"];
    NSArray * titleArr = @[@"客服",@" 分享"];
;


    CGFloat viewH = 54;
     for (int i = 0; i < titleArr.count; i++) {
         CGFloat x = MQScreenW/2*i;
     
        QGAddBtnView *appView = [QGAddBtnView addBtnView];
         [appView.btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:(UIControlStateNormal)]; ;//btnImageArr[i];
        appView.nameLabel.text = titleArr[i];
        appView.frame = CGRectMake(x,line.maxY, MQScreenW/2, viewH);
        appView.btn.tag = 2000 + i;
        [appView.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
         appView.tag = 2000+i;
         PL_CODE_WEAK(ws)
         
         __weak __typeof(appView)viewBtn = appView;
         [appView addClick:^(UIButton *button) {
             
             [ws buttonClick:viewBtn.btn];
         }];
        [self.view addSubview:appView];
    }
    

}

- (void)buttonClick:(UIButton *)button{
    
    if ([self loginIfNeeded]) {
        return;
    }
    button.selected = !button.selected;
    
    if (button.tag == 2000) {
        // 咨询
        [self tapAndService];
    }else if (button.tag == 2001){
        // 分享
        [self shareOrg];
    }
    
}

- (void)tapAndService{
    if ([self loginIfNeeded]) {
        return ;
    }
    
    if (_result.item.service_id.integerValue < 1) {
        return;
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (viewControllers.count >= 2) {
        UIViewController *viewController = viewControllers[viewControllers.count - 2];
        if ([viewController isKindOfClass:[BLUChatViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
    }
    BLUChatViewController *vc = [[BLUChatViewController alloc]
                                 initWithUserID:_result.item.service_id.integerValue];
//    vc.headModel = _result;
    
    [self.navigationController pushViewController:vc animated:YES];

    
}


- (void)shareOrg{
    
    
    QGShareViewController *vc = [QGShareViewController new];
    vc.shareObject = self.result.item;
//    vc.shareManager.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)requestFirstDataMethod:(SARefreshType )type{
    
    QGShopDetailsDownload *param = [[QGShopDetailsDownload alloc] init];
    param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    param.shop_id =_shop_id;
 
    [QGHttpManager mallShopDetailsWithParam:param Success:^(QGShopDetailsModel *result) {
        [_faceImageView  sd_setImageWithURL:[NSURL URLWithString:result.item.cover_photo] placeholderImage:nil] ;
        _result = result;
        _nameLabel.text = result.item.name;
        _signLabel.text = result.item.signature;
        [self createActListInfo:type];
    } failure:^(NSError *error) {
         [self showTopIndicatorWithError:error];
        [_tableView reloadData];
         [_tableView endRrefresh];
    }];
    
}

- (void)createActListInfo:(SARefreshType )type{
    
    QGSingleShopStoreDownload *param = [[QGSingleShopStoreDownload alloc] init];
     param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
     param.sid =_result.item.id;
    if (type == SARefreshPullDownType)
        param.page = @"1";
    else
        param.page = [NSString stringWithFormat:@"%ld",(long)self.page];

    [QGHttpManager mallSingShopStoreleListDataWithParam:param  Success:^(QGSingleStoreResult *result) {
        [_tableView endRrefresh];
        _singModel = result;
          if (type == SARefreshPullDownType) {
            self.page = 1;
            self.page ++;
            [_dataArray removeAllObjects];
        }
        else
            self.page ++;
        // 数据加载完以藏加载
        if (self.page > [result.per_page  integerValue])
            [_tableView hiddenFooterView];
        else
            [_tableView showFooterView];

        NSArray *nn = [NSArray array];
        nn = result.items;
        [_dataArray addObjectsFromArray:nn];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [_tableView endRrefresh];
        [_tableView reloadData];
        [_tableView endRrefresh];
         [self showTopIndicatorWithError:error];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   PL_CELL_CREATEMETHOD(QGMillSingleStoreCell, @"storecell")
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.singModel =_dataArray[indexPath.row];
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGSingleStoreModel *singModel = _dataArray[indexPath.row];
    QGProductDetailsViewController *vc = [[QGProductDetailsViewController alloc] init];
    vc.goods_id = singModel.id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
