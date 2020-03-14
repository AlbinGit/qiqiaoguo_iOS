//
//  BLUTableView.h
//  Blue
//
//  Created by Bowen on 30/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUCell.h"

@interface BLUTableView : UITableView

// 必需BLUCell的子类

// Calc cell size
- (CGSize)sizeForCellWithCellClass:(Class)cellClass cacheByIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width configuration:(void (^)(BLUCell *cell))configuration;

- (CGSize)sizeForCellWithCellClass:(Class)cellClass cacheByIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width model:(id)model;

- (void)clearCache;

@end
