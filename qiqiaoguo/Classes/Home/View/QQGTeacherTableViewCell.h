//
//  QQGTeacherTableViewCell.h
//  qiqiaoguo
//
//  Created by 李艳彬 on 2020/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQGTeacherTableViewCell : UITableViewCell

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataSource;

@end

NS_ASSUME_NONNULL_END
