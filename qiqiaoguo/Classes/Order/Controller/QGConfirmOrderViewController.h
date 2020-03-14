//
//  QGConfirmOrderViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/25.
//
//

#import "QGViewController.h"
#import "QGTableView.h"
#import "QGSelectAddressView.h"

//typedef NS_ENUM(NSUInteger, QGConfirmOrderType) {
//    QGConfirmOrderTypeOrdinary, // 普通商品
//    QGConfirmOrderTypeGlobal,// 全球购商品
//};

@interface QGConfirmOrderViewController : QGViewController

@property (nonatomic, strong)  UIToolbar *toolbar;
@property (strong, nonatomic)  QGTableView *tableView;

@property (nonatomic) UILabel *amountLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UIButton *submitButton;
@property (nonatomic, assign)QGConfirmOrderType type;
@property (nonatomic, copy)NSString *codeStr;

//- (instancetype)initWithType:(QGConfirmOrderType)type;

@end
