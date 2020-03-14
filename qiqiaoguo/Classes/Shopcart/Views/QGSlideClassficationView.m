//
//  QGSlideClassficationView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//
static NSString *const cellSign=@"slidClass";
#import "QGSlideClassficationView.h"
#import "QGSlideClassficationCollectionViewCell.h"
@interface QGSlideClassficationView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)BOOL isShowRedLine;//是否显示红线
@property (nonatomic,copy)QGSlideClassficationViewBlock block;
@property (nonatomic,strong)UICollectionView *collectionView;
@end
@implementation QGSlideClassficationView
- (id)initWithFrame:(CGRect)frame withCurrentSelectIndex:(NSInteger)currentIndex  andTitles:(NSArray *)titles{
    self=[super initWithFrame:frame];
    if (self)
    {
        _currentIndex=currentIndex;
        _titles=titles;
     
    }
    return self;
}
- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor=selectColor;
    [_collectionView reloadData];
}
- (void)setNomoalColor:(UIColor *)nomoalColor
{
    _nomoalColor=nomoalColor;
    [self createCollection];
}

- (void)createCollection
{
    CGFloat width=0.0;
    if (_titles.count>=4)
        width=SCREEN_WIDTH/4.0;
    else
    {
        width=SCREEN_WIDTH/_titles.count;
        _collectionView.scrollEnabled=NO;
    }
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.itemSize=CGSizeMake(width, self.height);
    flow.minimumInteritemSpacing=0;
    flow.minimumLineSpacing=0;
    flow.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _collectionView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flow];
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.backgroundColor=PL_COLOR_255;
    _collectionView.contentSize=CGSizeMake(width*_titles.count, self.height);
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[QGSlideClassficationCollectionViewCell class] forCellWithReuseIdentifier:cellSign];
    [self addSubview:_collectionView];
    if (_currentIndex>=4)
    {
        CGFloat width=0.0;
        if (_titles.count>=4)
            width=SCREEN_WIDTH/4.0;
        [_collectionView setContentOffset:CGPointMake(width*2, 0) animated:YES];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QGSlideClassficationCollectionViewCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellSign forIndexPath:indexPath];

    if (_currentIndex==indexPath.row)
    {
        cell.titleName.textColor=_selectColor;
        cell.titleName.backgroundColor = QGMainRedColor ;
    }else
    {
        cell.titleName.textColor=_nomoalColor;
        cell.titleName.backgroundColor = APPBackgroundColor;
   
    }
   cell.titleName.text=_titles[indexPath.row];
   

    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{   _currentIndex=indexPath.row;
    QGSlideClassficationCollectionViewCell *cell=(QGSlideClassficationCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleName.textColor=PL_COLOR_243;
    if (_titles.count>4)
    {
        if (indexPath.row>=2)
        {
            [self modifyContenOfset:indexPath];
        }else if(indexPath.row<=1)
        {
            [_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self reloadUI:indexPath];
        }
    }else
        [self reloadUI:indexPath];
    
    
}
- (void)reloadUI:(NSIndexPath *)indexPath
{
    PL_CODE_WEAK(ws);
    if (_block)
    {
        _block(indexPath.row,ws.tag);
    }
    [_collectionView reloadData];
}
- (void)modifyContenOfset:(NSIndexPath *)indexPath
{
    CGFloat width=0.0;
    if (_titles.count>=4)
        width=SCREEN_WIDTH/4.0;
    if (_titles.count>4&&indexPath.row>=2)
    {
        [_collectionView setContentOffset:CGPointMake(width*(indexPath.row-1), 0) animated:YES];
    }
    [self reloadUI:indexPath];
}
- (void)getCurrentSelectIndex:(QGSlideClassficationViewBlock)block
{
    _block=block;
}
- (void)setLastIndex:(NSInteger)lastIndex
{
    _lastIndex=lastIndex;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_lastIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    _currentIndex=_lastIndex;
    [_collectionView reloadData];
}
@end
