//
//  QGEduFristActivityListCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/1.
//
//

#import <UIKit/UIKit.h>

@interface QGEduFristActivityListCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic)  UIScrollView *scoll;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataSource;

@end
