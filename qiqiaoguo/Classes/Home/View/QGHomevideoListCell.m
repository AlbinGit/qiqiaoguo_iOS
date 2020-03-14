//
//  QGHomevideoListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/6.
//
//

#import "QGHomevideoListCell.h"

#import "QGVideoListCollectionViewCell.h"
#import "BLUCircleDetailMainViewController.h"
#import "BLUPostDetailAsyncViewController.h"
static NSString * const QGfooterViewCellIdentifier = @"footerViewCellIdentifier";


@interface QGHomevideoListCell ()
@property (nonatomic, strong) NSMutableArray   *firstRowCellCountArray;


@end

@implementation QGHomevideoListCell

#define collectionViewCellId @"categoryCollectionCellId"
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
      
        _firstRowCellCountArray = [NSMutableArray array];
         [self p_createUI];
    }

    return self;
}



- (void)p_createUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
  
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*9/16;

    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flow.minimumInteritemSpacing = 10;
    flow.minimumLineSpacing      = 0;
    flow .itemSize = CGSizeMake( itemWidth, itemHeight +50);

    CGFloat H = 0;
     H = (itemHeight +50)*2+44;
      _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, H) collectionViewLayout:flow];

    [self.collectionView registerNib:[UINib nibWithNibName:@"QGVideoListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CollectionCellId"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.allowsMultipleSelection = YES;
    [self.contentView addSubview:_collectionView];
    [self.collectionView registerClass:[QGCollectionVideoFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QGfooterViewCellIdentifier];
    
}



- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource =dataSource;

    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*9/16;
    int totalCol = 2;
    int row = (_dataSource.count-1) / totalCol;
    CGFloat y = (itemHeight + 50) * row;

    if (_firstRowCellCountArray.count>0 || _dataSource.count<3) {
        
        
        _collectionView.height = y +itemHeight+50 +44;
        
        
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_firstRowCellCountArray.count>0||_dataSource.count<4 ) {
      return _dataSource.count;
    }else
    return 4;
}



- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CollectionCellId";
    QGVideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    QGEduVideoListModel *model = _dataSource[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPicPop] placeholderImage:nil];
    cell.videoTitle.text = model.title;
    cell.videoCount.text = model.access_count;
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
     UICollectionReusableView *reusableView = nil;
    if ([kind isEqual:UICollectionElementKindSectionFooter]) {
        
       QGCollectionVideoFooterView *footerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                           withReuseIdentifier: QGfooterViewCellIdentifier
                                           forIndexPath:indexPath];
        
        
        
        if (_dataSource.count<5) {
            [footerView.btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [footerView.btn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:UIControlStateNormal];
      
            [footerView.btn addClick:^(UIButton *button) {
                UIViewController *viewController = [SAUtils findViewControllerWithView:self];
                
                BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:_videoCircleId.integerValue];
                [viewController.navigationController pushViewController:vc animated:YES];
                
            }];
        }else {
            
           footerView.delegate = self;
            
        }
         reusableView = footerView;
    }


    return reusableView;

}
#pragma mark  QGCollectionVideoFooterView代理
- (void)collectionVideoFooterViewMoreBtnClicked:(QGCollectionVideoFooterView *)sender {
         PL_CODE_WEAK(ws);
        if (sender.isOpen) {
            CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
            CGFloat itemHeight = itemWidth*9/16;
            int totalCol = 2;
            int row = (_dataSource.count-1) / totalCol;
            CGFloat y =  (itemHeight + 50) * row;
        [UIView animateWithDuration:0.5f animations:^{
         [ws.firstRowCellCountArray addObject:_dataSource];
            ws.collectionView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, y +itemHeight+50+44);
            [sender.btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [sender.btn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:UIControlStateNormal];
            if (ws.dataSource.count>4) {
                if ([ws.delegate respondsToSelector:@selector(QGHomevideoListCellMoreBtnClicked:)]) {
                    [ws.delegate QGHomevideoListCellMoreBtnClicked:self];
                }
             
            }
          
            
        }];
      }else {
        sender.open = !sender.isOpen;
        UIViewController *viewController = [SAUtils findViewControllerWithView:self];
        BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:_videoCircleId.integerValue];
        [viewController.navigationController pushViewController:vc animated:YES];
      
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QGEduVideoListModel *model = _dataSource[indexPath.row];
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:model.id.integerValue];
    
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDelegateFlowLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MQScreenW, 44);
}

@end
