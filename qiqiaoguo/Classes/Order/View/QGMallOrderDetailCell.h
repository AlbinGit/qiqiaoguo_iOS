//
//  QGMallOrderDetailCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/20.
//
//

#import "QGCell.h"
#import "QGMallGoodsModell.h"
#import "QGMallOrderModel.h"

@interface QGMallOrderDetailCell : QGCell

@property (nonatomic, strong) QGMallGoodsModell* order;
@property (nonatomic, assign) QGMallOrderStatus orderStatus;
@property (nonatomic, assign) NSInteger orderType;

@end
