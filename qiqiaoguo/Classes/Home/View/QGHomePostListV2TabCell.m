//
//  QGHomePostListV2TabCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/8.
//
//

#import "QGHomePostListV2TabCell.h"
#import "QGHomePostListV2Cell.h"
#import "QGPostListModel.h"
#import "BLUPostDetailAsyncViewController.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGTabBarViewController.h"

static NSString * const QGfooterViewCellIdentifier = @"footerViewCellIdentifier";


@interface QGHomePostListV2TabCell ()
@property (nonatomic, strong) NSMutableArray   *firstRowCellCountArray;
@property (nonatomic,assign) CGFloat itemH;
@property (nonatomic,assign) CGFloat itemW;
@end

@implementation QGHomePostListV2TabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _firstRowCellCountArray = [NSMutableArray array];
        CGFloat itemWidth  = (MQScreenW-20)/2.0-15;
        CGFloat itemHeight = itemWidth*0.53+8;
        _itemH = itemHeight;
        _itemW = itemWidth;
        [self p_createUI];
    }
    
    return self;
}


- (void)p_createUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing      = 0;
    flow .itemSize = CGSizeMake( _itemW, _itemH);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, _itemH*2+44) collectionViewLayout:flow];
    [_collectionView registerClass:[QGHomePostListV2Cell  class] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.scrollEnabled = NO;
    [self.contentView addSubview:_collectionView];
    [self.collectionView registerClass:[QGCollectionFooterLineView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QGfooterViewCellIdentifier];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_firstRowCellCountArray.count>0 || _postList.count <4) {
        return _postList.count;
    }else
        return 4;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellID";
    QGHomePostListV2Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    QGPostListModel *postModel = _postList[indexPath.row];
    cell.po = postModel;
    return cell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqual:UICollectionElementKindSectionFooter]) {
        
        QGCollectionFooterLineView *footerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                           withReuseIdentifier: QGfooterViewCellIdentifier
                                                  forIndexPath:indexPath];
        footerView.delegate = self;
        if (_postList.count<5) {
            [footerView.btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [footerView.btn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:UIControlStateNormal];
            
            [footerView.btn addClick:^(UIButton *button) {
                QGTabBarViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                vc.selectedIndex = 2;
                
            }];
        }
        reusableView = footerView;
    }
    return reusableView;
    
}
- (void)setPostList:(NSMutableArray *)postList {
    _postList = postList;
    int totalCol = 2;
    int row = (_postList.count-1) / totalCol;
    CGFloat y = (_itemH) * row;
    
    if (_firstRowCellCountArray.count>0) {
        _collectionView.height =y +_itemH+44;
    }
    if (_postList.count<3) {
        
        _collectionView.height = _itemH+44;
    }
}
#pragma mark  QGCollectionVideoFooterView代理
- (void)collectionVideoFooterViewMoreBtnClicked:(QGCollectionFooterLineView *)sender{
    PL_CODE_WEAK(ws);
    if (sender.isOpen) {
        CGFloat itemWidth  = (MQScreenW-20)/2.0-15;
        CGFloat itemHeight = itemWidth*0.53+8;
        int totalCol = 2;
        int row = (_postList.count-1) / totalCol;
        CGFloat y = (itemHeight) * row;
        [UIView animateWithDuration:0.5f animations:^{
                [ws.firstRowCellCountArray addObject:ws.postList];
            _collectionView.frame  = CGRectMake(10, 0, SCREEN_WIDTH-20, y +itemHeight+44);
            if (ws.postList.count>4) {
                
                if ([self.delegate respondsToSelector:@selector(QGHomePostListV2TabCellMoreBtnClicked:)]) {
                    [self.delegate QGHomePostListV2TabCellMoreBtnClicked:self];
                }
            }
            [sender.btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [sender.btn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:UIControlStateNormal];
            
        }];
        
    }else {
        sender.open = !sender.isOpen;
        QGTabBarViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        vc.selectedIndex = 2;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    QGPostListModel *model =_postList[indexPath.row];
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc]initWithPostID:model.id.integerValue];
    [viewController.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - UICollectionViewDelegateFlowLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MQScreenW, 44);
}
@end
