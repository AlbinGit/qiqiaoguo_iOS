//
//  UITableView+BLUAddition.m
//  Blue
//
//  Created by Bowen on 22/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UITableView+BLUAddition.h"

@implementation UITableView (BLUAddition)

#pragma mark - Dequeue cell

- (BLUCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(BLUCell *cell))configuration {
    BLUCell *cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (configuration) {
        configuration(cell);
    }
    return cell;
}

- (BLUCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath model:(id)model {
    return [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath configuration:^(BLUCell *cell) {
        cell.model = model;
    }];
}

@end
