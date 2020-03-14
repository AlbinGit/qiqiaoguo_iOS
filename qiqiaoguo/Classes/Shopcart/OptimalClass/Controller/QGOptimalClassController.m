//
//  QGOptimalClassController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/13.
//
//

#import "QGOptimalClassController.h"


#import "QGEduClassViewController.h"
#import "QGCategoryCell.h"
#import "QGGetGoodsListByCategoryIdHttpDownload.h"
#import "QGEudCategoryHttpDownload.h"
#import "QGNoneCell.h"
#import "QGCategroyFoodCell.h"
#import "QGCategroyHeardView.h"
#import "QGStoreListViewController.h"
#import "QGMessageCenterViewController.h"
#import "QGSerachViewController.h"
#import "QGSearchResultViewController.h"

@interface QGOptimalClassController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate>

//左边列表
@property (strong, nonatomic)  UITableView *tableview;
//右边列表
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (nonatomic,strong) QGSublistModel *submodel;
@property (nonatomic,strong)  UIImageView *categoryImageView;//切换分类图
PropertyStrong(NSMutableArray,categorylists);//分类列表
PropertyStrong(NSMutableArray, brandlists);//品牌列表
@property (nonatomic,strong)NSMutableArray * rightSectionNames;//collection区头名
PropertyStrong(NSMutableArray, cells);
/** 左边的类别数据 */
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic,strong) QGCategroyModel *categroyModel;
@property (nonatomic,strong) NSString *strId;
@property (nonatomic,strong) UIImageView *searchBg;
@property (nonatomic,strong) UIButton *messageicon;
@property (nonatomic,strong) UIImageView *searchimg;
/**搜索框*/
@property(nonatomic,strong)UITextField *search;
@property (nonatomic,strong)UIButton *messeageLab;
@property (nonatomic,strong) UIView *navBGView;
@property (nonatomic,strong) SAButton *returnBtn;
PropertyInt(firstLoad);
PropertyInt(lastIndex);
@property(nonatomic,strong)NSIndexPath *selectIndexPath;

@end

@implementation QGOptimalClassController
static NSString * const reuseIdentifier = @"QGCategroyFoodCell";

#pragma mark 懒加载
- (NSMutableArray *)categories {
    if (!_categories) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}

- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

- (NSMutableArray *)brandlists {
    if (!_brandlists) {
        _brandlists = [NSMutableArray array];
    }
    return _brandlists;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseData];
    [self addLeftRequest];
    _rightSectionNames = [NSMutableArray arrayWithObjects:@"品类", @"热销品牌",nil];
    self.view.backgroundColor =RGB(242, 243, 244);
    // 默认选中首行
    
    [self adduserViewregisterClass];
}

- (void)adduserViewregisterClass {
    [self createReturnButton];
    _tableview = [[SATableView alloc]initWithFrame:CGRectMake(0,self.navImageView.maxY ,84,SCREEN_HEIGHT-self.navImageView.maxY)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.tableFooterView = [[UIView alloc]init];
    _tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableview];
    _categoryImageView=[[UIImageView alloc]init];
    [self.view addSubview:_categoryImageView];
    [self loadCategroyInfos:_categroyModel.id];
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    float inter=(SCREEN_WIDTH-_tableview.maxX-210)/4.0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = inter;//列间隔
    flowLayout.itemSize = CGSizeMake(60, 100);//cell大小
    flowLayout.sectionInset = UIEdgeInsetsMake(0,inter,0,inter);//偏移量
    
    _lastIndex = 0;
    _firstLoad = 0;
    _selectIndexPath = nil;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(_tableview.maxX+10, self.navImageView.maxY+30, SCREEN_WIDTH - _tableview.maxX-20, SCREEN_HEIGHT-self.navImageView.maxY-50) collectionViewLayout:flowLayout];
    _collectionView.alwaysBounceVertical=YES;
    [_collectionView registerClass:[QGCategroyFoodCell  class] forCellWithReuseIdentifier:reuseIdentifier];
    [_collectionView registerClass:[QGNoneCell  class] forCellWithReuseIdentifier:@"QGNoneCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[QGCategroyHeardView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    _collectionView.dataSource = self;
    _collectionView.delegate  = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    
    
    self.navImageView.alpha=0;
    _navBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBGView.backgroundColor = RGBA(255, 255, 255 ,1);
    [self.view addSubview:_navBGView];
    
    
    
    _returnBtn = [[SAButton alloc] initWithFrame:self.leftBtn.frame];
    [_navBGView addSubview:_returnBtn];
    _returnBtn.image = [UIImage imageNamed:@"icon_classification_back"];
    _returnBtn.titleFont = FONT_CUSTOM(14);
    PL_CODE_WEAK(ws)
    [_returnBtn addClick:^(SAButton *button) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    //[self updateCityBtnFrameWithTitle:@"深圳"];
    //搜索
    //        UIView  *searchView = [[UIView alloc]initWithFrame:CGRectMake(_sortBtn.maxX+10, 26, SCREEN_WIDTH-_sortBtn.maxX-57, 44)];
    UIView *searchView = [[UIView alloc]init];
    
    kClearBackground(searchView);
    [_navBGView addSubview:searchView];
    UIImageView *searchBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, searchView.width, 30)];
    searchBg.backgroundColor =  APPBackgroundColor;
    searchBg.layer.masksToBounds = YES;
    searchBg.layer.cornerRadius = 5;
    [searchView addSubview:searchBg];
    _searchBg = searchBg;
    //搜索图片
    UIImageView *serchImv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 8, 15, 15)];
    serchImv.image = [UIImage imageNamed:@"icon_classification_search"];
    [searchView addSubview:serchImv];//search-drop-down-icon
    _searchimg = serchImv;
    
    //搜索框
    _search = [[UITextField alloc]initWithFrame:CGRectMake(32, -6, searchView.width, 44)];
    _search.delegate = self;
    //        _search.textColor =PL_UTILS_COLORRGB(60, 60, 60);
    _search.returnKeyType = UIReturnKeySearch;
    _search.font = FONT_CUSTOM(14);
    UIColor *color = [UIColor lightGrayColor];
    _search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: color}];
    [searchView addSubview:_search];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_returnBtn.mas_right).offset(5);
        make.top.equalTo(@23);
        make.height.equalTo(@44);
        make.right.equalTo(_navBGView).offset(-50);
    }];
    [searchBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(searchView);
        make.height.equalTo(@30);
    }];
    [serchImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@7);
        make.top.equalTo(@8);
        make.width.height.equalTo(@15);
    }];
    [_search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@32);
        make.top.equalTo(searchView).offset(6);
        make.width.equalTo(searchView).offset(-15);
    }];
    [self addMesseageBtnInTheView:_navBGView];
    
    
}

- (void)addMesseageBtnInTheView:(UIView *)view
{
    //消息
    UIView * bottomView = [[UIView alloc] init];
    bottomView.frame=CGRectMake(SCREEN_WIDTH-7-40, 20, 40, 40);
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [messageBtn setBackgroundImage:[UIImage imageNamed:@"background_home_classification"] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"message_icon"] forState:UIControlStateNormal];
    messageBtn.enabled= YES;
    [messageBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(6, 0, 20, 20);
    messageBtn.centerX = 20;
    messageBtn.centerY = 20;
    _messageicon = messageBtn;
    
    
    [bottomView addSubview:messageBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [bottomView addGestureRecognizer:tap];
    [view addSubview:bottomView];
}
-(void) btnClick{
    
    if ([self loginIfNeeded]) {
        return;
    };
    QGMessageCenterViewController *vc = [QGMessageCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark 左边数据请求
- (void)addLeftRequest {
     [[SAProgressHud sharedInstance]showWaitWithWindow];
    [QGHttpManager mallDataSuccess:^(QGCategroyResultModel *result) {
        
        self.categories = result.items;
        _categroyModel = _categories[0];
        [self loadCategroyInfos:_categroyModel.id];
        [_collectionView reloadData];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
         [self showTopIndicatorWithError:error];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // 左边的类别表格
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PL_CELL_NIB_CREATE(QGCategoryCell);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.model = _categories[indexPath.row];
    
    if (indexPath.row == 0&& _firstLoad == 0)
    {
        cell.categoryTitleLbl.textColor = RGB(89, 89, 90);
        cell.image.backgroundColor = RGB(242, 243, 244);
    }
    
    else  if([_selectIndexPath isEqual:indexPath]){
        
        cell.categoryTitleLbl.textColor = RGB(89, 89, 90);
        cell.image.backgroundColor = RGB(242, 243, 244);
    }
    
    else{
        cell.categoryTitleLbl.textColor = RGB(89, 89, 90);
        cell.image.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   _firstLoad = _firstLoad+1;
    _firstLoad ++;
    float w = SCREEN_WIDTH - _tableview.maxX-20;
    //刷新右边的数据
    _categroyModel = _categories[indexPath.row];
    
    if ([_categroyModel.id isEqualToString:@"0"]) {
        
        _categoryImageView.hidden= YES;
        _collectionView.frame  =CGRectMake(_tableview.maxX+10, self.navImageView.maxY+30, w, SCREEN_HEIGHT-self.navImageView.maxY-10);
        
        [self loadCategroyInfos:_categroyModel.id];
    }else {
        _categoryImageView.hidden= NO;
        _categoryImageView.frame = CGRectMake(_tableview.maxX+10, self.navImageView.maxY+10,w,w*0.4);
        [_categoryImageView sd_setImageWithURL:[NSURL URLWithString:_categroyModel.logo] placeholderImage:nil];
        
        _collectionView.frame  =CGRectMake(_tableview.maxX+10, self.navImageView.maxY+w*0.4+10, w, SCREEN_HEIGHT-self.navImageView.maxY-w*0.4-10);
        
        [self.view addSubview:_categoryImageView];
        
        
        [self loadCategroyInfos:_categroyModel.id];
        
    }
    _selectIndexPath = indexPath ;
    [self.tableview reloadData];
    
}
#pragma mark 加载对应分类的商品信息
-(void)loadCategroyInfos:(NSString *)reid
{
    [_collectionView reloadData];
    [[SAProgressHud sharedInstance] showWaitWithWindow];
    
    QGGetMallByCategoryIdHttpDownload *ghd = [[QGGetMallByCategoryIdHttpDownload alloc]init];
    ghd.platform_id= [SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id];
    ghd.reid = reid;
    
    [QGHttpManager mallListDataWithParam:ghd Success:^(QGCategroyGoodsListResultModel *result) {
        
        _categorylists = [NSMutableArray new];
        _rightSectionNames = [NSMutableArray arrayWithObjects:@"品类",@"热销品牌", nil];
        _categorylists = result.items;
        _brandlists = result.brandList;
        [_collectionView reloadData];

    } failure:^(NSError *error) {
        
         [self showTopIndicatorWithError:error];
        [_collectionView reloadData];
    }];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _rightSectionNames.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{   if (section==0)
    
    return _categorylists.count;
else
    return _brandlists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        QGCategroyFoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QGCategroyFoodCell" forIndexPath:indexPath];
        cell.model = _categorylists[indexPath.row];
        
        return cell;
    }else {
        
        
        QGCategroyFoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QGCategroyFoodCell" forIndexPath:indexPath];
        cell.model = _brandlists[indexPath.row];
        
        return cell;
        
    }
}

//定义并返回每个headerView或footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        QGCategroyHeardView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.title.text=_rightSectionNames[indexPath.section];
        headerView.backgroundColor = RGB(242, 243, 244);
        reusableView = headerView;
        
        
    }
    return reusableView ? reusableView : nil;
}

// 定义headview的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([_categroyModel.id isEqualToString:@"0"]) {
        
        
        return CGSizeMake(0,0);
    }
    
    return CGSizeMake(SCREEN_WIDTH - _tableview.maxX+5, 60);
}


#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     QGSearchResultViewController *sear = [[QGSearchResultViewController alloc] init];
    if (indexPath.section ==0) {
        QGSublistModel *model = _categorylists[indexPath.row];
        sear.catogoryId = model.id;
        sear.searchOptionType = QGSearchOptionTypeGoods;
    }else {
        
         QGSublistModel *model = _brandlists[indexPath.row];
         sear.searchOptionType = QGSearchOptionTypeGoods;
         sear.brand_id = model.id;
        }
    
    
     [self.navigationController pushViewController:sear animated:YES];
       
    

  }
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    QGSerachViewController *cvc = [[QGSerachViewController alloc]init];
    _search.text = nil;
    [self.navigationController pushViewController:cvc animated:YES];
}


@end

