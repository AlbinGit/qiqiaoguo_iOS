//
//  QGProductDetailsViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import "QGProductDetailsViewController.h"

#import "QGAddBtnView.h"
#import "QGaddFooterView.h"
#import "SDCycleScrollView.h"
#define  kBtnHeight 54
#import "QGProductDetailsCell.h"
#import "QGStoreAttrListModel.h"
#import "QGTagListModel.h"
#import "QGAttributePopView.h"
#import "QGLoadWebCell.h"
#import "QGShopCarViewController.h"
#import "QGShopCarModel.h"
#import "QGGoodsMO.h"
#import "QGStoreListViewController.h"
#import "QGHttpManager+User.h"
#import "QGStoreDetailPriceListModel.h"
#import "QGShareViewController.h"
#import "BLUChatViewController.h"
#import "QGConfirmOrderViewController.h"

@interface QGProductDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    BOOL isOrBuyNow;
    NSTimer *_timer;
    CGFloat webheight;
}

@property (nonatomic, strong) SASRefreshTableView * tableView1;
/**头视图*/
@property (nonatomic, strong) UIView * headerView;
/**背景图片*/
//@property (nonatomic, strong) UIImageView * backImageView;
/**机构*/
@property (nonatomic, strong) UILabel * nameLabel;
/**签名*/
@property (nonatomic, strong) UILabel * signLabel;
/**是否编辑过*/
@property(nonatomic,assign)BOOL isModity;
/**价格*/
@property (nonatomic, strong) UILabel * pricelab;
/**分类弹出框*/
@property(nonatomic,strong)QGAttributePopView *popview;

@property (nonatomic, strong)UILabel *collectionCountLabel;
@property (nonatomic, assign) NSInteger collectionCount;
/**背景图片*/
@property (nonatomic, strong) UIImageView * globalImageView;
@property (nonatomic,strong) UIButton *lablebtn;
@property (nonatomic,strong) UIButton *lablebtn1;
@property (nonatomic,strong) UIButton *lablebtn2;
@property (nonatomic,assign)BOOL isTableView1;
@property (nonatomic,strong) QGStoreDetailModel *result;
@property (nonatomic,strong)SASRefreshTableView *tableView2;//分页
@property (nonatomic,strong) NSMutableArray *nameList;
//新需求添加上拉加载商品详情
@property (nonatomic,strong)UIScrollView *bottomScrollView;
@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong)UIButton *messeageLab;
@end

@implementation QGProductDetailsViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[SAProgressHud sharedInstance]showWaitWithWindow];
   
    [self initBaseData];
    [self createReturnButton];
    
    _isTableView1 = YES;
    
    [self createNavTitle:@"产品详情"];
    webheight=0;
    [self addRequest];
    [self addMesseageBtnInTheView:self.navImageView];
  
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     [self updateShopCarCount];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)addMesseageBtnInTheView:(UIView *)view
{
    
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-7-40, 22, 40, 40);
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [messageBtn setBackgroundImage:[UIImage imageNamed:@"background_home_classification"] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"shopping_car_no_bg"] forState:UIControlStateNormal];
    
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(6, 0, 25, 25);
    messageBtn.centerX = 20;
    messageBtn.centerY = 20;
    _messageicon = messageBtn;
    
    _messeageLab = [[UIButton alloc]initWithFrame:CGRectMake(15, -5, 15, 15)];
    _messeageLab.cornerRadius = 7.5;
    _messeageLab.backgroundColor = QGMainRedColor;
    _messeageLab.titleFont = [UIFont systemFontOfSize:13];
    
    [messageBtn addSubview:_messeageLab];
    [bottomView addSubview:messageBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
    [self addCarIconBtn];
}

- (void)btnClick {
    
    QGShopCarViewController *vc = [QGShopCarViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIScrollView *)bottomScrollView
{
    if ( _bottomScrollView== nil)
    {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY-54)];
        _bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT-self.navImageView.maxY-50)*2);
        //设置分页效果
        _bottomScrollView.pagingEnabled = YES;
        //禁用滚动
        _bottomScrollView.scrollEnabled = NO;
    }
    return _bottomScrollView;
}
- (UITableView *)tableView1
{
    if (_tableView1==nil)
    {
        _tableView1 =[[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY - 54) style:UITableViewStyleGrouped];
        _tableView1.delegate=self;
        _tableView1.dataSource=self;
        _tableView1.tag=1;
        _tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
    }
    return _tableView1;
}


-(UITableView *)tableView2
{
    if (_tableView2 == nil)
    {
        _tableView2 = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-54-64, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY-50) style:UITableViewStylePlain];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tag=2;
        _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView2;
}



- (void)addQGView{
    
    
    // 头视图
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *bannerUrlArray = [NSMutableArray array];
    NSMutableArray *bannerUrlArray1 = [NSMutableArray array];
    for (int i=0; i<_result.item.imageList.count; i++)
    {
        QGStoreDetailImageListModel *banner=_result.item.imageList[i];
        [bannerUrlArray addObject:banner.image_url];
    }
    [bannerUrlArray1 addObjectsFromArray:bannerUrlArray];
    SDCycleScrollView *backImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) imageURLStringsGroup:bannerUrlArray1]; // 模拟网络延时情景
    
    backImageView.pageControlDotSize = CGSizeMake(5, 5);
    backImageView.autoScrollTimeInterval = 5;
    [_headerView addSubview:backImageView];
      _nameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _nameLabel.textColor = QGTitleColor;
    if ([_result.item.delivery_type isEqualToString:@"3"]) {
        _nameLabel.attributedText = [self configTitle:_result.item.title];
    }else {
        _nameLabel.text = _result.item.title ;
    }
    _nameLabel.numberOfLines = 2;
    _nameLabel.width = SCREEN_WIDTH-20;
    [_nameLabel sizeToFit];
    _nameLabel.X = 10;
    _nameLabel.Y = backImageView.maxY+10;
    
    [_headerView addSubview:_nameLabel];
    
    // 签名
    _signLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _nameLabel.maxY + 4 , SCREEN_WIDTH-30, 20)];
    _signLabel.text = _result.item.sub_title;
    _signLabel.textAlignment = NSTextAlignmentLeft;
    _signLabel.textColor = QGMainRedColor;
    _signLabel.numberOfLines = 0;
    _signLabel.font = FONT_CUSTOM(13);
    [_headerView addSubview:_signLabel];
    _tableView1.tableHeaderView = _headerView;
    
    SALabel *price  =[SALabel createLabelWithRect:CGRectMake(10,_signLabel.maxY, [QGCommon rectWithString:[NSString stringWithFormat:@"￥%@",_result.item.sales_price_tip] withFont:17],[QGCommon rectWithFont:17]) andWithColor:QGMainRedColor andWithFont:17 andWithAlign:NSTextAlignmentLeft andWithTitle:nil];
    price.font=[UIFont boldSystemFontOfSize:16];
    // [self.headerView addSubview:price];
    price.text = [NSString stringWithFormat:@"￥%@",_result.item.sales_price_tip];
    
    [self.headerView addSubview:price];
    self.pricelab = price;
    SALabel *saleprice=[SALabel createLabelWithRect:CGRectMake(price.maxX+2,_signLabel.maxY+5, [QGCommon rectWithString:[NSString stringWithFormat:@"￥%@",_result.item.market_price_tip] withFont:14],[QGCommon rectWithFont:14]) andWithColor:PL_UTILS_COLORRGB(160, 160, 160) andWithFont:14 andWithAlign:NSTextAlignmentLeft andWithTitle:nil];
    saleprice.font=FONT_SYSTEM(14);
    saleprice.text = [NSString stringWithFormat:@"￥%@",_result.item.market_price_tip];
    saleprice.lineColor=PL_COLOR_160;
    saleprice.lineType=LineTypeMiddle;
    [self.headerView addSubview:saleprice];
    
    CGFloat salesWith =[QGCommon rectWithString:@"总销量:88888" withFont:13];
    SALabel *labb1=[SALabel createLabelWithRect:CGRectMake(self.view.width - salesWith,_signLabel.maxY+5, salesWith,[QGCommon rectWithFont:13]) andWithColor:PL_UTILS_COLORRGB(160, 160, 160) andWithFont:13 andWithAlign:NSTextAlignmentRight andWithTitle:nil];
    labb1.font=FONT_SYSTEM(13);
    labb1.text = [NSString stringWithFormat:@"总销量:%@",_result.item.sales_volume];
    CGFloat salesWith2 =[QGCommon rectWithString:labb1.text withFont:13];
    labb1.frame = CGRectMake(self.view.width - salesWith2 - 16,_signLabel.maxY+5, salesWith2,[QGCommon rectWithFont:13]);
    
    [self.headerView addSubview:labb1];
    
    CGFloat connetWith = [QGCommon rectWithString:[NSString stringWithFormat:@"已有%@人收藏",_result.item.following_count] withFont:13];
    SALabel *labb=[SALabel createLabelWithRect:CGRectMake(labb1.minX - connetWith - 4 ,_signLabel.maxY+5, connetWith,[QGCommon rectWithFont:13]) andWithColor:PL_UTILS_COLORRGB(160, 160, 160) andWithFont:13 andWithAlign:NSTextAlignmentLeft andWithTitle:nil];
    labb.font=FONT_SYSTEM(13);
    _collectionCountLabel = labb;
    labb.text = [NSString stringWithFormat:@"已有%@人收藏",_result.item.following_count];
    
    [self.headerView addSubview:labb];
    
    //线
    UILabel *lba =[[UILabel alloc] initWithFrame:CGRectMake(0,price.maxY+10 , MQScreenW, 1)];
    
    lba.backgroundColor = COLOR(242, 243, 244, 1);
    
    [_headerView addSubview:lba];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, lba.maxY, MQScreenW, 60)];
    //  _lablebtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 18, 80, 25)];
    UIImage *im = [UIImage imageNamed:@"详情-七天退货icon"];
    CGFloat btnX =80;
    for (NSInteger i = 0; i < _result.shopInfo.tagList.count; i ++) {
        QGTagListModel *tag = _result.shopInfo.tagList[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX * i +10, 18, btnX, 25);
        [btn setTitle:tag.tag_name forState:UIControlStateNormal];
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setImage:im forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [view addSubview:btn];
    }
    [_headerView addSubview:view];
    
    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, view.maxY, SCREEN_WIDTH, 10)];
    line1.backgroundColor = COLOR(242, 243, 244, 1);
    [_headerView addSubview:line1];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,line1.maxY);
    _tableView1.tableHeaderView = _headerView;
    // 底部收藏分享客服按钮
    NSArray * btnImageArr = @[@"teather_consult",@"teather_nolove",@"teather_share"];
    NSArray * titleArr = @[@"客服",@"收藏",@"分享"];
    // 总共有3列
    int totalCol = 3;
    CGFloat viewW = 54;
    CGFloat viewH = 54;
    
    // 线
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewH, SCREEN_WIDTH, 1)];
    line.backgroundColor = APPBackgroundColor;
    [self.view addSubview:line];
    
    CGFloat marginX = (self.view.bounds.size.width*0.5 - totalCol * viewW) / (totalCol + 1);
    
    for (int i = 0; i < titleArr.count; i++) {
        
        int col = i % totalCol;
        
        CGFloat x = marginX + (viewW + marginX) * col;
        QGAddBtnView *appView = [QGAddBtnView addBtnView];
        appView.backgroundColor = [UIColor whiteColor];
        [appView.btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:(UIControlStateNormal)];
        appView.nameLabel.text = titleArr[i];
        if (i == 1) {
            [appView.btn setImage:[UIImage imageNamed:@"teather_yeslove"] forState:(UIControlStateSelected)];
            if (_result.item.isFollowed.integerValue == 1) {
                appView.btn.selected = YES;
                appView.nameLabel.text = @"已收藏";
            }
        }
        
        appView.frame = CGRectMake(x,line.maxY, viewW, viewH);
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
    UIButton  *button = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW*0.5, line.maxY, MQScreenW/4 , viewH)];
    
    button.backgroundColor = [UIColor colorFromHexString:@"ffb400"];
    [button setTitle:@"加入购物车" forState:UIControlStateNormal];
    button.tag = 1001;
    [button setTitleFont:[UIFont systemFontOfSize:15]];
    [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    UIButton  *button1 = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW/4+MQScreenW*0.5, line.maxY, MQScreenW/4 , viewH)];
    button1.backgroundColor = COLOR(250, 29, 72, 1);;
    [button1 setTitle:@"立即购买" forState:UIControlStateNormal];
    button1.tag = 1002;
    [button1 setTitleFont:[UIFont systemFontOfSize:15]];
    [button1 addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    QGaddFooterView *footer = [[QGaddFooterView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 60)];
    footer.backgroundColor = COLOR(243, 243, 244, 1);
    footer.title.text = @"继续拖动，查看图文详情";
    self.tableView1.tableFooterView = footer;
    [_tableView1 reloadData];
    [_tableView2 reloadData];
    
}

#pragma mark 添加侧面购物车
- (void)addCarIconBtn {
    
    
    
    
}


#pragma mark - 下方按钮点击
- (void)buttonClick:(UIButton *)button{
    
    if ([self loginIfNeeded]) {
        return;
    }
    button.selected = !button.selected;
    
    if (button.tag == 2000) {
        // 咨询
        [self tapAndService];
    }else if (button.tag == 2001){
        // 关注商品
        [self followTeacher:button];
    }else if (button.tag == 2002){
        // 分享
        [self shareOrg];
    }
    
    
}

- (void)tapAndService{
    
    if ([self loginIfNeeded]) {
        return ;
    }
    
    if (_result.shopInfo.service_id.integerValue < 1) {
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
                                 initWithUserID:_result.shopInfo.service_id.integerValue];
    vc.headModel = _result;
    //    vc.headGoodMO = self.goodMO;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)followTeacher:(UIButton *)button{
    @weakify(self);
    
    NSArray *arr = _result.item.priceList;
    QGStoreDetailPriceListModel *model = [arr firstObject];
    
    QGAddBtnView *BtnView = (QGAddBtnView *)button.superview;
    int count = button.selected ? ++_collectionCount : --_collectionCount;
    _collectionCountLabel.text = [NSString stringWithFormat:@"已有%d人收藏",count];
    BtnView.nameLabel.text = button.selected ? @"已收藏" : @"收藏";
    
    [QGHttpManager CollectionWithCollectType:UserCollectionTypeGoods objectID:model.id.integerValue isCollection:button.selected Success:^(NSURLSessionDataTask *task, id responseObject) {
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        button.selected = !button.selected;
        BtnView.nameLabel.text = button.selected ? @"已收藏" : @"收藏";
        _collectionCountLabel.text = [NSString stringWithFormat:@"已有%d人收藏",count];
    }];
    
    
}

- (void)shareOrg{
    
    QGShareViewController *vc = [QGShareViewController new];
    vc.shareObject = self.result.item;
    vc.shareManager.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)bottomButtonClick:(UIButton *)button{
    
    if (button.tag - 1000 == QGPopviewTypeBuyNow) {
        if ([self loginIfNeeded]) {
            return;
        }
    }
    
    [self showPopviewWithPopViewType:button.tag - 1000];
    
}


#pragma mark 添加请求

- (void)updateShopCarCount{
    
    NSArray *goodsArray = [self findAllShopCarGoods];
    _messeageLab.hidden = goodsArray.count < 1 ? YES : NO;
    _messeageLab.title = [NSString stringWithFormat:@"%ld",(unsigned long)goodsArray.count];
    
}

- (NSArray *)findAllShopCarGoods{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     @"isSeckilling ==%@",@(NO)];
    NSArray *arr = [QGGoodsMO MR_findAllWithPredicate:predicate];
    return arr;
}


- (void) addRequest {
    QGStoreDetailDownload *param =[[QGStoreDetailDownload alloc] init];
    param.platform_id =[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    param.goods_id = _goods_id;
    [QGHttpManager mallStoreDetailWithParam:param Success:^(QGStoreDetailModel *result) {
        NLog(@"xmq = xmq %@",result);
        [self.view addSubview:self.bottomScrollView];
        [self.bottomScrollView addSubview:self.tableView1];
        [self.bottomScrollView addSubview:self.tableView2];
        //_signLabel.text = result.item.sub_title;
        _result = result;
        _nameList = [NSMutableArray array];
        [self addQGView];
        [_tableView1 reloadData];
        [_tableView2 reloadData];
        
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
        [_tableView1 reloadData];
        [_tableView2 reloadData];
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1)
    {
        
        return 1;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag==1)
    {
        PL_CELL_NIB_CREATE(QGProductDetailsCell)
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PL_CODE_WEAK(weakSelf);
        [cell.storeBtnClick addClick:^(UIButton *button) {
            
            [weakSelf showPopviewWithPopViewType:QGPopviewTypeDefault];
            
        }];
        cell.name.text = _result.shopInfo.name;
        cell.sugn.text = _result.shopInfo.signature;
        
        [cell.orgBtn addClick:^(UIButton *button) {
            QGStoreListViewController *vc = [[QGStoreListViewController alloc] init];
            vc.shop_id = _result.shopInfo.id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:_result.shopInfo.cover_photo] placeholderImage:nil];
        return cell;
        
    }else {
        PL_CELL_CREATEMETHOD(QGLoadWebCell, @"webSign")
       
        cell.webView.scalesPageToFit=YES;
        if (webheight==0) {
            if (_result.item.fruit_desc.length>0)
            {    cell.webView.delegate=self;
                cell.nullLab.hidden=YES;
                [cell.webView loadHTMLString:self.result.item.fruit_desc baseURL:nil];
            }else {
                cell.nullLab.hidden=NO;
            }
        }
        
        return cell;
        
    }
}

#pragma mark - 商品规格弹出

- (void)showPopviewWithPopViewType:(QGPopviewType)type{
    
    self.popview = [[QGAttributePopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andAttrPriceListArray:self.result.item.attrList Type:type];
    self.popview.priceListsArray = self.result.item.priceList;
    self.popview.attrPriceListArray = self.result.item.attrList;
    self.popview.imageList =self.result.item.coverpath;
    self.popview.str= @"2";
    [self.view addSubview:self.popview];
    
    @weakify(self);
    _popview.addBuyCartBlock = ^(NSString *name , NSString *price ,NSString *num ,NSString *goods_id,NSMutableDictionary *selectBtnDic,QGSingleItemPriceListModel *priceModel,int buyNum,NSMutableArray *attribute_idArray,NSMutableArray *attr_value_idArray,QGPopviewType popviewType)
    { // 加入购物车方法
        @strongify(self);
        self.isModity = YES;
        //如果商品没有分类 就用默认值
        isOrBuyNow = NO;
        QGProductDetailsCell *cell = [self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (goods_id == nil)
        {
            [cell.storeBtnClick setTitle:@"选择 商品规格" forState:(UIControlStateNormal)];
        }
        else
        {
            [cell.storeBtnClick setTitle:name forState:(UIControlStateNormal)];
        }
        
        if (popviewType == QGPopviewTypeJoinShopCar) {
            // 加入购物车
            QGShopCarModel *model = [[QGShopCarModel alloc]init];
            model.goodsID = goods_id.integerValue;
            model.goodsCount = buyNum;
            model.goodsNote = name;
            model.goodsName = self.result.item.title;
            model.goodsPrice = priceModel.sales_price.floatValue;
            model.storeID = self.result.shopInfo.id.integerValue;
            model.storeName = self.result.shopInfo.name;
            model.goodsImage = self.result.item.coverpath;
            model.goodsInventory = priceModel.stock.integerValue;
            model.DeliveryType = self.result.item.delivery_type.integerValue;
            
            [self insertGoodMOWithModelIfNeeded:model];
            [self updateShopCarCount];
        }else{
            // 立即购买
            QGShopCarModel *model = [[QGShopCarModel alloc]init];
            model.goodsID = goods_id.integerValue;
            model.goodsCount = buyNum;
            model.goodsNote = name;
            model.goodsName = self.result.item.title;
            model.goodsPrice = priceModel.sales_price.floatValue;
            model.storeID = self.result.shopInfo.id.integerValue;
            model.storeName = self.result.shopInfo.name;
            model.goodsImage = self.result.item.coverpath;
            model.goodsInventory = priceModel.stock.integerValue;
            model.DeliveryType = self.result.item.delivery_type.integerValue;
            model.isBuyNow = YES;
            QGGoodsMO *mo = [QGGoodsMO MR_createEntity];
            [mo configureWithGood:model];
            QGConfirmOrderViewController *vc = [QGConfirmOrderViewController new];
            if (self.result.item.delivery_type.integerValue == QGGoodsDeliveryTypeBonded) {
                vc.type = QGConfirmOrderTypeGlobalAndBuyNow;
            }else{
                vc.type = QGConfirmOrderTypeBuyNow;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    };
}

#pragma mark 购物车存库

- (void)insertGoodMOWithModelIfNeeded:(QGShopCarModel *)model{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:
     [NSString stringWithFormat:@"goodID == %ld",model.goodsID]];
    QGGoodsMO *mo = [QGGoodsMO MR_findFirstWithPredicate:predicate];
    
    if (mo == nil) {
        mo = [QGGoodsMO MR_createEntity];
    }else{
        model.goodsCount = mo.goodsCount.integerValue +  model.goodsCount;
    }
    
    [mo configureWithGood:model];
    [self showTopIndicatorWithSuccessMessage:@"加入购物车成功！"];
}


#pragma mark webDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
   
    CGRect frame = webView.frame;
    frame.size.width= MQScreenW-10;
    frame.size.height = 1;
    frame.origin.x = 5;
    webView.frame = frame;
    
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webheight=webView.scrollView.contentSize.height;
    
    webView.delegate=nil;
    [_tableView2 reloadData];
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==1) {
        return 154;
    }
    
    else  if (webheight>0)
    {
        return webheight;
    }
    else 
    return MQScreenH/2;
}



#pragma  mark refreshAnimotion
- (void)pullUpAnimotion
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-self.navImageView.maxY-50);
    } completion:^(BOOL finished) {
        _isTableView1=NO;
        self.navTitleLabel.text =@"图文详情";
        [self.tableView2 reloadData];
    }];
}
- (void)pullDownAnimotion
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        //结束加载
        _isTableView1=YES;
        self.navTitleLabel.text =@"产品详情";
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isTableView1)
    {//当tableView1中没有评论且(修改后少了一栏包邮的代码,所以这里要多减50)
        if (self.tableView1.contentSize.height>SCREEN_HEIGHT-self.navImageView.maxY-50-50)
        {
            if (scrollView.contentOffset.y+SCREEN_HEIGHT-self.navImageView.maxY-50>self.tableView1.contentSize.height+50)
            {
                [self pullUpAnimotion];
            }
        }
    }else
    {
        if (_tableView2.contentOffset.y<-50)
        {
            [self pullDownAnimotion];
        }
    }
    
}
- (NSMutableAttributedString *)configTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Global-purchasing-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"Global-purchasing-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer=nil;
    [_tableView1 refreshFree];
    [_tableView2 refreshFree];
    NSLog(@"释放了");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
