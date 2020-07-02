//
//  QGNewTeacherVideoCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/4.
//

#import <UIKit/UIKit.h>
#import "QGCollectionVideoFooterView.h"

@class QGNewTeacherVideoCell;

@protocol QGNewTeacherVideoCellDelegate <NSObject>

@required

- (void)QGNewTeacherVideoCellMoreBtnClicked:(QGNewTeacherVideoCell *)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QGNewTeacherVideoCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QGCollectionVideoFooterViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,copy) NSString *videoCircleId;
@property (nonatomic,strong) id<QGNewTeacherVideoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
