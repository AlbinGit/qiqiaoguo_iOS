//
//  UITableView+BLUAddition.h
//  Blue
//
//  Created by Bowen on 22/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUCell;

@interface UITableView (BLUAddition)

// Config cell
- (BLUCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(BLUCell *cell))configuration;

- (BLUCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath model:(id)model;

@end
