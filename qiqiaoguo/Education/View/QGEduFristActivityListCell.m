//
//  QGEduFristActivityListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/1.
//
//

#import "QGEduFristActivityListCell.h"

#import "QGEduFristActivityCell.h"
#import "QGActivityDetailViewController.h"
@implementation QGEduFristActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    flow.itemSize = CGSizeMake(MQScreenW*0.38, MQScreenW*0.23);

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20,MQScreenW*0.23+20) collectionViewLayout:flow];
   [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QGEduFristActivityCell class]) bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_collectionView];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    
    return _dataSource.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    QGEduFristActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[QGEduFristActivityCell alloc]init];
    }

    QGEduActivityListModel *model = _dataSource[indexPath.row];
    cell.imageName = model.coverPicPop;


     //    [cell setImageForCellWithIndexpath:indexPath];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      QGEduActivityListModel *model = _dataSource[indexPath.row];
    QGActivityDetailViewController *vc = [[QGActivityDetailViewController alloc] init];
     vc.activity_id = model.id;
   
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
    NSLog(@"选择了%ld个cell",indexPath.row);
}
@end
