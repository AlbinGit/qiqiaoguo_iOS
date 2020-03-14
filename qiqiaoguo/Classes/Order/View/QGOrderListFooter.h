//
//  QGOrderListFooter.h
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import <UIKit/UIKit.h>
#import "QGMallOrderModel.h"

typedef NS_ENUM(NSUInteger, QGOrderFooterType) {
    QGOrderFooterTypeMall,
    QGOrderFooterTypeActiv,
};

@interface QGOrderListFooter : UITableViewHeaderFooterView

@property (nonatomic) UILabel *amountLabel;

@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *submitButton;
@property (nonatomic) UIView *separator;

@property (nonatomic) CGFloat contentMargin;
@property (nonatomic) CGFloat separatorHeight;

@property (nonatomic ,assign) QGOrderFooterType type;

@property (nonatomic) QGMallOrderModel *order;

+ (CGFloat)userOrderFooterHeight;

@end
