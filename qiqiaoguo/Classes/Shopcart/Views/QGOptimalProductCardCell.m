//
//  QGOptimalProductCardCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import "QGOptimalProductCardCell.h"
#import "QGOptimalProductGridLayout.h"
#import "QGOptimalProductPhotoCell.h"
#import "QGProductDetailsViewController.h"
#import "QGSearchResultViewController.h"
#import "QGBannerWebViewController.h"
#import "QGProductDetailsViewController.h"
#import "QGSecKillViewController.h"
#import "QGOptimalClassController.h"
#import "QGActivityHomeViewController.h"
#import "QGActivityDetailViewController.h"
#import "QGCourseDetailViewController.h"
#import "BLUCircleDetailViewController.h"
#import "BLUPostTagDetailViewController.h"
#import "BLUCircleMainViewController.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGEducationViewController.h"
#import "QGTeacherViewController.h"
#import "QGOrgViewController.h"
@interface QGOptimalProductCardCell ()

@property (nonatomic,strong) UIImageView *ima;
@property (nonatomic,strong) UIButton *btn ;
@property (nonatomic,strong) UIView *view;
@end


@implementation QGOptimalProductCardCell

static NSString * const QGPhotoId = @"photo";


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 54)];
        view.backgroundColor = COLOR(242, 243, 244, 1);
        
        [self.contentView addSubview:view]; _view = view;
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 10, MQScreenW, 44)];
        btn.userInteractionEnabled = NO;
        [btn setTitleFont:[UIFont systemFontOfSize:16]];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorFromHexString:@"ff3859"] forState:(UIControlStateNormal)];
        [view addSubview:btn];
          _btn = btn;
       
        UIImageView *ima =[[UIImageView alloc] init];
        [btn addSubview:ima];
        self.ima = ima;
    }
    return self;
}


- (void)p_createUI {
    [_ima sd_setImageWithURL:[NSURL URLWithString:_SubjrctListModel.cover] placeholderImage:nil];

     [_btn setTitle:_SubjrctListModel.title];

    [_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 22 , 0,0)];
    [_ima mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_btn.titleLabel.mas_left).offset(-22);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        
         make.top.equalTo(_btn).offset(12);
        
    }];
    // 创建布局
    QGOptimalProductGridLayout *layout = [[QGOptimalProductGridLayout alloc] init];
    
    if ([_SubjrctListModel.sign isEqualToString:@"4_2"]) {
         layout.cellType =QGOptimalProductGridLayoutTwo;
    }else if([_SubjrctListModel.sign isEqualToString:@"1_1"]){
        
         layout.cellType =QGOptimalProductGridLayoutOne;
        
    }else if ([_SubjrctListModel.sign isEqualToString:@"2_1"]){
        
         layout.cellType =QGOptimalProductGridLayoutThree;
        
    }else if ([_SubjrctListModel.sign isEqualToString:@"4_3"]){
        
        layout.cellType = QGOptimalProductGridLayoutFour;
        
    }else if ([_SubjrctListModel.sign isEqualToString:@"4_1"]){
        
        layout.cellType = QGOptimalProductGridLayoutFive;
        
    }else if ([_SubjrctListModel.sign isEqualToString:@"3_3"]){
        
        
        layout.cellType = QGOptimalProductGridLayoutSix;
    }else if ([_SubjrctListModel.sign isEqualToString:@"3_2"]){
        
        
        layout.cellType = QGOptimalProductGridLayoutSeven;
    }else if ([_SubjrctListModel.sign isEqualToString:@"3_1"]) {
        
        layout.cellType = QGOptimalProductGridLayoutEight;
        
    }else if ([_SubjrctListModel.sign isEqualToString:@"2_2"]) {
        
        layout.cellType = QGOptimalProductGridLayoutNine;
        
    }else {
        
        layout.cellType = QGOptimalProductGridLayoutNine;
        
    }
    // 创建CollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _view.maxY,MQScreenW, MQScreenW*0.5) collectionViewLayout:layout];
    _collectionView.backgroundColor = COLOR(242, 243, 244, 1);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
 
      [self.contentView addSubview:_collectionView];;
    
    // 注册
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QGOptimalProductPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:QGPhotoId];
    
}

- (void)setSubjrctListModel:(QGOptimalProductSubjrctListModel *)SubjrctListModel {
    _SubjrctListModel = SubjrctListModel;
    
      [self p_createUI];
}

//
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _SubjrctListModel.cardList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
       QGOptimalProductPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QGPhotoId forIndexPath:indexPath];
    
        QGSubjrctCardListModel *model = _SubjrctListModel.cardList[indexPath.row];
        cell.imageName = model.cover;
 
;
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QGSubjrctCardListModel *banner = _SubjrctListModel.cardList[indexPath.row];
  
   UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    if ([banner.type integerValue]==1)
    {
        [self goSingleItemViewC:banner.activity_id];
    }else if([banner.type integerValue]==2)
    {
        [self goComboViewC:banner.activity_id];
    }else if([banner.type integerValue]==3)
    {
        [self goSubjectBrandViewC];
    }else if([banner.type integerValue]==4)
    {
        [self goClassViewC:banner.activity_id];
    }else if ([banner.type integerValue]==5)
    {
        QGBannerWebViewController *b=[[QGBannerWebViewController alloc]init];
        b.url = banner.url;
        [viewController.navigationController pushViewController:b animated:YES];
    }
    else if ([banner.type integerValue]==6)
    {
        [self goClassWithCategoryViewC:banner.activity_id];
    }else if ([banner.type integerValue]==7)
    {
        [self goEducationMainViewController];
    }else if ([banner.type integerValue]==8)
    {
        [self goOrgViewController:banner.activity_id];
    }else if ([banner.type integerValue]==9)
    {
        [self goTeacherViewController:banner.activity_id];
    }else if ([banner.type integerValue]==10)
    {
        [self goCourseListViewController];
    }
    else if ([banner.type integerValue]==11)
    {
        [self goCourseDetailViewController:banner.activity_id];
    }
    else if ([banner.type integerValue]==18)
    {// 机构详情
        [self goNearOrgDetailViewC:banner.activity_id];
    }else if ([banner.type integerValue]==20)
    {
        [self goEduCourseSearchResultVC:banner.activity_id];
    }
    else if ([banner.type integerValue]==12)
    {// 活动列表
        [self goActListVC];
    } else if ([banner.type integerValue]==19)
    {// 活动详情
        [self goNearTheacherDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==13)
    {// 活动详情
        [self goNearActDetailViewC:banner.activity_id];
    }
    else if ([banner.type integerValue]==100)
    {// 巧妈帮首页
        BLUCircleMainViewController *Circle = [[BLUCircleMainViewController alloc]init];
        [viewController.navigationController pushViewController:Circle animated:YES];
    }
    else if ([banner.type integerValue]==101)
    {//帖子详情BLUPostDetailAsyncViewController
        BLUPostDetailAsyncViewController *Circle = [[BLUPostDetailAsyncViewController alloc]initWithPostID:(int)banner.activity_id];
        [viewController.navigationController pushViewController:Circle animated:YES];
    }
    else if ([banner.type integerValue]==102)
    {// 某一个圈子
        BLUCircleDetailMainViewController *Circle = [[BLUCircleDetailMainViewController alloc]initWithCircleID:banner.activity_id.integerValue];
        [viewController.navigationController pushViewController:Circle animated:YES];
    }
    else if ([banner.type integerValue]==111)
    {// 话题标签
        BLUPostTagDetailViewController *tagVC = [[BLUPostTagDetailViewController alloc] initWithTagID:(int)banner.activity_id];
        [viewController.navigationController pushViewController:tagVC animated:YES];
    }
    NSLog(@"选择了%ld个cell",indexPath.row);
}
/**
 *  单品
 *
 *  @param addonline_id 商品详情id
 */
- (void)goSingleItemViewC:(NSString *)addonline_id
{  UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGProductDetailsViewController *single=[QGProductDetailsViewController new];
    single.goods_id=addonline_id;
    [viewController.navigationController pushViewController:single animated:YES];
}
#pragma  mark 品牌特卖
/**
 *  品牌特卖
 *
 *  @param subjectid 品牌特卖id
 */
- (void)goSubjectBrandViewC
{
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGSecKillViewController *subjectBrand=[QGSecKillViewController new];
    
    [viewController.navigationController pushViewController:subjectBrand animated:YES];
}
#pragma  mark 去套餐
/**
 *  套餐
 *
 *  @param combo_addonline_id 套餐id
 */
- (void)goComboViewC:(NSString *)combo_addonline_id
{
    
}
#pragma  mark 品牌
/**
 *  品牌
 *
 *  @param bannerId 品牌id
 */
- (void)goClassViewC:(NSString *)shopid
{UIViewController *viewController = [SAUtils findViewControllerWithView:self];
  
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];

    search.brand_id = shopid;
    search.searchOptionType =  QGSearchOptionTypeGoods;

    [viewController.navigationController pushViewController:search animated:YES];
}
#pragma  mark 分类
/**
 *  分类
 *
 *  @param category_id 分类id
 */
- (void)goClassWithCategoryViewC:(NSString *)Category
{
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId =Category;
    search.searchOptionType = QGSearchOptionTypeGoods;
    [viewController.navigationController pushViewController:search animated:YES];
}

#pragma mark 机构
/**
 *  机构
 *
 *  @param org_id 机构id
 */
- (void)goOrgViewController:(NSString *)org_id
{UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = org_id;
    search.searchOptionType = QGSearchOptionTypeInstitution;
    [viewController.navigationController pushViewController:search animated:YES];
}
#pragma mark 教师
/**
 *  教师页
 *
 *  @param teacherId 教师id
 */
- (void)goTeacherViewController:(NSString *)teacherId
{UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = teacherId;
    search.searchOptionType = QGSearchOptionTypeTeacher;
    [viewController.navigationController pushViewController:search animated:YES];
}
#pragma mark 班课
/**
 *  班课
 *
 *  @param course_id 班课id
 */
- (void)goCourseDetailViewController:(NSString *)course_id
{UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];
    search.catogoryId = course_id;
    search.searchOptionType = QGSearchOptionTypeCourse;
    [viewController.navigationController pushViewController:search animated:YES];
}
- (void)goCourseListViewController {
    
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGSearchResultViewController *search = [[QGSearchResultViewController alloc] init];

    search.searchOptionType = QGSearchOptionTypeCourse;
    [viewController.navigationController pushViewController:search animated:YES];
    
}
#pragma mark 活动

- (void)goActListVC
{
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    viewController.tabBarController.selectedIndex=1;
}

/**
 *  活动详情
 *
 *  @param actid 活动id
 */
- (void)goNearActDetailViewC:(NSString *)actid
{UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGActivityDetailViewController *ctl = [[QGActivityDetailViewController alloc] init];
    ctl.activity_id = actid;
    
    [viewController.navigationController pushViewController:ctl animated:YES];
}
#pragma mark 教育首页
/**
 *  教育首页
 */
- (void)goEducationMainViewController
{
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    viewController.tabBarController.selectedIndex=1;
    
}
- (void)goEduCourseSearchResultVC:(NSString *)catogoryId
{   UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGCourseDetailViewController * ctr = [[QGCourseDetailViewController alloc]init];
    ctr.course_id = catogoryId;
    
    [viewController.navigationController pushViewController:ctr animated:YES];
}
/**
 *  教师详情
 *
 *  @param actid 活动id
 */
- (void)goNearTheacherDetailViewC:(NSString *)teacher_id
{    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGTeacherViewController *ctl = [[QGTeacherViewController alloc] init];
    ctl.teacher_id = teacher_id;
    
    [viewController.navigationController pushViewController:ctl animated:YES];
}
/**
 *  机构详情
 *
 *  @param actid 活动id
 */
- (void)goNearOrgDetailViewC:(NSString *)org_id
{ UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGOrgViewController *ctl = [[QGOrgViewController alloc] init];
    ctl.org_id = org_id;
    
    [viewController.navigationController pushViewController:ctl animated:YES];
}
@end
