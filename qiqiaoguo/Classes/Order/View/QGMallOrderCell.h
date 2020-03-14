//
//  QGMallOrderCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGCell.h"
#import "QGMallGoodsModell.h"

@interface QGMallOrderCell : QGCell

@property (nonatomic, strong) QGMallGoodsModell* order;
@property (nonatomic, assign) NSInteger orderType;


@end
