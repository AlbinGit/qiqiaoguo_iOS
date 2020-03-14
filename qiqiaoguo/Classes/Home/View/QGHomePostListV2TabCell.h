//
//  QGHomePostListV2TabCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/8.
//
//

#import <UIKit/UIKit.h>
#import "QGCollectionFooterLineView.h"


@class QGHomePostListV2TabCell;

@protocol QGHomePostListV2TabCellDelegate <NSObject>

@required
- (void)QGHomePostListV2TabCellMoreBtnClicked:(QGHomePostListV2TabCell *)sender;

@end


@interface QGHomePostListV2TabCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QGCollectionFooterLineViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *postList;
@property (nonatomic,strong) id<QGHomePostListV2TabCellDelegate> delegate;
@property (nonatomic,copy) NSString *videoCircleId;
@end
