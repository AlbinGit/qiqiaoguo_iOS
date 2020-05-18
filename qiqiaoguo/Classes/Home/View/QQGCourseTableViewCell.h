//
//  QQGCourseTableViewCell.h
//  qiqiaoguo
//
//  Created by 李艳彬 on 2020/5/17.
//

#import <UIKit/UIKit.h>
#import "QGCollectionVideoFooterView.h"
@class QQGCourseTableViewCell;
@protocol QQGCourseTableViewCellDelegate <NSObject>

@required
- (void)QQGCourseTableViewCellMoreBtnClicked:(QQGCourseTableViewCell *)sender;

- (void)QQGCourseTableViewCellFoldBtnClicked:(QQGCourseTableViewCell *)sender;

@end

@interface QQGCourseTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QGCollectionVideoFooterViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,copy) NSString *videoCircleId;
@property (nonatomic,strong) id<QQGCourseTableViewCellDelegate> delegate;

@end
