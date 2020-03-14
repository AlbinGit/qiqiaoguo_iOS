//
//  BLUCell.h
//  Blue
//
//  Created by Bowen on 30/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUCell : UITableViewCell

@property (nonatomic, assign) CGSize cellSize;
// 设置此属性，避免在Layout的时候进行额外的计算
@property (nonatomic, assign, getter = isCellForCalcingSize) BOOL cellForCalcingSize;
@property (nonatomic, strong) id model;

+ (CGSize)sizeForLayoutedCellWith:(CGFloat)width sharedCell:(BLUCell *)cell;
+ (NSString *)defaultName;

@end

@interface BLUCell (SharedCell)

+ (instancetype)sharedCell;
+ (void)freeSharedCell;

@end
