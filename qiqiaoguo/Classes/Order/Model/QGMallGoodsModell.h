//
//  QGMallGoodsModell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import "QGModel.h"

@interface QGMallGoodsModell : QGModel

@property (nonatomic, assign) NSInteger goodsID;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) CGFloat goodsPrice;
@property (nonatomic, assign) NSInteger Quantity;
@property (nonatomic, copy)   NSString *imageStr;
@property (nonatomic, copy)   NSString *sizeStr;

@end
