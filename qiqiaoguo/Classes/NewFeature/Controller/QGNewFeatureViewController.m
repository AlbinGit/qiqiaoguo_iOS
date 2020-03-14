//
//  QGNewFeatureViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/26.
//
//

#import "QGNewFeatureViewController.h"






#import "QGNewFeatureCell.h"

@interface QGNewFeatureViewController ()

@property (nonatomic, assign) CGFloat lastoffsetX;
@property (nonatomic, weak) UIPageControl *control;


@end

@implementation QGNewFeatureViewController



- (instancetype)init
{
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    

    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 设置最小行间距 10
    layout.minimumLineSpacing = 0;
    // 设置每个cell之间间距
    layout.minimumInteritemSpacing = 0;

    // 设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return  [self initWithCollectionViewLayout:layout];
}
static NSString *ID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpCollectionView];
    

    
}

#pragma UIScrollView代理



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    _control.currentPage = page;
}
// 设置CollectionView
- (void)setUpCollectionView
{
    // 注册cell
    [self.collectionView registerClass:[QGNewFeatureCell class] forCellWithReuseIdentifier:ID];
    // 分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    UIPageControl *control = [[UIPageControl alloc] init];
    control.numberOfPages = 3;
    control.pageIndicatorTintColor = COLOR(212, 212, 212, 1);
    control.currentPageIndicatorTintColor = COLOR(166, 166, 166, 1);
    // 设置center
    control.center = CGPointMake(self.view.width * 0.5, self.view.height*0.95);

    _control = control;
    [self.view addSubview:control];
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}


- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
   QGNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
   
    NSString *imageName = [NSString stringWithFormat:@"guide%ld",indexPath.row + 1];
    cell.image = [UIImage imageNamed:imageName];
    [cell setIndexPath:indexPath count:3];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

@end
