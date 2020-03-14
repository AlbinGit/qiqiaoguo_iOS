//
//  QGSecKillDetailViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/19.
//
//




#import "QGSecKillDetailViewController.h"

#import "QGAddBtnView.h"
#import "QGaddFooterView.h"
#import "SDCycleScrollView.h"
#import "QGProductDetailsCell.h"
#import "QGStoreAttrListModel.h"
#import "QGTagListModel.h"
#import "QGAttributePopView.h"
#import "QGLoadWebCell.h"
#import "QGTimerLabel.h"
#import "QGShopCarModel.h"
#import "QGGoodsMO.h"
#import "QGConfirmOrderViewController.h"
#import "QGShareViewController.h"
#import "QGStoreDetailPriceListModel.h"
#import "BLUChatViewController.h"
#import "QGHttpManager+User.h"
#import "QGStoreListViewController.h"

#define  kBtnHeight 54

@interface QGSecKillDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    BOOL isOrBuyNow;
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
@end

@implementation QGSecKillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBaseData];
    [self createReturnButton];
    
    _isTableView1 = YES;
    
    [self createNavTitle:@"产品详情"];
    
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.tableView1];
    [self.bottomScrollView addSubview:self.tableView2];
 
        webheight=0;
    [self addRequest];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}




-(UIScrollView *)bottomScrollView
{
    if ( _bottomScrollView== nil)
    {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY- 54)];
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
        _tableView1 =[[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY-54) style:UITableViewStyleGrouped];
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
        _tableView2 = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-self.navImageView.maxY-54, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY-50) style:UITableViewStylePlain];
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
    _globalImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Global-purchasing-icon"]];
    
    _globalImageView.frame = CGRectMake(13, backImageView.maxY+5 , 30, 20);
    [_headerView addSubview:_globalImageView];
    [_headerView addSubview:_globalImageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, backImageView.maxY, MQScreenW, 44)];
    view.backgroundColor = COLOR(250, 48, 79, 1);
    if (_result.item.seckillingInfo>0) {
        
        SALabel *lab=[[SALabel alloc]initWithFrame:CGRectMake(10, 0, MQScreenW, 44)];
        lab.font=[UIFont boldSystemFontOfSize:14];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = @"限时秒杀";
        view.backgroundColor = COLOR(242, 243, 244, 1);
        [view addSubview:lab];
        //时钟图
        UIImageView *nock=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_time_write_icon"]];
        [view addSubview:nock];
        CGFloat labH = 20;
        
        CGFloat lab4 = 11;
        UILabel *initLab1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-labH-10,12,labH, labH)];
        initLab1.textAlignment =NSTextAlignmentCenter;
        initLab1.font = [UIFont systemFontOfSize:11];
        initLab1.layer.cornerRadius = 5;
        initLab1.layer.masksToBounds= YES;
        initLab1.backgroundColor =[UIColor whiteColor];
        initLab1.textColor=COLOR(250, 48, 79, 1);
        initLab1.text=@"00";
        UILabel *initLab2=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2*labH-lab4-10 ,12,labH, labH)];
        initLab2.textAlignment =NSTextAlignmentCenter;
        initLab2.font = [UIFont systemFontOfSize:11];
        initLab2.backgroundColor =[UIColor whiteColor];;
        initLab2.layer.cornerRadius = 5;
        initLab2.layer.masksToBounds= YES;
        initLab2.textColor=COLOR(250, 48, 79, 1);
        initLab2.text=@"00";
        UILabel *initLab3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-3*labH-2*lab4-10  ,12,labH, labH)];
        initLab3.backgroundColor =[UIColor whiteColor];;
        initLab3.font = [UIFont systemFontOfSize:11];
        initLab3.textColor=COLOR(250, 48, 79, 1);
        initLab3.layer.cornerRadius = 5;
        initLab3.layer.masksToBounds= YES;
        initLab3.textAlignment =NSTextAlignmentCenter;
        initLab3.text=@"00";
        UILabel *initLab4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-labH-lab4-10 ,12,lab4, labH)];
        initLab4.textAlignment =NSTextAlignmentCenter;
        initLab4.textColor =[UIColor whiteColor];;
    
        initLab4.font = [UIFont systemFontOfSize:15];
        initLab4.text=@":";
        UILabel *initLab5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2*labH-2*lab4-10 ,12,lab4, labH)];
        initLab5.textAlignment =NSTextAlignmentCenter;
        initLab5.textColor=[UIColor whiteColor];;
        initLab5.font = [UIFont systemFontOfSize:15];
        
        initLab5.text=@":";
        
        
        QGTimerLabel *timeLab1 = [[QGTimerLabel alloc] initWithLabel:initLab1 andTimerType:QGTimerLabelTypeTimer];
        timeLab1.timeFormat= @"ss";
        QGTimerLabel *timeLab2 = [[QGTimerLabel alloc] initWithLabel:initLab2 andTimerType:QGTimerLabelTypeTimer];
        timeLab2.timeFormat= @"mm";
        QGTimerLabel *timeLab3 = [[QGTimerLabel alloc] initWithLabel:initLab3 andTimerType:QGTimerLabelTypeTimer];
        timeLab3.timeFormat= @"HH";
        
        [view addSubview:initLab1];
        [view addSubview:initLab2];
        [view addSubview:initLab3];
        [view addSubview:initLab4];
        [view addSubview:initLab5];
        
        SALabel *startAndOver=[SALabel createLabelWithRect:CGRectMake(initLab3.minX-[QGCommon rectWithString:@"距开始:" withFont:12], 14,[QGCommon rectWithString:@"距开始:" withFont:12],[QGCommon rectWithFont:12]) andWithColor:[UIColor whiteColor] andWithFont:12 andWithAlign:NSTextAlignmentCenter andWithTitle:nil];
        [view addSubview:startAndOver];
        
        
        //判断是否在活动期间
        if ([[QGCommon testTimeWithTheTime:_result.item.seckillingInfo.start_time] integerValue]<0)
        {
            NSInteger timeCount=[[QGCommon testTimeWithTheTime:_result.item.seckillingInfo.end_time]integerValue];
            
            //获取天数
            NSInteger days=timeCount/(3600*24);
            //获取剩余小时数
            NSInteger remainingHours=timeCount%(24*3600);
            startAndOver.text=[NSString stringWithFormat:@"距结束:%ld天",(long)days];
            
            [timeLab1 setCountDownTime:remainingHours];
            [timeLab1 start];
            [timeLab2 setCountDownTime:remainingHours];
            [timeLab2 start];
            [timeLab3 setCountDownTime:remainingHours];
            [timeLab3 start];
            
            
        }
        if ([[QGCommon testTimeWithTheTime:_result.item.seckillingInfo.start_time] integerValue]>=0)
        {
            
            int timeInval= abs([[QGCommon testTimeWithTheTime:_result.item.seckillingInfo.start_time] intValue]);
            //获取天数
            NSInteger days2=timeInval/(3600*24);
            //获取剩余小时数
            NSInteger remainingHours2=timeInval%(24*3600);
            startAndOver.text=[NSString stringWithFormat:@"距开始%ld天",(long)days2];
            [timeLab1 setCountDownTime:remainingHours2];
            [timeLab1 start];
            [timeLab2 setCountDownTime:remainingHours2];
            [timeLab2 start];
            [timeLab3 setCountDownTime:remainingHours2];
            [timeLab3 start];
        }
        startAndOver.width=[QGCommon rectWithString:startAndOver.text withFont:12]+10;
        startAndOver.X=initLab3.minX-startAndOver.width;
        nock.frame=CGRectMake(startAndOver.minX-11, startAndOver.minY + 1, 15-2, 15-2);
    }
     view.backgroundColor = COLOR(250, 48, 79, 1);
    [_headerView addSubview:view];
    // 机构
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
    _nameLabel.Y = view.maxY+10;
    //    CGRect rect = [QGCommon rectForString: _nameLabel.text withFont:17 WithWidth:MQScreenW - 20];
    //    _nameLabel.frame = CGRectMake(10, backImageView.maxY+10 , SCREEN_WIDTH-20, rect.size.height);
    
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
    SALabel *labb1=[SALabel createLabelWithRect:CGRectMake(self.view.width - salesWith,_signLabel.maxY+5, salesWith,[QGCommon rectWithFont:13]) andWithColor:PL_UTILS_COLORRGB(160, 160, 160) andWithFont:13 andWithAlign:NSTextAlignmentLeft andWithTitle:nil];
    labb1.font=FONT_SYSTEM(13);
    labb1.text = [NSString stringWithFormat:@"总销量:%@",_result.item.sales_volume];
    
    [self.headerView addSubview:labb1];
    
    CGFloat connetWith = [QGCommon rectWithString:[NSString stringWithFormat:@"已有%@人收藏",_result.item.following_count] withFont:13];
    SALabel *labb=[SALabel createLabelWithRect:CGRectMake(labb1.minX - connetWith - 4 ,_signLabel.maxY+5, connetWith,[QGCommon rectWithFont:13]) andWithColor:PL_UTILS_COLORRGB(160, 160, 160) andWithFont:13 andWithAlign:NSTextAlignmentLeft andWithTitle:nil];
    labb.font=FONT_SYSTEM(13);
    _collectionCount = _result.item.following_count.integerValue;
    labb.text = [NSString stringWithFormat:@"已有%ld人收藏",_collectionCount];
    _collectionCountLabel = labb;
    [self.headerView addSubview:labb];

    
    //线
    UILabel *lba =[[UILabel alloc] initWithFrame:CGRectMake(0,price.maxY+10 , MQScreenW, 1)];
    
    lba.backgroundColor = COLOR(242, 243, 244, 1);
    
    [_headerView addSubview:lba];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, lba.maxY, MQScreenW, 60)];
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
        
        [view1 addSubview:btn];
        
        
    }

    
    [_headerView addSubview:view1];
    
 
    
    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, view1.maxY, SCREEN_WIDTH, 10)];
    line1.backgroundColor = COLOR(242, 243, 244, 1);
    [_headerView addSubview:line1];
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,line1.maxY);
    _tableView1.tableHeaderView = _headerView;


    // 底部收藏分享客服按钮
    NSArray * btnImageArr = @[@"teather_consult",@"teather_nolove",@"teather_share"];
    NSArray * titleArr = @[@"咨询",@"收藏",@"分享"];
    // 总共有3列
    int totalCol = 3;
    CGFloat viewW = 54;
    CGFloat viewH = 54;
    
    // 线
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewH, SCREEN_WIDTH, 1)];
    line.backgroundColor = APPBackgroundColor;
    [self.view addSubview:line];
    
    CGFloat marginX = (self.view.bounds.size.width*2/3 - totalCol * viewW) / (totalCol + 1);
    
    for (int i = 0; i < titleArr.count; i++) {
        
        int col = i % totalCol;
        
        CGFloat x = marginX + (viewW + marginX) * col;
        QGAddBtnView *appView = [QGAddBtnView addBtnView];
        [appView.btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:(UIControlStateNormal)];
        appView.nameLabel.text = titleArr[i];
        appView.frame = CGRectMake(x,line.maxY, viewW, viewH);
        if (i == 1) {
            [appView.btn setImage:[UIImage imageNamed:@"teather_yeslove"] forState:(UIControlStateSelected)];
            if (_result.item.isFollowed.integerValue == 1) {
                appView.btn.selected = YES;
                appView.nameLabel.text = @"已收藏";
            }
        }
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
    UIButton  *button = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW*2/3, line.maxY, MQScreenW/3 , kBtnHeight)];
    button.backgroundColor = COLOR(250, 29, 72, 1);
    [button setTitleFont:FONT_CUSTOM(15)];
    [button setTitle:@"立即购买"];
    button.tag = 1003;
    [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    QGaddFooterView *footer = [[QGaddFooterView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 60)];
    footer.backgroundColor = COLOR(243, 243, 244, 1);
    footer.title.text = @"继续拖动，查看图文详情";
    self.tableView1.tableFooterView = footer;
    
    
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
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)followTeacher:(UIButton *)button{
    @weakify(self);
    
    NSArray *arr = _result.item.priceList;
    QGStoreDetailPriceListModel *model = [arr firstObject];
    QGAddBtnView *BtnView = (QGAddBtnView *)button.superview;
    
    BtnView.nameLabel.text = button.selected ? @"已收藏" : @"收藏";
    int count = button.selected ? ++_collectionCount : --_collectionCount;
    _collectionCountLabel.text = [NSString stringWithFormat:@"已有%d人收藏",count];
    
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
//    vc.shareManager.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}



#pragma mark 添加请求
- (void) addRequest {
    QGSkillDetailDownload *param =[[QGSkillDetailDownload alloc] init];
    param.platform_id = [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    param.goods_id = _goods_id;
    param.seckilling_no =_seckilling_no;
    [QGHttpManager mallSkillStoreDetailWithParam:param Success:^(QGStoreDetailModel *result) {
        NSLog(@"xmq = xmq %@",result);

        // _nameLabel.text = result.item.title;
        //_signLabel.text = result.item.sub_title;
        _result = result;
        _seckilling_no = result.item.seckillingInfo.seckilling_no;
        [self addQGView];
        [_tableView1 reloadData];
      
        
    } failure:^(NSError *error) {
 
        [_tableView1 reloadData];
         [self showTopIndicatorWithError:error];
      
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PL_CODE_WEAK(weakSelf);
    if (tableView.tag==1)
    {
        PL_CELL_NIB_CREATE(QGProductDetailsCell)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        [cell.storeBtnClick addClick:^(UIButton *button) {
            if ([weakSelf loginIfNeeded]) {
                return;
            }
            weakSelf.popview = [[QGAttributePopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andAttrPriceListArray: _result.item.attrList Type:QGPopviewTypeSecondKillDefault];
            weakSelf.popview.priceListsArray = weakSelf.result.item.priceList;
            weakSelf.popview.attrPriceListArray = weakSelf.result.item.attrList;
            weakSelf.popview.imageList =weakSelf.result.item.coverpath;
            weakSelf.popview.str= weakSelf.result.item.seckillingInfo.buy_limit;
            [self.view addSubview:weakSelf.popview];
            
            _popview.addBuyCartBlock = ^(NSString *name , NSString *price ,NSString *num ,NSString *goodsID,NSMutableDictionary *selectBtnDic,QGSingleItemPriceListModel *priceModel,int buyNum,NSMutableArray *attribute_idArray,NSMutableArray *attr_value_idArray,QGPopviewType type)
            {
                weakSelf.isModity = YES;
                //如果商品没有分类 就用默认值
                isOrBuyNow = NO;
                if (goodsID == nil)
                {
                    [cell.storeBtnClick setTitle:@"选择 商品规格" forState:(UIControlStateNormal)];
                }
                else
                {
                    [cell.storeBtnClick setTitle:name forState:(UIControlStateNormal)];
                }
                // 立即购买
                QGShopCarModel *model = [[QGShopCarModel alloc]init];
                model.goodsID = goodsID.integerValue;
                model.goodsCount = buyNum;
                model.goodsNote = name;
                model.goodsName = weakSelf.result.item.title;
                model.goodsPrice = priceModel.sales_price.floatValue;
                model.storeID = weakSelf.result.shopInfo.id.integerValue;
                model.storeName = weakSelf.result.shopInfo.name;
                model.goodsImage = weakSelf.result.item.coverpath;
                model.goodsInventory = priceModel.stock.integerValue;
                model.DeliveryType = weakSelf.result.item.delivery_type.integerValue;
                model.isSeckilling = YES;
                model.isBuyNow = YES;
                model.seckillingNO = weakSelf.seckilling_no;
                QGGoodsMO *mo = [QGGoodsMO MR_createEntity];
                [mo configureWithGood:model];
                QGConfirmOrderViewController *vc = [QGConfirmOrderViewController new];
                if (weakSelf.result.item.delivery_type.integerValue == QGGoodsDeliveryTypeBonded) {
                    vc.type = QGConfirmOrderTypeGlobalAndBuyNow;
                }else{
                    vc.type = QGConfirmOrderTypeSecondkilling;
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];

            
            };
            
        }];
        cell.name.text = _result.shopInfo.name;
        cell.sugn.text = _result.shopInfo.signature;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:_result.shopInfo.cover_photo] placeholderImage:nil];
        
        [cell.orgBtn addClick:^(UIButton *button) {
            QGStoreListViewController *vc = [[QGStoreListViewController alloc] init];
            vc.shop_id = _result.shopInfo.id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
        
        
    }else if(tableView.tag==2) {
        
        PL_CELL_CREATEMETHOD(QGLoadWebCell, @"webSign");
        
     
        cell.webView.scalesPageToFit=YES;
        if (webheight==0) {
            if (_result.item.fruit_desc.length>0)
            {     cell.webView.delegate=self;
                cell.nullLab.hidden=YES;
                [cell.webView loadHTMLString:weakSelf.result.item.fruit_desc baseURL:nil];
            }else {
                cell.nullLab.hidden=NO;
            }
        }
        return cell;
        
    }else {
        
        
        return nil;
    }
    
    
}



#pragma mark webDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
  //  [[NSURLCache sharedURLCache] removeAllCachedResponses];
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    webheight=webViewHeight;
    webView.delegate=nil;

    [_tableView2 reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
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
    }else
    { return MQScreenH/2;
    
    }
    return 0;
 
}



#pragma  mark refreshAnimotion

- (void)bottomButtonClick:(UIButton *)button{
    if ([self loginIfNeeded]) {
        return;
    }
    [self showPopviewWithPopViewType:QGPopviewTypeSecondKilling];
    
}

- (void)showPopviewWithPopViewType:(QGPopviewType)type{
    
    self.popview = [[QGAttributePopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andAttrPriceListArray:self.result.item.attrList Type:type];
    self.popview.priceListsArray = self.result.item.priceList;
    self.popview.attrPriceListArray = self.result.item.attrList;
    self.popview.imageList =self.result.item.coverpath;
    self.popview.str= self.result.item.seckillingInfo.buy_limit;
    [self.view addSubview:self.popview];
    @weakify(self);
    _popview.addBuyCartBlock = ^(NSString *name , NSString *price ,NSString *num ,NSString *goods_id,NSMutableDictionary *selectBtnDic,QGSingleItemPriceListModel *priceModel,int buyNum,NSMutableArray *attribute_idArray,NSMutableArray *attr_value_idArray,QGPopviewType type)
    {
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
        
        if (type != QGPopviewTypeDefault) {
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
            model.isSeckilling = YES;
            model.seckillingNO = self.seckilling_no;
            model.isBuyNow = YES;
            QGGoodsMO *mo = [QGGoodsMO MR_createEntity];
            [mo configureWithGood:model];
            QGConfirmOrderViewController *vc = [QGConfirmOrderViewController new];
            if (self.result.item.delivery_type.integerValue == QGGoodsDeliveryTypeBonded) {
                vc.type = QGConfirmOrderTypeGlobalAndBuyNow;
            }else{
                vc.type = QGConfirmOrderTypeSecondkilling;
            }
            [self.navigationController pushViewController:vc animated:YES];
         }
    };
}


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

    //    [_tableView1 refreshFree];
    //    [_tableView2 refreshFree];
    NSLog(@"eeeeee 释放了");
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

