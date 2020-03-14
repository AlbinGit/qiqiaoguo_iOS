//
//  QGSubjectView.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHomeSubjectView.h"
#import "QGSubjectCollectionViewCell.h"

@interface QGHomeSubjectView ()

@property (nonatomic, strong) UICollectionView * collectionView;
/**存放图片数据*/
@property (nonatomic, strong) NSMutableArray * imageArray;
/**点击回调*/
@property (nonatomic, copy) QGSubjectViewBlock block;

@end

@implementation QGHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageArray = [[NSMutableArray alloc]init];
        [self p_createCollectionView];
    }
    return self;
}

- (void)p_createCollectionView {
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 0;
//    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.0 , 75);
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
////        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(_tableview.maxX+10, self.navImageView.maxY+30, SCREEN_WIDTH - _tableview.maxX-20, SCREEN_HEIGHT-self.navImageView.maxY-50) collectionViewLayout:flowLayout];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.0 , 80);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
      _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MQScreenW, self.height) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[QGSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"subject"];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
}
#pragma mark collectionViewDelegateAndDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QGSubjectCollectionViewCell * scell = [collectionView dequeueReusableCellWithReuseIdentifier:@"subject" forIndexPath:indexPath];
    if (scell) {
      //  scell.imageView.image = [UIImage imageNamed:@"icon_zaojiao"];
        [scell setModelListModel:_imageArray[indexPath.item] item:indexPath.item];
      
    }
    return scell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_block) // 点击item回调对应的model
        _block(_imageArray[indexPath.item]);
}
/**
 *  设置图片数据源
 *
 *  @param array 图片数据
 */
- (void)addDataToImageArray:(NSArray *)array {
    _collectionView.height = self.height;
    [self.imageArray addObjectsFromArray:array];
    [self.collectionView reloadData];
}
/**
 *  为block赋值
 *
 *  @param block 点击图片做的操作
 */
- (void)tapModel:(QGSubjectViewBlock)block {
    _block = block;
}

@end
