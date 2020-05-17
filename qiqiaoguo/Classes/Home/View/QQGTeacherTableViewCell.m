//
//  QQGTeacherTableViewCell.m
//  qiqiaoguo
//
//  Created by 李艳彬 on 2020/5/17.
//

#import "QQGTeacherTableViewCell.h"
#import "QGTeacherViewController.h"

@interface QQGTeacherTableViewitemCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation QQGTeacherTableViewitemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat itemWidth  = (MQScreenW-4*10)/3.0;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemWidth)];
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgView.maxY, self.width, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorFromHexString:@"666666"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
}

@end

@interface QQGTeacherTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation QQGTeacherTableViewCell

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
  
    CGFloat itemWidth  = (MQScreenW-4*10)/3.0;

    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing      = 10;
    flow.itemSize = CGSizeMake( itemWidth, itemWidth+40);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, itemWidth+40) collectionViewLayout:flow];

    [self.collectionView registerClass:[QQGTeacherTableViewitemCell class] forCellWithReuseIdentifier:@"CollectionCellId"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"CollectionCellId";
    QQGTeacherTableViewitemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    QQGTeacherListModel *model = _dataSource[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:nil];
    cell.titleLabel.text = model.teacher_name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QQGTeacherListModel *model = _dataSource[indexPath.row];
    QGTeacherViewController *vc = [[QGTeacherViewController alloc] init];
    vc.teacher_id = model.teacher_id;
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
}

@end
