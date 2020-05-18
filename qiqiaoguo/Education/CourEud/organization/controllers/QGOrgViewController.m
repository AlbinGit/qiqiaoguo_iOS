//
//  QGOrgViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/2.
//
//

#import "QGOrgViewController.h"
#import "QGOrgInfoModel.h"


#import "QGTeacherListModel.h"

#import "QGTeacherViewController.h"

#import "QGQrgHttpDownload.h"

#import "QGOrgAllCourseViewController.h"

#import "QGSearchResultViewController.h"
#import "QGOrgAllCourseViewController.h"

#import "QGOrgAllTeacherViewController.h"

#import "QGOrgAllTeacherViewController.h"
#import "QGOrgTeacherTableViewCell.h"
#import "QGaddFooterView.h"
#import "QGTeacherViewController.h"


#import "QGCourseDetailViewController.h"

#import "QGTeacherListTableViewCell.h"
#import "QGTeacherCouseTableViewCell.h"
#import "BLUChatViewController.h"
#import "QGNoteDetailCell.h"
#import "QGHttpManager+User.h"
#import "QGShareViewController.h"
#import "QGLoadWebCell.h"
@interface QGOrgViewController ()<UIWebViewDelegate>{
 CGFloat webheight;
}

/**总tableView*/

/**总数据源*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/**分区头视图数据源*/
@property (nonatomic,strong)NSArray *headerArray;
/**分区尾视图数据源*/
@property (nonatomic,strong)NSMutableArray *footerArray;
/**老师数据源*/
@property (nonatomic,strong)NSArray *teacherListArray;

@property (nonatomic,strong)NSArray *commentListArray;
@property (nonatomic,strong)SALabel *navTitle;
@property (nonatomic, strong) SASRefreshTableView * tableView1;
@property (nonatomic,strong)SASRefreshTableView *tableView2;
@property (nonatomic,strong)  SAButton * returnBtn;
@property (nonatomic,strong) UIView *viewline;
@property (nonatomic,strong) UITextView *textNote;
//新需求添加上拉加载详情
@property (nonatomic,strong)UIScrollView *bottomScrollView;
/**头视图headerView*/
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,assign)BOOL isTableView1;
/**头视图背景图片*/
@property (nonatomic,strong)UIImageView *headerImageView;
/**机构头像*/
@property (nonatomic,strong)UIImageView *faceImageView;
/**机构头像*/
@property (nonatomic,strong)UIImageView *faceImageView1;
/**机构名称*/
@property (nonatomic,strong)UILabel *orgNameLabel;
/**机构签名*/
@property (nonatomic,strong)UILabel *orgSignatureLabel;
@property (nonatomic,strong)UIButton *orgadress;

/**尾视图footerView*/
@property (nonatomic,strong)UIView *footerView;
/**机构ID*/
@property (nonatomic,strong)UILabel *orgIDLabel;

/**机构信息模型*/
@property (nonatomic,strong)QGOrgInfoModel *infoModel;
/**收藏按钮*/
@property (nonatomic,strong)UIButton *collectBtn;
/**收藏按钮图片*/
@property (nonatomic,strong)UIImageView *collectImageView;
/**收藏按钮文字*/
@property (nonatomic,strong)UILabel *collectLabel;
/**评论数量*/
@property (nonatomic,copy)NSString *commentNumStr;
/**评论cell高度数据源*/
@property (nonatomic,copy)NSMutableArray *commentCellHeightArray;
@property (nonatomic,strong) QGOrgfirstResultModel *result;
@property (nonatomic,strong) UIButton *lablebtn;
@property (nonatomic,strong) UIButton *lablebtn1;
@property (nonatomic,strong) QGTeacherListModel *teathermodel;
@property (nonatomic,strong) UIView *navBGView;

@property (nonatomic,strong) UIVisualEffectView *effectview;

@end

@implementation QGOrgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initBaseData];

    webheight = 0;
    [self p_createFooterView];
    [self p_createUI];
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, Height_TopBar)];
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
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, Height_TopBar, MQScreenW, 1)];
    vv.backgroundColor =COLOR(243, 243, 243, 0);
    [self.view addSubview:vv];
    self.viewline = vv;

   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
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
        _tableView1 =[[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-54-Height_BottomSafe) style:UITableViewStyleGrouped];
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
        _tableView2 = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT+kTopEdgeHeight, SCREEN_WIDTH, SCREEN_HEIGHT-54-Height_BottomSafe) style:UITableViewStylePlain];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tag=2;
        _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView2;
}
- (void)p_createHeaderView
{
      _dataArray = [[NSMutableArray alloc]init];
    _commentCellHeightArray = [NSMutableArray array];
    _headerView = [[UIView alloc]init];
    _headerView.userInteractionEnabled = YES;
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -54, SCREEN_WIDTH, 250+54)];
    _headerImageView.image = [UIImage imageNamed:@"QGBackGroundImage"];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectview.frame = _headerImageView.bounds;
    [_headerImageView addSubview:_effectview];
    [_headerView addSubview:_headerImageView];
    
    
    // 头像
    _faceImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, 35, 80, 80)];
    _faceImageView1.layer.cornerRadius = 40.f;
    _faceImageView1.layer.masksToBounds = YES;
    _faceImageView1.backgroundColor = COLOR(255, 255, 255, 0.4);
    [_headerView addSubview:_faceImageView1];
    
    
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 74, 74)];
    _faceImageView.layer.cornerRadius = 37.f;
    _faceImageView.layer.masksToBounds = YES;
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.head_img] placeholderImage:nil];
    [_faceImageView1 addSubview:_faceImageView];
   //_faceImageView.image =[UIImage imageWithImage: _faceImageView.image borderWidth:10 borderColor:COLOR(255, 255, 255, 0.5)];

    _orgNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _faceImageView1.maxY+5, SCREEN_WIDTH, 15)];
    _orgNameLabel.textColor = [UIColor whiteColor];
    _orgNameLabel.font = [UIFont systemFontOfSize:16];
    _orgNameLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_orgNameLabel];
    
    _orgSignatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _orgNameLabel.maxY, SCREEN_WIDTH, 40)];
    _orgSignatureLabel.textColor = [UIColor whiteColor];
    _orgSignatureLabel.numberOfLines = 2;
    _orgSignatureLabel.textAlignment = NSTextAlignmentCenter;
    _orgSignatureLabel.font = [UIFont systemFontOfSize:11];
    
    [_headerView addSubview:_orgSignatureLabel];
    
    SAButton * btn = [[SAButton alloc] initWithFrame:CGRectMake(0, _orgSignatureLabel.maxY, SCREEN_WIDTH - 20, 44)];
    [btn setImage:[UIImage imageNamed:@"orgadress"] forState:(UIControlStateNormal)];
    btn.titleLabel.font = FONT_CUSTOM(11);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [_headerView addSubview:btn];
    
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"" forState:(UIControlStateNormal)];
    _orgadress = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_orgSignatureLabel);
        make.bottom.equalTo(_orgSignatureLabel).offset(15);
        make.width.equalTo(_orgSignatureLabel );
    }];
  
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerImageView.maxY - 50, SCREEN_WIDTH, 50)];

    blackView.backgroundColor = COLOR(82, 62, 68, 0.4);
 
    [_headerView addSubview:blackView];
    
    NSArray *array = @[@"课程",@"老师",@"粉丝"];
    NSInteger width = SCREEN_WIDTH / array.count;
    for (int i = 0; i < array.count; i ++)
    {
        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(width * i, 5, width, 20)];
        countLabel.font = [UIFont systemFontOfSize:14];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.tag = 1000 + i;
        [blackView addSubview:countLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width * i, 25, width, 20)];
        label.text = array[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [blackView addSubview:label];
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(width * i, 8, 1, 34)];
        if (i==0) {
            la.hidden = YES;
        }else {
            la.hidden = NO;
        }
       
         la.backgroundColor = APPBackgroundColor;
        [blackView addSubview:la];
        
        //点击的事件
        UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(width * i, 0, width, 50)];
        clickBtn.tag = i + 50;
        [clickBtn addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [blackView addSubview:clickBtn];
    }
    QGaddFooterView *footer = [[QGaddFooterView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 60)];
    footer.backgroundColor = COLOR(242, 243, 244, 1);
    footer.title.text = @"继续拖动，查看机构详情";
    self.tableView1.tableFooterView = footer;
 
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for ( QGCourseTagModel *tag  in _result.item.tagList) {
        [arr addObject:tag.tag_name];
    }
    QGTypeView* colorView = [[QGTypeView alloc] initWithFrame:CGRectMake(0, blackView.maxY, MQScreenW, 45) andDatasource:arr :nil];
    
         colorView.backgroundColor = [UIColor whiteColor];
    
    if (_result.item.tagList.count>0) {
        [_headerView addSubview:colorView];
        colorView.frame = CGRectMake(0,  blackView.maxY, MQScreenW,44);
    }else {
        
        colorView.frame = CGRectMake(0,  blackView.maxY, MQScreenW, 0.1);
        
    }
    
    _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, colorView.maxY+10);
    self.tableView1.tableHeaderView = _headerView;
    
  
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 54-Height_BottomSafe, SCREEN_WIDTH, 1)];
    line.backgroundColor = APPBackgroundColor;
    [self.view addSubview:line];
    // 底部收藏分享客服按钮
    NSArray * btnImageArr = @[@"teather_consult",@"teather_nolove",@"teather_share"];
       NSArray * titleArr = @[@"咨询",@"关注",@"分享"];
    ;
    // 总共有3列
    int totalCol = 3;
    CGFloat viewW = 54;
    CGFloat viewH = 54;
    
    CGFloat marginX = (self.view.bounds.size.width - totalCol * viewW) / (totalCol + 1);
    
    for (int i = 0; i < titleArr.count; i++) {
        
        int col = i % totalCol;
        
        CGFloat x = marginX + (viewW + marginX) * col;
        
        QGAddBtnView *appView = [QGAddBtnView addBtnView];
        [appView.btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:(UIControlStateNormal)]; ;//btnImageArr[i];
        appView.nameLabel.text = titleArr[i];
        if (i == 1) {
            [appView.btn setImage:[UIImage imageNamed:@"teather_yeslove"] forState:UIControlStateSelected];
            if (_result.item.isFollowed.integerValue == 1) {
                appView.btn.selected = YES;
                appView.nameLabel.text = @"已关注";
            }
        }
        
        appView.frame = CGRectMake(x,line.maxY, viewW, viewH);
        appView.btn.tag = 2000 + i;
        [appView.btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        appView.tag = 2000+i;
        PL_CODE_WEAK(ws)
        
        __weak __typeof(appView)viewBtn = appView;
        [appView addClick:^(UIButton *button) {
            
            [ws bottomBtnClick:viewBtn.btn];
        }];
        [self.view addSubview:appView];
    }
    
    [self addDateInfo];

 
}
#pragma mark 赋值数据
-(void)addDateInfo {
    

   
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.head_img] placeholderImage:nil];
  
    _orgNameLabel.text = _result.item.name;
    _orgSignatureLabel.text = _result.item.signature;
    NSArray *numArray = nil;
    if (_result.item) {
        numArray = @[_result.item.course_count,_result.item.teacher_count,_result.item.follower_count];
    }
    
    for (int i = 0; i < numArray.count; i ++)
    {
        UILabel *label = (UILabel *)[self.view viewWithTag:1000 + i];
        label.text = numArray[i];
    }
    
    
    if (_result.item.isFollowed.integerValue == 1) {
        UIButton *button = [self.view viewWithTag:2001];
        button.selected = YES;
    }
    
    [_orgadress setTitle:_result.item.address];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.bg_img] placeholderImage:nil];
    
}
- (void) bottomBtnClick:(UIButton *)btn {
    if ([self loginIfNeeded]) {
        return;
    }
    
    if (btn.tag == 2000) {
        // 咨询
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
    
    if (_result.item.service_id > 0) {
        
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
                                 initWithUserID:_result.item.service_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)followTeacher:(UIButton *)button{
    
    button.selected = !button.selected;
    QGAddBtnView *BtnView = (QGAddBtnView *)button.superview;
    
    BtnView.nameLabel.text = button.selected ? @"已关注" : @"关注";
    @weakify(self);
    [QGHttpManager CollectionWithCollectType:UserCollectionTypeOrg objectID:_result.item.org_id.integerValue isCollection:button.selected Success:^(NSURLSessionDataTask *task, id responseObject) {
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

#pragma mark headerView 点击事件
/**
 *  headerView 点击事件
 *
 *  @param btn tag值
 */
- (void)headerViewClick:(UIButton *)btn
{
    if (btn.tag == 50)
    {   //全部课程
        QGOrgAllCourseViewController *courseCtr = [[QGOrgAllCourseViewController alloc]init];
        courseCtr.org_id = self.org_id;
        [self.navigationController pushViewController:courseCtr animated:YES];
    }
    else if (btn.tag == 51)
    {   //全部老师
        QGOrgAllTeacherViewController *teacherCtr = [[QGOrgAllTeacherViewController alloc]init];
        teacherCtr.org_id = self.org_id;
        [self.navigationController pushViewController:teacherCtr animated:YES];
    }
  
}

/**
 *  创建tableFooterView
 */
- (void)p_createFooterView
{
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:view];
    
    UILabel *titleLabel = [SAAppUtils createBlackLabel];
    titleLabel.frame = CGRectMake(10, 10, 100, 20);
    titleLabel.text = @"机构ID";
    [view addSubview:titleLabel];
    
    _orgIDLabel = [SAAppUtils createGrayLightLabel];
    _orgIDLabel.frame = CGRectMake(SCREEN_WIDTH - 110, 10, 100, 20);
    _orgIDLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:_orgIDLabel];
}
/**
 *  创建UI
 */
- (void)p_createUI

{
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.tableView1];
    [self.bottomScrollView addSubview:self.tableView2];
     _isTableView1 = YES;

    [self p_requestMothod];
}

/**
 *  网络请求
 */
- (void)p_requestMothod
{
    QGQrgHttpDownload *download = [[QGQrgHttpDownload alloc]init];
    download.org_id = self.org_id;

    [[SAProgressHud sharedInstance]showWaitWithWindow];
    
    
    [QGHttpManager courseOrgFirstWithParam:download success:^(QGOrgfirstResultModel *result) {
           _result = result;
          [self p_createHeaderView];
        
     
        [_tableView1 reloadData];
         [_tableView2 reloadData];
    } failure:^(NSError *error) {
         [self showTopIndicatorWithError:error];
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  if (tableView.tag==1) {
    
     return 2;
}else {
    return 1;
}
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        if (section==1) {
            return _result.teacherList.count;
        }else {
            
            return 1;
        }
    }else
        return 1;
 
  
}

#pragma mark - cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag ==1) {
        if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0) {
            PL_CELL_CREATEMETHOD(QGTeacherCouseTableViewCell, @"cell");
            cell.dataSource = _result.courseList;
            [cell.collectionView  reloadData];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            PL_CELL_NIB_CREATE(QGTeacherListTableViewCell)
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            _teathermodel = _result.teacherList[indexPath.row];
            cell.model =_result.teacherList[indexPath.row];
            cell.linelab.hidden= YES;
            return cell;
            
        }
    }
    else {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==1) {
        QGTeacherViewController *vc = [[QGTeacherViewController alloc] init];
         _teathermodel = _result.teacherList[indexPath.row];
        vc.teacher_id = _teathermodel.teacher_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark - cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag ==1) {
    
    if ([self tableView:tableView numberOfRowsInSection:section]==0&&section==0)
    {
        return 10;
    }
        return 44;}else
            
        return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
        if ([self tableView:tableView numberOfRowsInSection:indexPath.section]>0&&indexPath.section==0)
        {
            return 150;
        }else {
            
            return 130;}
    }else {
        
        if (webheight>0)
        {
            return webheight;
        }else
            
            return MQScreenH/2;
    }

  

}





- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc] init];
    
    PL_CODE_WEAK(ws)
 if (tableView.tag ==1) {
    if ([self tableView:tableView numberOfRowsInSection:section]>0&&section==0)
    {
       // QGEduCoursedeilModel *model = _result.courseList[0];
        view = [self createSectionfooterView:@"查看全部课程" iconImageName:@"cell_right_arrow" moreBtnAction:^{
    
            QGOrgAllCourseViewController *vc =[[QGOrgAllCourseViewController alloc] init];
        vc.org_id = ws.result.item.org_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else if (section==1) {
        
           view = [self createSectionfooterView:@"查看全部老师" iconImageName:@"cell_right_arrow" moreBtnAction:^{
            QGOrgAllTeacherViewController *teacher = [[QGOrgAllTeacherViewController alloc]init];
            
           
               teacher.org_id = ws.result.item.org_id;
            [self.navigationController pushViewController:teacher animated:YES];
        }];
        
    }
 }
    return view;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view= [[UIView alloc] init];
    if (tableView.tag==1) {
        if ([self tableView:tableView numberOfRowsInSection:section]>0&&section==0)
        {
            //限时秒杀
            view=[self createSectionHeaderView:@"热门课程" iconImageName:nil];
        }else if (section==1) {
            
            
            view=[self createSectionHeaderView:@"名师推荐" iconImageName:nil];
            
        }
    }


    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
     if (tableView.tag ==1) {
         if (section==0) {
              return 54;
         }else {
             return 44;
         }
     }else {
         
         return 0.1;
     }
   
}


#pragma mark 尾部视图
- (UIView *)createSectionfooterView:(NSString *)sectionName iconImageName:(NSString *)imageName moreBtnAction:(void(^)())moreBtnBlock
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    
    
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, self.view.width, 1);
    lineView.backgroundColor =  RGB(242, 242, 242);
    [view addSubview:lineView];
    
    //更多
    UIButton* moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    
    [moreBtn setTitle:sectionName];
    [moreBtn setTitleFont:FONT_CUSTOM(15)];
    [moreBtn  setTitleColor:[UIColor colorFromHexString:@"999999"]];
    [moreBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, -190);
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [view addSubview:moreBtn];
    [moreBtn addClick:^(UIButton *button) {
        if (moreBtnBlock)
        {
            moreBtnBlock();
        }
    }];
    UIView *lb =[[UIView alloc] initWithFrame:CGRectMake(0, moreBtn.maxY, self.view.width, 10)];
    
    lb.backgroundColor =COLOR(242, 243, 244, 1);
    
    [view addSubview:lb];
    return view;    return view;
}

#pragma  mark 头部视图
- (UIView *)createSectionHeaderView:(NSString *)sectionName iconImageName:(NSString *)imageName
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    UIImageView *nickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    nickImageView.frame=CGRectMake(9, 10, 14, 14);
    [view addSubview:nickImageView];
    UILabel *Lab=[[UILabel alloc]initWithFrame:CGRectMake(9, 10, 14, 14)];
    Lab.font=FONT_CUSTOM(15);
    Lab.text=sectionName;
    //    Lab.textColor=PL_COLOR_237;
    Lab.textColor = COLOR(126, 128, 128, 1);
    
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, self.view.height - 1, self.view.width, 1);
    lineView.backgroundColor = RGB(242, 242, 242);
    [view addSubview:lineView];
    [view addSubview:Lab];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(view);
        make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
    }];
    
    [nickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickImageView.mas_right).offset(6);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    
    return view;
}

#pragma mark 分享
- (void)successShare
{
 
}


- (void)navCustomLeftBtnClick
{
    [super navCustomLeftBtnClick];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  mark refreshAnimotion
- (void)pullUpAnimotion
{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT-54);
    } completion:^(BOOL finished) {
        _isTableView1=NO;
        _navTitle.text =@"图文详情";
       
        [_returnBtn setImage:[UIImage imageNamed:@"icon_classification_back"]];
        self.viewline.backgroundColor =COLOR(243, 243, 243, 1);
        _navBGView.backgroundColor = RGBA(255, 255, 255 ,1);
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
        _navTitle.text = @"";
        [_returnBtn setNormalImage:@"round-back-icon"];
        self.viewline.backgroundColor =COLOR(243, 243, 243, 0);
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
            _headerImageView.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, 270 - yOffset);
            _effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 270 - yOffset);
        }
        else
        {
            _headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 270);
            _effectview.frame = _headerImageView.bounds;
        }
    }
    
    
    if (_isTableView1)
    {//当tableView1中没有评论且(修改后少了一栏包邮的代码,所以这里要多减60)
        if (self.tableView1.contentSize.height>SCREEN_HEIGHT-54-54)
        {
            if (scrollView.contentOffset.y+SCREEN_HEIGHT-54>self.tableView1.contentSize.height+54)
            {
                [self pullUpAnimotion];
            }
        }
    }else
    {
        if (_textNote.contentOffset.y<-54)
        {
            [self pullDownAnimotion];
        }
        if (_tableView2.contentOffset.y<-54)
        {
            [self pullDownAnimotion];
        }
        
        
    }
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //字体大小
    //
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];
    
    CGRect frame = webView.frame;
    frame.size.width= MQScreenW-10;
    frame.size.height = 1;
    frame.origin.x = 5;
    frame.origin.y= 10;
    webView.frame = frame;
    
    frame.size.height = webView.scrollView.contentSize.height+64;
    webView.frame = frame;
//    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webheight=webView.scrollView.contentSize.height;
    
    webView.delegate=nil;
    [_tableView2 reloadData];
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
