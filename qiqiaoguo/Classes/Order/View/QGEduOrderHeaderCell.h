//
//  QGActivOrderHeaderCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGCell.h"
#import "QGMallOrderModel.h"

@interface QGEduOrderHeaderCell : QGCell

@property (nonatomic, strong)QGMallOrderModel *order;

@property (nonatomic, strong)UIButton *logisticsButton;

@end
