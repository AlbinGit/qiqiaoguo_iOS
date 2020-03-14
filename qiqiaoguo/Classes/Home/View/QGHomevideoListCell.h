//
//  QGHomevideoListCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/6.
//
//

#import <UIKit/UIKit.h>
#import "QGCollectionVideoFooterView.h"
 @class QGHomevideoListCell;
@protocol QGHomevideoListCellDelegate <NSObject>

@required
- (void)QGHomevideoListCellMoreBtnClicked:(QGHomevideoListCell *)sender;

@end
@interface QGHomevideoListCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QGCollectionVideoFooterViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *dataSource1;
@property (nonatomic,strong) QGEduVideoListModel *model;
@property (nonatomic,copy) NSString *videoCircleId;
@property (nonatomic,strong) id<QGHomevideoListCellDelegate> delegate;
@end




