//
//  QGTableView.h
//  qiqiaoguo
//
//  Created by cws on 16/6/14.
//
//

#import <UIKit/UIKit.h>
#import "QGCell.h"

@interface QGTableView : UITableView

// 返回cell的Size，必须是QGcell的子类
- (CGSize)sizeForCellWithCellClass:(Class)cellClass cacheByIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width configuration:(void (^)(QGCell *cell))configuration;

- (CGSize)sizeForCellWithCellClass:(Class)cellClass cacheByIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width model:(id)model;

- (void)clearCache;
@end
