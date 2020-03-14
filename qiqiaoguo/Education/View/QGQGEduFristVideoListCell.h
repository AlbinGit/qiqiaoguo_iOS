//
//  QGQGEduFristVideoListCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/30.
//
//

#import <UIKit/UIKit.h>
#import "QGEduHomeResult.h"
@interface QGQGEduFristVideoListCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong) QGEduVideoListModel *model;


@end
