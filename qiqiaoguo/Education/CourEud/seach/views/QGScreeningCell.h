//
//  QGScreeningCell.h
//  qiqiaoguo
//
//  Created by cws on 16/9/12.
//
//

#import "QGCell.h"
#import "QGSearchScreeningModel.h"

typedef void(^buttonBlock)(QGScreeningModel *model);

@interface QGScreeningCell : QGCell

@property (nonatomic, strong) QGScreeningModel *ScreeningModel;
@property (nonatomic, copy) buttonBlock btnBlock;
@property (nonatomic, assign) NSInteger selectID;

@end
