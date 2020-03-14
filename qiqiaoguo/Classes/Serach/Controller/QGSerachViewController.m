//
//  QGSerachViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/7.
//
//

#import "QGSerachViewController.h"
#import "QGTableView.h"
#import "QGSearchNavView.h"
#import "QGPOPView.h"
#import "QGSearchPromptHistoryHeader.h"
#import "QGSearchPromptHeader.h"
#import "QGSearchCell.h"
#import "QGHttpManager+Search.h"
#import "QGSearchResultViewController.h"


@interface QGSerachViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,QGSearchCellDelegate,QGPOPViewDelegate>

@property (nonatomic, strong) QGTableView *tableView;
@property (nonatomic, strong) QGSearchNavView *searchbar;

@property (nonatomic, strong) QGSearchPromptHistoryHeader *historyHeader;
@property (nonatomic, strong) QGSearchPromptHeader *popularHeader;

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *goodHistories;
@property (nonatomic, strong) NSArray *popularGoods;

@end

@implementation QGSerachViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavUI];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchbar.searchTextField becomeFirstResponder];
    [self fetchTagData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)fetchTagData{
    
    self.goodHistories = [self fetchSearchHistory];
    if (self.goodHistories.count > 0) {
        self.sections = @[self.goodHistories];
        [self.tableView reloadData];
    }
    
    @weakify(self);
    [QGHttpManager getSearchHotTagWithSearchOptionType:self.searchOptionType Success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        self.popularGoods = responseObject;
        
        NSMutableArray *sections = [NSMutableArray new];
        if (self.goodHistories.count > 0) {
            [sections addObject:self.goodHistories];
        }
        
        if (self.popularGoods.count > 0) {
            [sections addObject:self.popularGoods];
        }
        
        self.sections = sections;
        if (self.popularGoods.count > 0) {
            [self.tableView reloadData];
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showTopIndicatorWithError:error];
    }];
    
}

- (void)configNavUI{
    self.navigationController.navigationBarHidden = YES;
    _searchbar = [QGSearchNavView new];
    _searchbar.searchOptionType = self.searchOptionType;
    _searchbar.searchTextField.delegate = self;
    _searchbar.searchTextField.text = self.keyword;
    [self.view addSubview:_searchbar];
    
   @weakify(self);
    [[self.searchbar.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        int index = self.navigationController.viewControllers.count;
        if ([self.navigationController.viewControllers[index - 2] isKindOfClass:[QGSearchResultViewController class]]) {
            [self.navigationController popViewControllerAnimated:NO];
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[self.searchbar.categoryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        QGPOPView *view = [QGPOPView new];
        view.delegate = self;
        [view showFrom:self.searchbar.categoryButton];
    }];
    
}

- (QGTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [QGTableView new];
        [_tableView registerClass:[QGSearchCell class]
           forCellReuseIdentifier:NSStringFromClass([QGSearchCell class])];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.frame = CGRectMake(0, _searchbar.bottom, self.view.width, self.view.height-_searchbar.height);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



-(void)setKeyword:(NSString *)keyword{
    
    _keyword = keyword;
    self.searchbar.searchTextField.text = keyword;
}

- (void)setSearchOptionType:(QGSearchOptionType)searchOptionType{
    
    _searchOptionType = searchOptionType;
    self.searchbar.searchOptionType = searchOptionType;
    
}


- (QGSearchPromptHeader *)popularHeader {
    if (_popularHeader == nil) {
        _popularHeader = [[QGSearchPromptHeader alloc]
                          initWithReuseIdentifier:NSStringFromClass([QGSearchPromptHeader class])];
        _popularHeader.titleLabel.text = NSLocalizedString(@"good-search-prompt-header.title", @"Popular searches");
    }
    return _popularHeader;
}

- (QGSearchPromptHistoryHeader *)historyHeader {
    if (_historyHeader == nil) {
        _historyHeader = [[QGSearchPromptHistoryHeader alloc]
                          initWithReuseIdentifier:NSStringFromClass([QGSearchPromptHistoryHeader class])];
        _historyHeader.titleLabel.text = NSLocalizedString(@"good-search-prompt-history-header.title", @"Search History");
        [_historyHeader.clearButton addTarget:self
                                       action:@selector(tapAndClearSearchHistory:)
                             forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyHeader;
}

- (void)tapAndClearSearchHistory:(UIButton *)button {
    [self clearSearchResults];
    self.goodHistories = nil;
    if (self.popularGoods.count > 0) {
        self.sections = @[self.popularGoods];
    }
    [self.tableView reloadData];
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    
    [self searchWithKeyword:textField.text];
    return YES;
}

#pragma mark - UIScorViewDalegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    [self.searchbar.searchTextField resignFirstResponder];
    
}

#pragma mark -  UITableViewDalegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QGSearchCell  *cell = (QGSearchCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGSearchCell class]) forIndexPath:indexPath];
    NSArray *tags = [self objectAtIndexPath:indexPath];
    cell.TagArray = tags;
    cell.searchDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    height = [self.tableView sizeForCellWithCellClass:[QGSearchCell class]
                                     cacheByIndexPath:indexPath
                                                width:self.tableView.width
                                        configuration:^(QGCell *cell) {
                                            QGSearchCell *tagCell = (QGSearchCell *)cell;
                                            NSArray *arr = [self objectAtIndexPath:indexPath];
                                            tagCell.TagArray = arr;
                                        }].height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [QGSearchPromptHeader headerHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *rows = self.sections[section];
    if (rows == self.goodHistories) {
        return self.historyHeader;
    } else if (rows == self.popularGoods) {
        return self.popularHeader;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = self.sections[indexPath.section];
    return rows;
}

#pragma mark - QGSearchCellDelegate

- (void)searchWithKeyword:(NSString *)keyword{
    
    [self saveSearchText:keyword];
    QGSearchResultViewController *SearchResultVC = nil;
    int index = self.navigationController.viewControllers.count;
    if ([self.navigationController.viewControllers[index - 2] isKindOfClass:[QGSearchResultViewController class]]) {
        SearchResultVC = self.navigationController.viewControllers[index - 2];
        SearchResultVC.keyWord = keyword;
        SearchResultVC.searchOptionType = self.searchOptionType;
        [SearchResultVC shouldUpdateData];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        SearchResultVC = [QGSearchResultViewController new];
        SearchResultVC.keyWord = keyword;
        SearchResultVC.searchOptionType = self.searchOptionType;
        [self.navigationController pushViewController:SearchResultVC animated:YES];
    }
}


#pragma mark - QGPOPViewDelegate

- (void)popViewDidClickButton:(UIButton *)button{
    
    self.searchOptionType = button.tag;
    self.searchbar.searchOptionType = self.searchOptionType;
}



#pragma mark -  历史搜索记录

- (void)saveSearchText:(NSString *)searchText
{
    if (searchText.length < 1) {
        return;
    }
    //添加数据，最近搜索数据放在最前面
    NSMutableArray *searchTextArr = @[].mutableCopy;
    [searchTextArr addObject:searchText];
    NSArray *arr = [self fetchSearchHistory];
    [searchTextArr addObjectsFromArray:arr];
    
    //对数据去重（保持数据的原顺序并把后面的重复数据删除）
    NSMutableArray *unrepeatedArr = @[].mutableCopy;
    for (NSString *str in searchTextArr) {
        if (![unrepeatedArr containsObject:str]) {
            [unrepeatedArr addObject:str];
        }
    }
    //保存数据到本地
    if ([NSKeyedArchiver archiveRootObject:unrepeatedArr toFile:[self searchHistoryPlistPath]]) {
        
    } else {
        NSLog(@"保存历史搜索记录失败");
    }
}

- (NSArray *)fetchSearchHistory{
    
    NSArray *historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self searchHistoryPlistPath]];
    
    return historyArray;
}

- (void)clearSearchResults {
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[self searchHistoryPlistPath]]) {
        [defaultManager removeItemAtPath:[self searchHistoryPlistPath] error:nil];
    }
    
}

- (NSString *)searchHistoryPlistPath{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = @"SearchHistoryKEY";
    path = [path MD5String];
    path = [path stringByAppendingString:@".plist"];
    path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
    return path;
}


@end
