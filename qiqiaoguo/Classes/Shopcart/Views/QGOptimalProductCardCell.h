//
//  QGOptimalProductCardCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import <UIKit/UIKit.h>
#import "QGOptimalProductSubjrctListModel.h"

@interface QGOptimalProductCardCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)QGOptimalProductSubjrctListModel *SubjrctListModel;


@end
