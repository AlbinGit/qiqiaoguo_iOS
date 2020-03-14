//
//  QGShopCarCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import "QGCell.h"
#import "QGGoodsMO.h"

@protocol QGShopCarCellDeletage <NSObject>

- (void)selectButtonClick:(UIButton *)button;
- (void)increaseButtonClick:(UIButton *)button;
- (void)ReductionButtonClick:(UIButton *)button;

@end

@interface QGShopCarCell : QGCell
@property (nonatomic, strong) QGGoodsMO *goods;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, weak) id<QGShopCarCellDeletage> delegate;
@end
