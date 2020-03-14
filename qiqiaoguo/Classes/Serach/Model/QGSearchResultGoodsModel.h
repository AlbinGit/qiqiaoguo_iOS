//
//  QGSearchResultGoodsModel.h
//  qiqiaoguo
//
//  Created by cws on 16/7/10.
//
//

#import "QGModel.h"

@interface QGSearchResultGoodsModel : QGModel

@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *goodsImageStr;
@property (nonatomic, assign) NSInteger goodsID;
@property (nonatomic, assign) CGFloat salesPrice;
@property (nonatomic, assign) NSInteger salesVolume;
@property (nonatomic, assign) NSInteger deliveryType;

@end
