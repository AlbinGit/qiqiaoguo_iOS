//
//  QGPersonalOrderCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/11.
//
//

#import "QGCell.h"

@protocol OrderCellDalegate <NSObject>
@optional

- (void)shouldPushOrderVC:(UIButton *)button;

@end

@interface QGPersonalOrderCell : QGCell

@property (nonatomic ,weak) id<OrderCellDalegate> delegate;

@end
