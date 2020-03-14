//
//  QGActivOrderCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/19.
//
//

#import "QGCell.h"
#import "QGMallGoodsModell.h"

typedef NS_ENUM(NSUInteger, QGActivCellStatus) {
    QGActivCellStatusList,
    QGActivCellStatusDetail,
};

@interface QGActivOrderCell : QGCell

@property (nonatomic, strong) QGMallGoodsModell* order;
@property (nonatomic, assign) QGActivCellStatus status;
@property (nonatomic, assign) NSInteger orderType;
@end
