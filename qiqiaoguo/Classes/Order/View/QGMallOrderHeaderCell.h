//
//  QGMallOrderHeaderCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGCell.h"
#import "QGMallOrderModel.h"

@interface QGMallOrderHeaderCell : QGCell

@property (nonatomic, strong)QGMallOrderModel *order;

@property (nonatomic, strong)UIButton *logisticsButton;
@property (nonatomic, strong) UIButton *StoreButton;

@end
