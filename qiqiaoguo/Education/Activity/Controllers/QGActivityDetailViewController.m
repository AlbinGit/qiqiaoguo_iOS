//
//  QGActivityDetailViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/6.
//
//

#import "QGActivityDetailViewController.h"
#import "QGActivityDetailCell.h"
#import "QGaddFooterView.h"
#import "QGActlistDetailModel.h"
#import "QGNoteDetailCell.h"

#import "QGActOrderViewController.h"

#import "QGHttpManager+User.h"
#import "QGShareViewController.h"
#import "BLUChatViewController.h"
#import "QGMessageCenterViewController.h"
#import "QGStoreListViewController.h"
#import "BLUCircleDetailAsyncViewController.h"
#import "BLUCircleDetailViewController.h"
#import "BLUCircleDetailMainViewController.h"

#import "QGLoadWebCell.h"
#import "QGApplyFieldListCell.h"
#import "QGActShopInfoCell.h"
#define kBtnHeight 54
@interface QGActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIWebViewDelegate>{
     CGFloat webheight;
}

/**头视图headerView*/
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)SALabel *navTitle;
/**头视图背景图片*/
@property (nonatomic,strong)UIImageView *headerImageView;
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property (nonatomic,strong) UILabel *TitleLab;//主题
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic,strong) UILabel *priceLab;//价格
@property (nonatomic ,strong) UIButton *collectionbtn;//收藏
@property (nonatomic,strong)QGActlistDetailResultModel *result;
@property (nonatomic, strong) SASRefreshTableView * tableView1;
@property (nonatomic,assign)BOOL isTableView1;
@property (nonatomic,strong)SASRefreshTableView *tableView2;
@property (nonatomic,strong)  SAButton * returnBtn;
@property (nonatomic,strong) UIButton *signtips;
@property (nonatomic,strong) UIButton *sign;
@property (nonatomic,strong) UIView *viewline;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong) UIButton *messageicon;


//新需求添加上拉加载详情
@property (nonatomic,strong)UIScrollView *bottomScrollView;
@end

@implementation QGActivityDetailViewController
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
 
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(242, 242, 242);
    [self initBaseData];
     webheight = 0;
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.tableView2];
    _isTableView1 = YES;
    [self createNavInfo];
    [self requestFirstDataMethod];

}

- (void)createNavInfo {
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
    [self.view addSubview:_navBGView];
    //返回按钮
    SAButton * returnBtn = [SAButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, self.navImageView.height - 49, 50, 49);
    
    [returnBtn setNormalImage:@"round-back-icon"];
    PL_CODE_WEAK(ws)
    [returnBtn addClick:^(SAButton *button) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [_navBGView addSubview:returnBtn];
     _returnBtn = returnBtn;
    _navTitle = [[SALabel alloc]init];
    _navTitle.frame = CGRectMake(60, self.navImageView.height - 49, SCREEN_WIDTH - 60 * 2, 49);
    _navTitle.numberOfLines = 1;
    _navTitle.text = @"";
    _navTitle.textAlignment = NSTextAlignmentCenter;
    _navTitle.font = [UIFont systemFontOfSize:17];
    _navTitle.textColor = [UIColor blackColor];
    [self.view addSubview:_navTitle];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MQScreenW, 1)];
    vv.backgroundColor =COLOR(243, 243, 243, 0);
    [_navBGView addSubview:vv];
     self.viewline = vv;
     [self addMesseageBtnInTheView:_navBGView];

}
- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-7-40,  self.navImageView.height - 49, 40, 40);
    bottomView.backgroundColor = [UIColor clearColor];
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [messageBtn setBackgroundImage:[UIImage imageNamed:@"background_home_classification"] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"message_image"] forState:UIControlStateNormal];
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(6, 0, 20, 20);
    messageBtn.centerX = 20;
    messageBtn.centerY = 20;
    [bottomView addSubview:messageBtn];
    _messageicon = messageBtn;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
}

-(void)btnClick{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(UIScrollView *)bottomScrollView
{
    if ( _bottomScrollView== nil)
    {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-54)];
        _bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT-54)*2);
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
        _tableView1 =[[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-54) style:UITableViewStyleGrouped];
           _tableView1.backgroundColor = COLOR(242, 243, 243, 1);
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
        _tableView2 = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-54) style:UITableViewStylePlain];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tag=2;
        _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
     
    }
    return _tableView2;
}

-(void)qg_addui {
    _headerView = [[UIView alloc]init];
    _headerView.userInteractionEnabled = YES;
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MQScreenW*5/8)];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.userInteractionEnabled = YES;
     _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView addSubview:_headerImageView];
    _TitleLab = [[UILabel alloc] init];
    _TitleLab.text =@"三洋产妇待产包护理包 产妇卫生巾组合 产妇入院必备";
    CGRect rect = [QGCommon rectForString:_TitleLab.text withFont:16 WithWidth:MQScreenW];
    _TitleLab.font = [UIFont systemFontOfSize:16];
    _TitleLab.numberOfLines = 2;
    _TitleLab.frame = CGRectMake(10, _headerImageView.maxY+5, MQScreenW-20, rect.size.height);
    [_headerView addSubview:_TitleLab];
    _signtips = [[UIButton alloc ] init];
    _signtips.backgroundColor = COLOR(0, 0, 0, 0.5);
     [_signtips setTitleFont:[UIFont systemFontOfSize:13]];
    _signtips.layer.masksToBounds = YES;
    _signtips.layer.cornerRadius = 11;
    [_signtips  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_headerImageView addSubview:_signtips];
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _TitleLab.maxY+5, MQScreenW, 20)];
    _priceLab.textColor = [UIColor grayColor];
    _priceLab.font = [UIFont systemFontOfSize:13];
    _priceLab.numberOfLines =0;
    [_headerView addSubview:_priceLab];
    [_signtips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@10);
        make.height.equalTo(@20);
        make.bottom.equalTo(_headerImageView).offset(-20);
    }];
    _collectionbtn = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW-90, _TitleLab.maxY+5, 90, 20)];
    [_collectionbtn setImage:[UIImage imageNamed:@"activity_detail_icon"] forState:(UIControlStateNormal)];
    [_collectionbtn setTitle:@"收藏"];
    _collectionbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
    [_collectionbtn setTitleFont:FONT_SYSTEM(12)];
    [_collectionbtn setTitleColor:QGCellContentColor  forState:(UIControlStateNormal)];
    [_headerView addSubview:_collectionbtn];
    //
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, _collectionbtn.maxY+10, SCREEN_WIDTH, 60);
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, self.view.width, 1);
    lineView.backgroundColor =  RGB(242, 242, 242);
    [view addSubview:lineView];
    
    //更多
    UIButton* moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    [moreBtn setTitle:@"去活动现场看看"];
    [moreBtn setTitleFont:FONT_CUSTOM(15)];
    [moreBtn setTitleColor:[UIColor colorFromHexString:@"999999"]];
    [moreBtn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:(UIControlStateNormal)];
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, -215);
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [view addSubview:moreBtn];
    NSString *str = self.result.more[@"activityCircleId"];
    PL_CODE_WEAK(ws)
    [moreBtn addClick:^(UIButton *button) {
        BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:str.integerValue];
        
        [ws.navigationController pushViewController:vc animated:YES];
    }];
    UIView *lb =[[UIView alloc] initWithFrame:CGRectMake(0, moreBtn.maxY, self.view.width, 10)];
    lb.backgroundColor =COLOR(242,243, 243, 1);
    [view addSubview:lb];
    [_headerView addSubview:view];
    _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, view.maxY);
    _tableView1.tableHeaderView = _headerView;
    QGaddFooterView *footer = [[QGaddFooterView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 60)];
    footer.backgroundColor = COLOR(242, 243, 244, 1);
    footer.title.text = @"继续拖动，查看活动详情";
    self.tableView1.tableFooterView = footer;
     // 底部收藏分享咨询按钮
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54, SCREEN_WIDTH, 1)];
    line.backgroundColor = QGBottomBackgroundColor;
    [self.view addSubview:line];
        NSArray * btnImageArr = @[@"teather_consult",@"teather_nolove",@"teather_share"];
        NSArray * titleArr = @[@"咨询",@"收藏",@"分享"];
        // 总共有3列
        int totalCol = 3;
        CGFloat viewW = 54;
        CGFloat viewH = 54;
        CGFloat marginX = (self.view.bounds.size.width*2/3 - totalCol * viewW) / (totalCol + 1);
        for (int i = 0; i < titleArr.count; i++) {
            int col = i % totalCol;
            
            CGFloat x = marginX + (viewW + marginX) * col;
            QGAddBtnView *appView = [QGAddBtnView addBtnView];
            [appView.btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:(UIControlStateNormal)];
            appView.nameLabel.text = titleArr[i];
            if (i == 1) {
                [appView.btn setImage:[UIImage imageNamed:@"teather_yeslove"] forState:UIControlStateSelected];
                if (_result.item.isFollowed.integerValue == 1) {
                    appView.btn.selected = YES;
                    appView.nameLabel.text = @"已收藏";
                }
            }
            appView.frame = CGRectMake(x,line.maxY, viewW, viewH);
            [appView.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            appView.btn.tag = 2000+i;
            appView.tag = 2000+i;
            PL_CODE_WEAK(ws)
            
            __weak __typeof(appView)viewBtn = appView;
            [appView addClick:^(UIButton *button) {
                
                [ws buttonClick:viewBtn.btn];
            }];
            [self.view addSubview:appView];
        }
    _sign = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW*2/3, SCREEN_HEIGHT - 54, MQScreenW*1/3 , kBtnHeight)];
    _sign.backgroundColor = COLOR(250, 29, 73, 1);
    [_sign setBackgroundImage:[UIImage imageWithColor:COLOR(224, 225, 226, 1)] forState:UIControlStateDisabled];
    PL_CODE_WEAK(weakSelf)
    [_sign setTitle:@"立即报名"];
    _sign.enabled = YES;
    [_sign addClick:^(UIButton *button) {
        [weakSelf  addsignBtn];
    }];
    [_sign setTitleColor:[UIColor whiteColor]];
    [self.view addSubview:_sign];
}
- (void) addsignBtn {
    if ([self loginIfNeeded]) {
        return;
    };
    QGActOrderViewController *vc =[[QGActOrderViewController alloc] init];
    vc.ticketList = _result.item.ticketList;
    vc.shopInfo = _result.shopInfo;
    vc.activity_id=  _result.item.id;
    vc.applyFieldList = _result.item.applyFieldList;
    vc.name= _result.shopInfo.name;
    vc.items = _result.item;
    [self.navigationController pushViewController:vc animated:YES];
 }


- (void)buttonClick:(UIButton *)button{
    
    if ([self loginIfNeeded]) {
        return;
    }
    
    if (button.superview.tag == 2000) {
        // 咨询
        [self tapAndService];
    }else if (button.superview.tag == 2001){
        // 收藏
        [self followTeacher:button];
    }else if (button.superview.tag == 2002){
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
    button.selected = !button.selected;
    QGAddBtnView *BtnView = (QGAddBtnView *)button.superview;
    BtnView.nameLabel.text = button.selected ? @"已收藏" : @"收藏";
    NSInteger index = _collectionbtn.title.integerValue;
    NSInteger count = button.selected ?  ++index : --index;
    [_collectionbtn setTitle:[NSString stringWithFormat:@"%ld人收藏",(long)count]];
    @weakify(self);
    [QGHttpManager CollectionWithCollectType:UserCollectionTypeActiv objectID:_result.item.id.integerValue isCollection:button.selected Success:^(NSURLSessionDataTask *task, id responseObject) {
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        button.selected = !button.selected;
        BtnView.nameLabel.text = button.selected ? @"已收藏" : @"收藏";
        [_collectionbtn setTitle:[NSString stringWithFormat:@"%ld人收藏",(long)count]];
    }];
    
}

- (void)shareOrg{
     QGShareViewController *vc = [QGShareViewController new];
    vc.shareObject = self.result.item;
    vc.shareManager.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (void)requestFirstDataMethod {
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    QGActlistDetailDownload *param = [[QGActlistDetailDownload alloc] init];
    
    param.activity_id = self.activity_id;
    [QGHttpManager actdetailWithParam:param success:^(QGActlistDetailResultModel *result) {
        [self.bottomScrollView addSubview:self.tableView1];
        _result = result;
        [self qg_addui];
        _TitleLab.text = result.item.title;
        if (result.item.user_count.integerValue > 0) {
            [_signtips setTitle:[NSString stringWithFormat:@"  报名:%@/%@人     ",result.item.apply_count,result.item.user_count]];
        }else{
            [_signtips setTitle:[NSString stringWithFormat:@"  已报名:%@人     ",result.item.apply_count]];
        }
        NSString *str = [NSString stringWithFormat:@"%@",result.item.price];
        _priceLab.text=[NSString stringWithFormat:@"%@ %@",str,result.item.price_tail];
        [QGCommon setLableColorAndSize:[NSString stringWithFormat:@"%@",str] andLab:_priceLab];
        [_collectionbtn setTitle:[NSString stringWithFormat:@"%@人收藏",result.item.following_count]];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.coverPicPop] placeholderImage:nil];
        if (![result.item.sign_status isEqualToString:@"1" ]) {
            _sign.backgroundColor = COLOR(224, 225, 226, 1);
            [_sign setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [_sign setTitle:result.item.sign_status_text];
            _sign.enabled = NO;
        }
        
     
        [_tableView1 reloadData];
        
        [_tableView2 reloadData];
        
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];

    
}

- (void)bottomBtnClick:(UIButton *)btn {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1)
    {
        return 3;
    } else
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag==1)
    {
        if (section==1) {
            return _result.item.ticketList.count;
        }else
        return 1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag ==1) {
        if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0) {
            
            static NSString *act=@"actCell";
            QGActivityDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:act];
            
            if (!cell)
            {
                cell=[[NSBundle mainBundle]loadNibNamed:@"QGActivityDetailCell" owner:self options:nil][0];
            }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.item = _result.item;
        return cell;

        }else if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==1) {
            PL_CELL_CREATE(QGApplyFieldListCell)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.ticketListModel = _result.item.ticketList[indexPath.row];
            return cell;
        }else {

            static NSString *ShopInfoCell=@"ShopInfoCell";
            QGActShopInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:ShopInfoCell];
            if (!cell)
            {
                cell=[[NSBundle mainBundle]loadNibNamed:@"QGActShopInfoCell" owner:self options:nil][0];
            }
            [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:_result.shopInfo.cover_photo] placeholderImage:nil];
            cell.shopName.text =_result.shopInfo.name;
            cell.shopSign.text = _result.shopInfo.signature;
            if (_result.shopInfo==nil) {
                cell.labline.hidden = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else {
        PL_CELL_CREATEMETHOD(QGLoadWebCell, @"webSign")
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.webView.delegate=self;
        cell.webView.scalesPageToFit=YES;
        if (webheight==0) {
            if (_result.item.note)
            {
                cell.nullLab.hidden=YES;
                [cell.webView loadHTMLString:_result.item.note baseURL:nil];
            }else {
                cell.nullLab.hidden=NO;
            }
        }
        return cell;
        
    }
 }



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==1) {
        if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0) {
            return 181;}
        else if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==1) {
                return 44;
            }
        else{
                  return 80;
            }
        
    } else{
        
        if (webheight>0)
        {
               return webheight;
        }else
    
        return MQScreenH/2;
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section]>0&&section==1) {
        return 10;
        
    }else
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag ==1) {
        if ([self tableView:tableView numberOfRowsInSection:section]>0&&section==1) {
            return 44;}
        else
                
                return 0.1;
         }else {
           return 0.1;
         }
        
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vc =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 44)];
     vc.backgroundColor = [UIColor whiteColor];
    if ([self tableView:tableView numberOfRowsInSection:section]>0&&section==1){
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MQScreenW, 44)];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        lab.text = @"价格";
        [vc addSubview:lab];
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0,44, MQScreenW, 1)];
        line1.backgroundColor =COLOR(233, 233,234, 1);
        [vc addSubview:line1];
    }
    
  
    return vc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==2) {
        
        QGStoreListViewController *vc =[[QGStoreListViewController alloc] init];
        vc.shop_id = _result.shopInfo.id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


#pragma  mark refreshAnimotion
- (void)pullUpAnimotion
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-54);
    } completion:^(BOOL finished) {
        _isTableView1=NO;
        _navTitle.text =@"图文详情";
        self.viewline.backgroundColor =COLOR(243, 243, 243, 1);
        [_returnBtn setImage:[UIImage imageNamed:@"icon_classification_back"]];
      //   [_messageicon setImage:[UIImage imageNamed:@""]];
        [self.tableView2 reloadData];
        _navBGView.backgroundColor = RGBA(255, 255, 255 ,1);
    }];
}
- (void)pullDownAnimotion
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        //结束加载
        _isTableView1=YES;
        _navTitle.text = @"";
        [_returnBtn setNormalImage:@"round-back-icon"];
          self.viewline.backgroundColor =COLOR(243, 243, 243, 0);
      //   [_messageicon setImage:[UIImage imageNamed:@"message_image"]];
        _navBGView.backgroundColor = RGBA(255, 255, 255 ,0);
    }];
}

#pragma mark 顶部视图拉伸
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    
    
    if (self.tableView1 == scrollView) {
        
        CGFloat yOffset = self.tableView1.contentOffset.y;
        //下拉图片放大
        if (yOffset < 0) {
            _headerImageView.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, MQScreenW*5/8 - yOffset);
        }
        else
        {
            _headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MQScreenW*5/8);
        }
    }
    

    if (_isTableView1){
        
        if (self.tableView1.contentSize.height>SCREEN_HEIGHT-54-60){
            if (scrollView.contentOffset.y+SCREEN_HEIGHT-54>self.tableView1.contentSize.height+54){
                [self pullUpAnimotion];
            }
        }
    }else{
        
        if (_tableView2.contentOffset.y<-54){
            [self pullDownAnimotion];
        }
    }   
    
    
}
#pragma mark webDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGRect frame = webView.frame;
    frame.size.width= MQScreenW-10;
    frame.size.height = 1;
    frame.origin.x = 5;
    frame.origin.y = 5;
    webView.frame = frame;
    
    frame.size.height = webView.scrollView.contentSize.height+64;
    webView.frame = frame;
//    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webheight=webView.scrollView.contentSize.height;
    
    webView.delegate=nil;
    [_tableView2 reloadData];
}


@end
