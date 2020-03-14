//
//  QGTeacherCouseTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import <UIKit/UIKit.h>

@interface QGTeacherCouseTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataSource;
@end
