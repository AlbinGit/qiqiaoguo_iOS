//
//  QGQGEduFristVideoListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/30.
//
//

#import "QGQGEduFristVideoListCell.h"
#import "QGEduGroupCollectionViewCell.h"
#import "BLUPostDetailAsyncViewController.h"
@implementation QGQGEduFristVideoListCell

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
    
    flow.itemSize = CGSizeMake(90, 125);
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 125) collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"QGEduGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_collectionView];


}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataSource.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cell";
    QGEduGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
      QGEduVideoListModel *model = _dataSource[indexPath.row];
    
        [cell.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPicPop] placeholderImage:nil];
        cell.groupNameLabel.text = model.title;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QGEduVideoListModel *model = _dataSource[indexPath.row];
    BLUPostDetailAsyncViewController *vc = [[BLUPostDetailAsyncViewController alloc] initWithPostID:model.id.integerValue];
    
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
}
@end
