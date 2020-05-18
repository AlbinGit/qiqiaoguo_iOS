//
//  QGTeacherViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#define kBtnHeight 54

#import "QGTeacherViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGOrgViewController.h"
#import "SASRefreshTableView.h"
#import "QGEduClassModel.h"
#import "QGTeacherPhotoModel.h"
#import "QGTextView.h"
#import "QGTeacherCouseTableViewCell.h"
#import "QGTeacherHttpDownload.h"

#import "QGSearchResultViewController.h"
#import "QGTeacherInfoListModel.h"
#import "QGOrgAllCourseViewController.h"
#import "QGHttpManager+User.h"
#import "QGShareViewController.h"
#import "BLUChatViewController.h"

@interface QGTeacherViewController ()<UITableViewDataSource,UITableViewDelegate>
/**数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) SASRefreshTableView * tableView;
/**头视图*/
@property (nonatomic, strong) UIView * headerView;
/**背景图片*/
@property (nonatomic, strong) UIImageView * backImageView;
/**头像*/

@property (nonatomic, strong) UIImageView * faceImageView;
@property (nonatomic,assign) CGFloat labTitle;
@property (nonatomic,strong) UIImageView *genderImage;
/**姓名*/
@property (nonatomic, strong) UILabel * nameLabel;
/**签名*/
@property (nonatomic, strong) UILabel * signLabel;
/**机构*/
@property (nonatomic, strong) SALabel * organizationLabel;

@property (nonatomic, strong) UIVisualEffectView *effectview;
@property (nonatomic, strong) UIImageView * faceImageView1;

@property (nonatomic,strong) QGEduTeacherDetailResultModel *result;
@end

@implementation QGTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    _dataArray = [[NSMutableArray alloc]init];
    
    [self request];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)p_createUI {
    
    // tableView
    _tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBtnHeight-Height_BottomSafe) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR(243, 245, 246, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//	if (IOS_VERSION>11.0) {
//		_tableView.estimatedRowHeight = 0;
//		_tableView.estimatedSectionFooterHeight = 0;
//		_tableView.estimatedSectionHeaderHeight = 0;
//	}
	[_tableView setContentOffset:CGPointMake(0, 0.5)];
	self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
	
    // 头视图
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    // 背景图
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -54, SCREEN_WIDTH, 250+54)];
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.bg_img] placeholderImage:nil];
    _backImageView.clipsToBounds = YES;
    _backImageView.userInteractionEnabled = YES;
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_backImageView addSubview:_effectview];
    _effectview.frame = _backImageView.bounds;
    
    [_headerView addSubview:_backImageView];
    // 头像
    // 头像
    _faceImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, 48, 80, 80)];
    _faceImageView1.layer.cornerRadius = 40.f;
    _faceImageView1.layer.masksToBounds = YES;
    _faceImageView1.backgroundColor = COLOR(255, 255, 255, 0.4);
    [_headerView addSubview:_faceImageView1];
    
    
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 74, 74)];
    _faceImageView.layer.cornerRadius = 37.f;
    _faceImageView.layer.masksToBounds = YES;
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.head_img] placeholderImage:nil];
    [_faceImageView1 addSubview:_faceImageView];
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:_result.item.head_img] placeholderImage:nil];
    _genderImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 -12,_faceImageView1.maxY-12, 24, 24)];
    if ([_result.item.sex isEqualToString:@"1"]) {
        _genderImage.image = [UIImage imageNamed:@"man_icon"];
    }else {
        _genderImage.image= [UIImage imageNamed:@"woman"];
    }
    
    
    
    [_headerView addSubview:_genderImage];
    
    
    // 姓名
    _nameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = _result.item.name;
    _nameLabel.numberOfLines = 2;
    _nameLabel.width = SCREEN_WIDTH-20;
    [_nameLabel sizeToFit];
    _nameLabel.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
    _nameLabel.centerX = _backImageView.centerX;
    _nameLabel.Y =  _genderImage.maxY + 5;
    _nameLabel.width = MQScreenW-40;
    [_headerView addSubview:_nameLabel];
    
    
    _signLabel =   [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
    
    _signLabel.font =  BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall);
    _signLabel.textColor = [UIColor whiteColor];
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.width = MQScreenW-40;
    _signLabel.text = _result.item.signature;
    _signLabel.numberOfLines = 2;
    
    [_signLabel sizeToFit];
    
    _signLabel.centerX = _backImageView.centerX;
    _signLabel.Y = _nameLabel.maxY +10;
    [_headerView addSubview:_signLabel];
    
    
    // 机构
    CGRect rect1 =  [QGCommon rectForString:_result.item.org_name withFont:11 WithWidth:MQScreenW];
    _organizationLabel = [SALabel createLabelWithRect:CGRectMake((MQScreenW-rect1.size.width-30)*0.5, _signLabel.maxY+10 ,rect1.size.width+30 , 20) andWithColor:[UIColor whiteColor] andWithFont:13 andWithAlign:NSTextAlignmentCenter andWithTitle:nil];
    
    _organizationLabel.text = _result.item.org_name;
    _organizationLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _organizationLabel.layer.borderWidth = 1;
    
    _organizationLabel.layer.masksToBounds= YES;
    _organizationLabel.layer.cornerRadius = 10;
    
    [_headerView addSubview:_organizationLabel];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for ( QGCourseTagModel *tag  in _result.item.tagList) {
        [arr addObject:tag.tag_name];
    }
    
    QGTypeView* view = [[QGTypeView alloc] initWithFrame:CGRectMake(0,_backImageView.maxY, MQScreenW, 45+Height_BottomSafe) andDatasource:arr :nil];
    
    [_headerView addSubview:view];
    if (_result.item.tagList.count>0) {
        [_headerView addSubview:view];
        view.frame = CGRectMake(0,_backImageView.maxY, MQScreenW,44);
    }else {
        
        view.frame = CGRectMake(0, _backImageView.maxY, MQScreenW, 0.1);
        
    }
    
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(0, view.maxY, MQScreenW, 10)];
    ll.backgroundColor =COLOR(242, 243, 244, 1);
    [_headerView addSubview:ll];
    PL_CODE_WEAK(ws) // 跳转到机构主页
    [_organizationLabel addClick:^(SALabel *label) {
        QGOrgViewController *orgCtl = [[QGOrgViewController alloc]init];
        orgCtl.org_id = ws.teacherModel.org_id;
        [ws.navigationController pushViewController:orgCtl animated:YES];
    }];
    
    // 线
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
            [appView.btn setImage:[UIImage imageNamed:@"teather_yeslove"] forState:(UIControlStateSelected)];
            if (_result.item.isFollowed.integerValue == 1) {
                appView.btn.selected = YES;
                appView.nameLabel.text = @"已收藏";
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
    
    // 返回按钮
    SAButton * returnBtn = [SAButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, self.navImageView.height - 49, 50, 49);
    [returnBtn setNormalImage:@"round-back-icon"];
    [returnBtn addClick:^(SAButton *button) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:returnBtn];
    
    
    
    
    UIButton *lab = [[UIButton alloc] initWithFrame:CGRectMake(0, ll.maxY, MQScreenW, 44)];
    lab.backgroundColor = [UIColor whiteColor];
    
    [lab setTitle:@"老师简介"];
    lab.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    [lab setTitleFont:[UIFont systemFontOfSize:15]];
    //    lab.textColor = COLOR(201, 203, 203, 1);
    [lab setTitleColor:[UIColor colorFromHexString:@"333333"] forState:(UIControlStateNormal)];
    lab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_headerView addSubview:lab];
    // 线
    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.maxY-1, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor =QGlineBackgroundColor;
    [_headerView addSubview:line1];
    
    UILabel *signLabel = [[UILabel alloc]init];
    
    signLabel.text = _result.item.intro;
    [signLabel sizeToFit];
    CGRect rect = [QGCommon rectForString:signLabel.text withFont:15 WithWidth:MQScreenW-20];
    
    
    if (signLabel.text.length >0) {
        signLabel.frame = CGRectMake(10, lab.maxY , SCREEN_WIDTH-10, rect.size.height+20);
    }else {
        
        signLabel.frame = CGRectMake(10, lab.maxY , SCREEN_WIDTH-10, 0.01 );
    }
    
    signLabel.backgroundColor = [UIColor whiteColor];
    signLabel.textColor = [UIColor colorFromHexString:@"666666"];
    signLabel.numberOfLines = 0;
    signLabel.font = [UIFont systemFontOfSize:15];
    
    
    
    [_headerView addSubview:signLabel];
    
    
    UILabel *ll1 = [[UILabel alloc] initWithFrame:CGRectMake(0, signLabel.maxY, MQScreenW, 10)];
    ll1.backgroundColor =COLOR(242, 243, 244, 1);
    [_headerView addSubview:ll1];
    _headerView.frame = CGRectMake(0, 0, MQScreenW, ll1.maxY );

    _tableView.tableHeaderView = _headerView;
}


/**
 *  教师详情数据请求
 */
- (void)request {
    QGTeacherHttpDownload * hd = [[QGTeacherHttpDownload alloc]init];
    
    hd.teacher_id = _teacher_id;
    [[SAProgressHud sharedInstance] showWaitWithWindow];
    
    [QGHttpManager teacherDetailsWithParam:hd success:^(QGEduTeacherDetailResultModel *result) {
        _teacherModel = result.item;
        _result= result;
        
        [self p_createUI];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
    
    
}
#pragma mark ----- tableDelegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PL_CELL_CREATEMETHOD(QGTeacherCouseTableViewCell, @"couse")
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    
    cell.dataSource = _result.courseList;
    [cell.collectionView reloadData];
    return cell;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIButton *lab = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 44)];
    lab.backgroundColor = [UIColor whiteColor];
    
    [lab setTitle:@"课程"];
    [lab setTitleFont:[UIFont systemFontOfSize:15]];
    //    lab.textColor = COLOR(201, 203, 203, 1);
    [lab setTitleColor:[UIColor colorFromHexString:@"333333"] forState:(UIControlStateNormal)];
    lab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    lab.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = QGlineBackgroundColor;
    [lab  addSubview:line1];
    
    return lab;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc] init];
    PL_CODE_WEAK(ws)
    if ([self tableView:tableView numberOfRowsInSection:section]>0&&section==0)
    {
        
        view = [self createSectionfooterView:@"查看全部课程" iconImageName:@"cell_right_arrow" moreBtnAction:^{
            QGOrgAllCourseViewController *vc = [[QGOrgAllCourseViewController alloc] init];
            vc.org_id = _result.item.org_id;
            [ws.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 44;
}
#pragma mark 尾部视图
- (UIView *)createSectionfooterView:(NSString *)sectionName iconImageName:(NSString *)imageName moreBtnAction:(void(^)())moreBtnBlock
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 1, self.view.width, 0.5);
    lineView.backgroundColor =  QGlineBackgroundColor;
    [view addSubview:lineView];
    //更多
    UIButton* moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    
    [moreBtn setTitle:sectionName];
    [moreBtn setTitleFont:FONT_CUSTOM(16)];
    [moreBtn setTitleColor:[UIColor colorFromHexString:@"999999"]];
    [moreBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, -200);
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
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
  
    
    return view;
}
#pragma mark ------ btnClick -------
- (void)allBtnClick:(UIButton *)btn {
    
    QGSearchResultViewController *vc = [[QGSearchResultViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
// 底部关注老师、分享、咨询按钮点击事件
- (void)bottomBtnClick:(UIButton *)btn {
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
    [QGHttpManager CollectionWithCollectType:UserCollectionTypeTeacher objectID:_result.item.teacher_id.integerValue isCollection:button.selected Success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

#pragma mark 顶部视图拉伸
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    if (self.tableView == scrollView) {
        
        CGFloat yOffset = self.tableView.contentOffset.y;
        //下拉图片放大
        if (yOffset < 0) {
            _backImageView.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, 250 - yOffset);
            _effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250 - yOffset);
        }
        else
        {
            _backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
            _effectview.frame = _backImageView.bounds;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
