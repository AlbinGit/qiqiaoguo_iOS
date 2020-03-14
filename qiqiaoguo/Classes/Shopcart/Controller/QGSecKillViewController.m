//
//  QGSecKillViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import "QGSecKillViewController.h"
#import "QGSecKillTableViewCell.h"
#import "QGGetSeckillGoodsListHttpDownload.h"
#import "SASRefreshTableView.h"
#import "QGTimerLabel.h"
#import "QGSlideClassficationView.h"
#import "QGProductDetailsViewController.h"
#import "QGSecKillDetailViewController.h"
@interface QGSecKillViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    UIView *_headView;
}
@property (nonatomic,strong)SASRefreshTableView *tableView;
/**记录当前选中的时间按钮*/
@property (nonatomic,assign)NSInteger currentBtn_tag;
/**数据模型*/
@property (nonatomic,strong)UIImageView * headerBgImageView;
@property (nonatomic,strong)QGSeckillResultModel *result;

@end

@implementation QGSecKillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseData];
    [self createReturnButton];
    [self createNavTitle:@"限时秒杀"];
    _currentBtn_tag=100;
    [self pullRefreshRequest:SARefreshPullDownType];
    [self p_createUI];
    
}
/**
 *  刷新数据
 *
 *  @param animated
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)p_createUI
{
    _tableView =[[SASRefreshTableView  alloc]initWithFrame:CGRectMake(0,self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY) style:UITableViewStyleGrouped];
    _tableView.bouncesZoom=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=PL_UTILS_COLORRGB(240, 240, 240);
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_currentBtn_tag>100){
        QGSeckillListModel *model =  _result.seckillingList[1];
        return model.items.count;
    }else {
        QGSeckillListModel *model =  _result.seckillingList[0];
        return model.items.count;
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PL_CELL_CREATE(QGSecKillTableViewCell);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_currentBtn_tag>100){
        QGSeckillListModel *model1 =  _result.seckillingList[1];
        QGSeckillListItemModel *item = model1.items[indexPath.row];
        item.end_time = model1.end_time;
        item.start_time = model1.start_time;
        cell.listModel = item;
    }else{
        
        QGSeckillListModel *model =  _result.seckillingList[0];
        QGSeckillListItemModel *item = model.items[indexPath.row];
        item.end_time = model.end_time;
        item.start_time = model.start_time;
        cell.listModel = item;
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QGSeckillListModel *model =  _result.seckillingList[0];
    NSInteger count=[QGCommon compareTimeStartTime:model.start_time endTime:model.end_time];
    if (count== 1 && _currentBtn_tag==100) {
        QGSeckillListItemModel *item = model.items[indexPath.row];
        QGSecKillDetailViewController *vc = [[QGSecKillDetailViewController alloc] init];
        vc.goods_id = item.id;
        vc.seckilling_no = item.seckilling_no;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

/**
 *  事件条下的活动预告和倒计时
 *
 *  @param tableView
 *  @param section
 *
 *  @return 返回区头View
 */
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QGSeckillListModel *skill = nil;
    if (_currentBtn_tag > 100 && _result.seckillingList.count > 1){
        skill = _result.seckillingList[1];
    }
    else if(_result.seckillingList.count > 0){
        skill = _result.seckillingList[0];
    }
    UIView *view=[[UIView alloc]init];
    if (_result.seckillingList.count>0) {
        
        SALabel *lab=[[SALabel alloc]initWithFrame:CGRectMake(10, 0, MQScreenW, 44)];
        lab.font=FONT_CUSTOM(13);
        lab.textColor=COLOR(170, 171, 172, 1);
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = skill.sub_title;
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:lab];
        //时钟图
        UIImageView *nock=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_card_time"]];
        [view addSubview:nock];
        CGFloat labH = 20;
        
        CGFloat lab4 = 11;
        UILabel *initLab1=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-labH-10,12,labH, labH)];
        initLab1.textAlignment =NSTextAlignmentCenter;
        initLab1.font = [UIFont systemFontOfSize:11];
        initLab1.layer.cornerRadius = 5;
        initLab1.layer.masksToBounds= YES;
        initLab1.backgroundColor =COLOR(153, 153, 155, 1);
        initLab1.textColor=COLOR(255, 255, 255, 1);
        initLab1.text=@"00";
        UILabel *initLab2=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2*labH-lab4-10 ,12,labH, labH)];
        initLab2.textAlignment =NSTextAlignmentCenter;
        initLab2.font = [UIFont systemFontOfSize:11];
        initLab2.backgroundColor =COLOR(153, 153, 155, 1);
        initLab2.layer.cornerRadius = 5;
        initLab2.layer.masksToBounds= YES;
        initLab2.textColor=COLOR(255, 255, 255, 1);
        initLab2.text=@"00";
        UILabel *initLab3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-3*labH-2*lab4-10  ,12,labH, labH)];
        initLab3.backgroundColor =COLOR(153, 153, 155, 1);
        initLab3.font = [UIFont systemFontOfSize:11];
        initLab3.textColor=COLOR(255, 255, 255, 1);
        initLab3.layer.cornerRadius = 5;
        initLab3.layer.masksToBounds= YES;
        initLab3.textAlignment =NSTextAlignmentCenter;
        initLab3.text=@"00";
        UILabel *initLab4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-labH-lab4-10 ,12,lab4, labH)];
        initLab4.textAlignment =NSTextAlignmentCenter;
        initLab4.textColor =[UIColor redColor];
        initLab4.textColor=COLOR(170, 171, 172, 1);
        initLab4.font = [UIFont systemFontOfSize:15];
        initLab4.text=@":";
        UILabel *initLab5=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2*labH-2*lab4-10 ,12,lab4, labH)];
        initLab5.textAlignment =NSTextAlignmentCenter;
        initLab5.textColor=COLOR(170, 171, 172, 1);
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
        SALabel *startAndOver=[SALabel createLabelWithRect:CGRectMake(initLab3.minX-[QGCommon rectWithString:@"距开始:" withFont:12], 14,[QGCommon rectWithString:@"距开始:" withFont:12],[QGCommon rectWithFont:12]) andWithColor:COLOR(170, 171, 172, 1) andWithFont:12 andWithAlign:NSTextAlignmentCenter andWithTitle:nil];
        [view addSubview:startAndOver];
        //判断是否在活动期间
        if ([[QGCommon testTimeWithTheTime:skill.start_time] integerValue]<0)
        {
            NSInteger timeCount=[[QGCommon testTimeWithTheTime:skill.end_time]integerValue];
            
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
        if ([[QGCommon testTimeWithTheTime:skill.start_time] integerValue]>=0)
        {
            
            int timeInval= abs([[QGCommon testTimeWithTheTime:skill.start_time] intValue]);
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
        nock.frame=CGRectMake(startAndOver.minX-11, startAndOver.minY + 1, startAndOver.height-2, startAndOver.height-2);
        
        
    }
    return view;
}
- (UIView *)createHeaderView
{
    if (!_headView)
    {
        _headView=[[UIView alloc]init];
        _headView.backgroundColor =COLOR(242, 243, 244, 1);
    }else{
        return _headView;
    }
    
    CGFloat headImageHeight = SCREEN_WIDTH / 2.7 ;
    
    PL_CODE_WEAK(weakSelf);
    _headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44+headImageHeight);
    _headerBgImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headImageHeight)];
    _headerBgImageView.clipsToBounds = YES;
    _headerBgImageView.userInteractionEnabled = YES;
   _headerBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerBgImageView  sd_setImageWithURL:[NSURL URLWithString:_result.cover] placeholderImage:nil];
    
    [_headView addSubview:_headerBgImageView];
    NSMutableArray *arrTitle=[NSMutableArray array];
    for (QGSeckillListModel *model in _result.seckillingList) {
        
        if ([model.title isEqualToString:@"即将开始"]) {
            model.title = @"即将开抢";
        }
        [arrTitle addObject:model.title];
    }
    //自定义滑动条
    NSInteger curentIndex = 0;
    if (_currentBtn_tag>0)
    {
        curentIndex = _currentBtn_tag - 100;
    }
    QGSlideClassficationView *slideView=[[QGSlideClassficationView alloc]initWithFrame:CGRectMake(0, _headerBgImageView.maxY, SCREEN_WIDTH, 44) withCurrentSelectIndex:curentIndex andTitles:arrTitle ];
    slideView.nomoalColor=QGCellContentColor ;
    
    slideView.selectColor=PL_COLOR_255;
    [_headView addSubview:slideView];
    [slideView getCurrentSelectIndex:^(NSInteger currentIndex, NSInteger currentTag){
        
        if (weakSelf.currentBtn_tag == currentIndex+100) {
            return ;
        }
        weakSelf.currentBtn_tag=currentIndex+100;
        [self.tableView reloadData];
    }];
    
    
    //    }
    return _headView;
}
#pragma  mark 网络请求
- (void)pullRefreshRequest:(SARefreshType) type
{
    [[SAProgressHud sharedInstance] showWaitWithWindow];
    
    [QGHttpManager optimaiProductSeckSkillSuccess:^(QGSeckillResultModel *result) {
        [_tableView endRrefresh];
        
        _result = result;
        //        [_result.seckillingList removeObject:_result.seckillingList[1]];
        
        _tableView.tableHeaderView=[self createHeaderView];
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
    
    
}
- (void)dealloc
{
    [_tableView refreshFree];
    NSLog(@"释放类%@",NSStringFromClass([self class]));
}
#pragma mark 顶部视图拉伸
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    if (self.tableView == scrollView) {
        
        CGFloat yOffset = self.tableView.contentOffset.y;
        //下拉图片放大
        if (yOffset < 0) {
            _headerBgImageView.frame = CGRectMake(0, yOffset, SCREEN_WIDTH, SCREEN_WIDTH/2.7 - yOffset);
        }
        else
        {
            _headerBgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.7);
        }
    }
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
