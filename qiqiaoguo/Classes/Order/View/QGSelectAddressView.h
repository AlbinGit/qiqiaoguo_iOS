//
//  QGSelectAddressView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import <UIKit/UIKit.h>
#import "QGAddressModel.h"

typedef NS_ENUM(NSUInteger, QGConfirmOrderType) {
    QGConfirmOrderTypeOrdinary, // 普通商品
    QGConfirmOrderTypeGlobal,// 全球购商品
    QGConfirmOrderTypeSecondkilling,// 秒杀商品
    QGConfirmOrderTypeBuyNow,// 立即购买的商品
    QGConfirmOrderTypeGlobalAndBuyNow,// 即是立即购买也是全球购的商品
};

@interface QGSelectAddressView : UIView

@property (nonatomic, strong)UITextField *idCardTextField;
@property (nonatomic, strong)UIButton *idCardTextButton;
@property (nonatomic, assign)CGFloat headHeight;
@property (nonatomic, assign) QGConfirmOrderType type;
@property (nonatomic, strong) UIButton *SelectAddressButton;
@property (nonatomic, strong)QGAddressModel *address;

@end
