//
//  QGCell.h
//  qiqiaoguo
//
//  Created by cws on 16/6/14.
//
//

#import <UIKit/UIKit.h>

@interface QGCell : UITableViewCell

@property (nonatomic, assign) CGSize cellSize;
// 设置此属性，避免在Layout的时候进行额外的计算
@property (nonatomic, assign, getter = isCellForCalcingSize) BOOL cellForCalcingSize;
@property (nonatomic, strong) id model;

+ (CGSize)sizeForLayoutedCellWith:(CGFloat)width sharedCell:(QGCell *)cell;
+ (NSString *)defaultName;
+ (instancetype)sharedCell;
+ (void)freeSharedCell;
@end
