//
//  QGQGOrderBottomTool.h
//  qiqiaoguo
//
//  Created by cws on 16/7/20.
//
//

#import <UIKit/UIKit.h>
#import "QGMallOrderModel.h"
#import "QGOrderListFooter.h"

@interface QGOrderBottomTool : UIView

@property (nonatomic) UILabel *amountLabel;

@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *submitButton;

@property (nonatomic) UIButton *afterSalesButton;
@property (nonatomic) UIButton *courierButton;
@property (nonatomic) UIButton *confirmGoodsButton;

@property (nonatomic) UIButton *refundButton;

@property (nonatomic) UIView *separator;

@property (nonatomic) CGFloat contentMargin;
@property (nonatomic) CGFloat separatorHeight;

@property (nonatomic ,assign) QGOrderFooterType type;

@property (nonatomic) QGMallOrderModel *order;

@end
