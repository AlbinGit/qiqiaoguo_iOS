//
//  QGActCalendarViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/8/17.
//
//

#import "QGActCalendarViewController.h"
#import "QGTableView.h"
#import "FSCalendar.h"
#import "QGHttpManager+Activity.h"
#import "QGActivityHomeViewcell.h"
#import "QGActivityDetailViewController.h"


@interface QGActCalendarViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,FSCalendarDataSource,FSCalendarDelegate>

@property (weak, nonatomic) FSCalendar *calendar;

@property (nonatomic, strong) QGTableView *tableView;

@property (nonatomic, strong)NSMutableDictionary *eventsByDate;

@property (nonatomic, weak) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) QGActlistHomeResultModel *ResultModel;

@property (nonatomic, strong) UILabel *cannotFindLabel;
@property (nonatomic, strong) UIImageView *cannotFindImageView;
@property (nonatomic, strong) UIView *cannotFindView;
@property (nonatomic, assign) BOOL showNoContentPrompt;

@property (nonatomic, strong) NSDate *date;

@end

@implementation QGActCalendarViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = APPBackgroundColor;
    self.view = view;
    
    CGFloat height = 330;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, -40, view.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    [view addSubview:calendar];
    self.calendar = calendar;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
    [QGHttpManager getCalendarActSessionSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *arr = responseObject;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSDictionary *dic1 in arr) {
            [dic setValue:dic1[@"act_count"] forKey:dic1[@"act_date"]];
        }
        
        self.calendar.dataDic = dic;
        
        [self.calendar reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showTopIndicatorWithError:error];
    }];
    
    NSDate *now = [NSDate date];
    
    NSString *date = [NSString stringWithFormat:@"%ld-%02ld-%02ld",[self.calendar yearOfDate:now],(long)[self.calendar monthOfDate:now],(long)[self.calendar dayOfDate:now]];
    _date = now;
    [self getDataWithDate:date];
    
    self.tableView.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        NSString *date = [NSString stringWithFormat:@"%ld-%02ld-%02ld",[self.calendar yearOfDate:_date],(long)[self.calendar monthOfDate:_date],(long)[self.calendar dayOfDate:_date]];
        [self.view showIndicator];
        self.page ++;
        [QGHttpManager getCalendarActListWithDate:date Page:self.page Success:^(id responseObj) {
            [self tableViewEndRefreshing:self.tableView];
            [self.view hideIndicator];
            QGActlistHomeResultModel *model = responseObj;
            [self.ResultModel.items addObjectsFromArray:model.items];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            [self.view hideIndicator];
            [self tableViewEndRefreshing:self.tableView];
            [self showTopIndicatorWithError:error];
        }];
    }];



}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configUI{
    
    CGRect frame = self.calendar.frame;
    CGFloat viewHeight = frame.size.height;
    _tableView = [[QGTableView alloc]initWithFrame:CGRectMake(0, viewHeight - self.topLayoutGuide.length - 40, self.view.width, self.view.height - viewHeight + 40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = APPBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar.animator action:@selector(handlePan:)];
    panGesture.delegate = self.calendar.animator;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    panGesture.enabled = YES;
    [self.tableView addGestureRecognizer:panGesture];
    _panGesture = panGesture;
    _calendar.scopeGesture = panGesture;
    [self.calendar selectDate:[NSDate date]];
    
    
    
    
    @weakify(self);
    [RACObserve(self.calendar,frame) subscribeNext:^(id x) {
        @strongify(self);
        CGRect frame = self.calendar.frame;
        CGFloat viewHeight = frame.size.height;
        self.tableView.frame = CGRectMake(0, viewHeight - self.topLayoutGuide.length - 40, self.view.width, self.view.height - viewHeight + 40);
    }];
    
    [RACObserve(self.calendar, currentPage) subscribeNext:^(id x) {
        @strongify(self);
        self.title = [NSString stringWithFormat:@"%ld月活动",[self.calendar monthOfDate:self.calendar.currentPage]];
    }];
    [RACObserve(self.calendar, scope) subscribeNext:^(id x) {
        @strongify(self);
        self.tableView.scrollEnabled = self.calendar.scope ? YES : NO;
    }];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.calendar.maxY, 0);
}

- (void)getDataWithDate:(NSString *)dateStr{
    self.page = 1;
    [self.view showIndicator];
    [QGHttpManager getCalendarActListWithDate:dateStr Page:self.page Success:^(id responseObj) {
        [self.view hideIndicator];
        self.ResultModel = responseObj;
        [self.tableView reloadData];
        [self performSelector:@selector(change) withObject:nil afterDelay:0.45];
    } failure:^(NSError *error) {
        [self.view hideIndicator];
        [self showTopIndicatorWithError:error];
    }];
}

- (void)change{
    
    [self.calendar setScope:FSCalendarScopeWeek animated:YES];
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    _date = date;
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",[self.calendar yearOfDate:date],(long)[self.calendar monthOfDate:date],(long)[self.calendar dayOfDate:date]];
    [self getDataWithDate:dateStr];
    [self change];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    if (date) {
        return QGMainRedColor;
    }
    return appearance.borderDefaultColor;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self showCannotViewIfNeed:_ResultModel.items.count > 0];
    return _ResultModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PL_CELL_CREATE(QGActivityHomeViewcell);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.actModel = _ResultModel.items[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGActlistHomeModel *actModel = [[QGActlistHomeModel alloc] init];
    
    actModel = _ResultModel.items[indexPath.row];
    QGActivityDetailViewController *vc = [[QGActivityDetailViewController alloc] init];
    vc.activity_id = actModel.id;
    vc.sign_tips = actModel.sign_tips;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return (MQScreenW-20)*5/9 +65;
    
}




#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y != 0) {
        _panGesture.enabled = NO;
    }else{
        _panGesture.enabled = YES;
    }
    
}




#pragma mark - Public Method

- (void)addTiledLayoutConstrantForView:(UIView *)view {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"view": view};
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(0)-[view]-(0)-|"
      options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
      options:0 metrics:nil views:viewsDictionary]];
    
}

- (UIImageView *)cannotFindImageView {
    if (_cannotFindImageView == nil) {
        _cannotFindImageView = [UIImageView new];
        _cannotFindImageView.image = [UIImage imageNamed:@"search-notfind"];
    }
    return _cannotFindImageView;
}

- (UILabel *)cannotFindLabel {
    if (_cannotFindLabel == nil) {
        _cannotFindLabel = [UILabel new];
        _cannotFindLabel.textColor = [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.00];
        _cannotFindLabel.text = @"没有相关数据~";
        
    }
    return _cannotFindLabel;
}

- (UIView *)cannotFindView {
    if (_cannotFindView == nil) {
        _cannotFindView = [UIView new];
    }
    return _cannotFindView;
}

- (void)configCannotView {
    
    [_tableView addSubview:self.cannotFindView];
    [self.cannotFindView addSubview:self.cannotFindImageView];
    [self.cannotFindView addSubview:self.cannotFindLabel];
    
    [self.cannotFindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView);
    }];
    
    UIView *superview = self.cannotFindView;
    
    [self.cannotFindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.centerX.equalTo(superview);
    }];
    
    [self.cannotFindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cannotFindImageView.mas_bottom).offset(BLUThemeMargin * 2);
        make.centerX.equalTo(superview);
        make.left.greaterThanOrEqualTo(superview);
        make.right.lessThanOrEqualTo(superview);
        make.bottom.equalTo(superview);
    }];
}

- (void)showCannotViewIfNeed:(BOOL)hidden {
    if (![self.view isDescendantOfView:self.cannotFindView]) {
        [self configCannotView];
    }
    self.cannotFindView.hidden = hidden;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
