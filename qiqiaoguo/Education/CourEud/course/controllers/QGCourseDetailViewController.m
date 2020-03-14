//
//  QGCourseDetailViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/17.
//
//

#import "QGCourseDetailViewController.h"
#import "QGCourseDetail.h"
#import "QGaddFooterView.h"
#import "QGTeacherViewController.h"
#import "QGCourseDetailHttpDownload.h"
#import "QGEduOrderViewController.h"
#import "QGOrgViewController.h"
#import "QGCourseTeacherImageModel.h"
#import "QGCourseOrganizationModel.h"
#import "QGCourseInfoModel.h"

#import "QGCommentInfoModel.h"

#import "QGLoadWebCell.h"

#import "QGOrgViewController.h"



#import "QGShowTimeView.h"




#import "QGShareViewController.h"
#import "QGHttpManager+User.h"
#import "BLUChatViewController.h"



@interface QGCourseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    
    CGFloat webheight;
}

/**头视图headerView*/
@property (nonatomic,strong)UIView *headerView;
@property (weak, nonatomic)  UIScrollView *scrollView;
@property (nonatomic,strong) QGCourseDetaiResultModel *result;
@property (nonatomic,strong) QGaddFooterView *footerview;
/**头视图背景图片*/
@property (nonatomic,strong)UIImageView *headerImageView;
@property (weak, nonatomic)  UIButton *placementBtn;
@property (weak, nonatomic)  UIButton *tutorialBtn;
@property (nonatomic, strong) SASRefreshTableView * tableView1;
@property (weak, nonatomic)  UIButton *tagbtn1;
@property (weak, nonatomic)  UIButton *tagbtn2;
@property (nonatomic,strong)SASRefreshTableView *tableView2;
/**班课模型*/
@property (nonatomic,strong)QGCourseInfoModel *courseInfoModel;
@property (nonatomic,strong) UILabel *TitleLab;//主题
@property (nonatomic,strong) UILabel *priceLab;//价格
@property (nonatomic,assign)BOOL isTableView1;
@property (nonatomic,assign)BOOL isTableView2;
@property (nonatomic,strong) UIButton *lablebtn;
//新需求添加上拉加载详情
@property (nonatomic,strong)UIScrollView *bottomScrollView;
@property (nonatomic,strong) UIButton *sign;
@end

@implementation QGCourseDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createNavTitle:@"课程详情"];

    [self createReturnButton];
    webheight=0;
    _isTableView1 = YES;

    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.tableView1];
    [self.bottomScrollView addSubview:self.tableView2];
    
    [self addrequestDataMethod];;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(UIScrollView *)bottomScrollView
{
    if ( _bottomScrollView== nil)
    {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY-54)];
        _bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,(SCREEN_HEIGHT-self.navImageView.maxY-54)*2);
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
        _tableView2 = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-54-64, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY-54) style:UITableViewStylePlain];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tag=2;
        _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView2;
}

- (void)qg_addui {
    
    
    _headerView = [[UIView alloc]init];
    _headerView.userInteractionEnabled = YES;
    
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.62)];
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.cover_path] placeholderImage:nil];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView addSubview:_headerImageView];
    _TitleLab = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
     _TitleLab.textColor = QGTitleColor;
 
    if ([_result.item.type isEqualToString:@"3"] || [_result.item.type isEqualToString:@"4"]) {
       _TitleLab.attributedText = [self configTitle:_result.item.title];
    }else {
        _TitleLab.text = _result.item.title ;
    }
    _TitleLab.numberOfLines = 2;
    _TitleLab.width = SCREEN_WIDTH-20;
    [_TitleLab sizeToFit];
    _TitleLab.X = 10;
    _TitleLab.Y = _headerImageView.maxY+10;
    
    [_headerView addSubview:_TitleLab];
    
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _TitleLab.maxY+5, MQScreenW, 20)];

    _priceLab.textColor = [UIColor colorFromHexString:@"ff3859"];
    _priceLab.font = [UIFont boldSystemFontOfSize:15];
    _priceLab.text = [NSString stringWithFormat:@"￥%@",_result.item.class_price];
    _priceLab.numberOfLines =0;
    [_headerView addSubview:_priceLab];
    // 线
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, _priceLab.maxY+5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = QGlineBackgroundColor;
    [_headerView addSubview:line];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for ( QGCourseTagModel *tag  in _result.item.tagList) {
        [arr addObject:tag.tag_name];
    }
    
    QGTypeView* colorView = [[QGTypeView alloc] initWithFrame:CGRectMake(0,line.maxY, MQScreenW, 45) andDatasource:arr :nil];
    
    ;
    
    if (_result.item.tagList.count>0) {
        [_headerView addSubview:colorView];
        colorView.frame = CGRectMake(0, line.maxY, MQScreenW,44);
    }else {
        
        colorView.frame = CGRectMake(0, line.maxY, MQScreenW, 1);
        
    }
    
    
    _headerView.frame = CGRectMake(0, 0,MQScreenW, colorView.maxY);
    
    _tableView1.tableHeaderView = _headerView;
    // 线
    
    CGFloat lineDistance = 54;
    if(IS_IPhoneX_All){
        lineDistance = 83;
    }
    CGFloat Line1Y = SCREEN_HEIGHT - lineDistance;
    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Line1Y, SCREEN_WIDTH, 1)];
    line1.backgroundColor = APPBackgroundColor;
    [self.view addSubview:line1];
    // 底部收藏分享咨询按钮
   
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
     
      
        
        [self.view addSubview:appView];
        [appView.btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:(UIControlStateNormal)];
        appView.nameLabel.text = titleArr[i];
        if (i == 1) {
            [appView.btn setImage:[UIImage imageNamed:@"teather_yeslove"] forState:UIControlStateSelected];
            if (_result.item.isFollowed.integerValue == 1) {
                appView.btn.selected = YES;
                appView.nameLabel.text = @"已收藏";
            }
        }
        appView.frame = CGRectMake(x,line1.maxY, viewW, viewH);
            appView.btn.tag = 2000+i;
        [appView.btn addTarget:self action:@selector(bottomBtnClick11:) forControlEvents:UIControlEventTouchUpInside];
         appView.tag = 2000+i;
         PL_CODE_WEAK(ws)
        
        __weak __typeof(appView)viewBtn = appView;
        [appView addClick:^(UIButton *button) {
            
            [ws bottomBtnClick11:viewBtn.btn];
        }];

     
    
    }
    
    
    _sign = [[UIButton alloc] initWithFrame:CGRectMake(MQScreenW*2/3, SCREEN_HEIGHT - 54, MQScreenW*1/3 , 54)];
    _sign.backgroundColor = COLOR(250, 29, 73, 1);
    [_sign setBackgroundImage:[UIImage imageWithColor:COLOR(224, 225, 226, 1)] forState:UIControlStateDisabled];
    PL_CODE_WEAK(weakSelf)
    [_sign setTitle:@"立即报名"];
    _sign.enabled = YES;

    if (![_result.item.sign_status isEqualToString:@"1" ]) {
        _sign.backgroundColor = COLOR(224, 225, 226, 1);
        [_sign setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [_sign setTitle:_result.item.sign_status_text];
        _sign.enabled = NO;
    }
    
    
    [_sign addClick:^(UIButton *button) {
        [weakSelf  addsignBtn];
    }];
    [_sign setTitleColor:[UIColor whiteColor]];
    [self.view addSubview:_sign];
    
    QGaddFooterView *footer = [[QGaddFooterView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 60)];

    footer.title.text = @"继续拖动，查看课程详情";
    self.tableView1.tableFooterView = footer;
    
}
- (void) addsignBtn {
    if ([self loginIfNeeded]) {
        return;
    };
    QGEduOrderViewController *vc =[[QGEduOrderViewController alloc] init];
  
    vc.max_student_number = _result.item.max_student_number;
    vc.apply_student_number = _result.item.apply_student_number;
    vc.avilibale_student_number = _result.item.avilibale_student_number;
    vc.cover_path = _result.item.cover_path;
    vc.org_name = _result.item.org_name;
    vc.sign = _result.item.category_name;
    vc.class_price = _result.item.class_price;
    vc.name= _result.item.title;
    vc.eduId = _result.item.id;
    vc.eduSid = _result.item.sid;
    vc.type = _result.item.type; 
    [self.navigationController pushViewController:vc animated:YES];
  }

- (void)bottomBtnClick11:(UIButton *)btn {
    if ([self loginIfNeeded]) {
        return;
    }
  
     if (btn.tag == 2000) {
         //咨询
        [self tapAndService];
      }else if (btn.tag == 2001){
        // 关注老师
       [self followTeacher:btn];
      }else if (btn.tag == 2002){
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
    vc.headModel = _result;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)followTeacher:(UIButton *)button{
    
    button.selected = !button.selected;
    QGAddBtnView *BtnView = (QGAddBtnView *)button.superview;
    
    BtnView.nameLabel.text = button.selected ? @"已关注" : @"关注";
    @weakify(self);
    [QGHttpManager CollectionWithCollectType:UserCollectionTypeCourse objectID:_result.item.id.integerValue isCollection:button.selected Success:^(NSURLSessionDataTask *task, id responseObject) {
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self showTopIndicatorWithError:error];
        button.selected = !button.selected;
        BtnView.nameLabel.text = button.selected ? @"已关注" : @"关注";
    }];
    
    
}

- (void)shareOrg{
    
    QGShareViewController *vc = [QGShareViewController new];
    vc.shareObject = self.result.item;
    vc.shareManager.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (void)addrequestDataMethod {
    QGCourseDetailHttpDownload *download = [[QGCourseDetailHttpDownload alloc]init];
    download.course_id = self.course_id;
    
    [[SAProgressHud sharedInstance] showWaitWithWindow];
    [QGHttpManager courseDetailInfoWithParam:download success:^(QGCourseDetaiResultModel *result) {
        
        
        self.result = result;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:result.item.cover_path] placeholderImage:nil];
        [_tableView1 reloadData];
        
        [self qg_addui];
        [_tableView2 reloadData];   
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (tableView.tag ==1) {
         static NSString *ShopInfoCell=@"CourseDetail";
        QGCourseDetail *cell =[tableView dequeueReusableCellWithIdentifier:ShopInfoCell];
          if (!cell)
        {
            cell=[[NSBundle mainBundle]loadNibNamed:@"QGCourseDetail" owner:self options:nil][0];
        }
    
        PL_CODE_WEAK(weakSelf);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.eduImge sd_setImageWithURL:[NSURL URLWithString:_result.item.org_head_img] placeholderImage:nil];
        cell.rangLab.text= _result.item.student_range;
        [cell.teatherBtn addClick:^(UIButton *button) {
            QGTeacherViewController *teater = [[QGTeacherViewController alloc] init];
            teater.teacher_id = weakSelf.result.item.teacher_id;
            [weakSelf.navigationController pushViewController:teater animated:YES];
        }];
    
        
        [cell.timeBtn addClick:^(UIButton *button) {
            QGShowTimeView *view = [[QGShowTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            view.itemlist = weakSelf.result.item;
            
            QGCourseDetSectionListModel *model = weakSelf.result.item.sectionList[indexPath.row];
            view.sectionList= model;
            [weakSelf.view addSubview:view];
        }];
        [cell.orgBtnClick addClick:^(UIButton *button) {
            QGOrgViewController *vc = [[QGOrgViewController alloc] init];
            vc.org_id = weakSelf.result.item.org_id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        cell.timeLab.text = _result.item.teacher_name;
        cell.adress.text =  _result.item.address;
        cell.theatherName.text = _result.item.section;
        cell.orgName.text = _result.item.org_name;
        cell.orgadress.text = _result.item.org_address;
        cell.studentCount.text = [NSString stringWithFormat:@"%@人",_result.item.max_student_number];
        cell.yearCount.text = _result.item.org_signature;
        
        if (_result.item >0) {
            
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        
        
        return cell;
    }  else {
        PL_CELL_CREATE(QGLoadWebCell)
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.webView.delegate=self;
        cell.webView.scalesPageToFit=YES;
        if (webheight==0) {
            if (_result.item.course_desc.length>0)
            {
                cell.nullLab.hidden = YES;
                [cell.webView loadHTMLString:self.result.item.course_desc baseURL:nil];
            }else {
                
                cell.nullLab.hidden = NO;
            }
        }
             return cell;
    }
    
    
}
#pragma mark webDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.width= MQScreenW-10;
    frame.size.height = 1;
    frame.origin.x = 5;
    webView.frame = frame;
    
    frame.size.height = webView.scrollView.contentSize.height ;
    webView.frame = frame;
    webheight=webView.scrollView.contentSize.height;
    
    webView.delegate=nil;
    [_tableView2 reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==1) {
        return 420;
    }
    
    else  if (webheight>0)
    {
        return webheight;
    }else
        return MQScreenH/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
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

#pragma  mark refreshAnimotion
- (void)pullUpAnimotion
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-self.navImageView.maxY-54);
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
        self.navTitleLabel.text =@"课程详情";
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.tableView1 == scrollView) {
        
        CGFloat yOffset = self.tableView1.contentOffset.y;
        //下拉图片放大
        if (yOffset < 0) {
            _headerImageView.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, SCREEN_WIDTH*0.62- yOffset);
        }
        else
        {
            _headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_WIDTH*0.62);
        }
    }
    
    if (_isTableView1)
    {
        if (self.tableView1.contentSize.height>SCREEN_HEIGHT-self.navImageView.maxY-54-54)
        {
            if (scrollView.contentOffset.y+SCREEN_HEIGHT-self.navImageView.maxY-54>self.tableView1.contentSize.height+54)
            {
                [self pullUpAnimotion];
            }
        }
    }else
    {
        if (_tableView2.contentOffset.y<-54)
        {
            [self pullDownAnimotion];
        }
    }
    
}

@end
