//
//  QGCollectionViewClassCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/8.
//

#import <UIKit/UIKit.h>
@class QGClassListModel;
NS_ASSUME_NONNULL_BEGIN

@interface QGCollectionViewClassCell : UICollectionViewCell
@property (nonatomic,strong) QGClassListModel *model;

@end

NS_ASSUME_NONNULL_END
