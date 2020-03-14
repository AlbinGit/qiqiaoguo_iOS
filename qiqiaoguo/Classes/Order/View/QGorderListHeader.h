//
//  QGorderListHeader.h
//  qiqiaoguo
//
//  Created by cws on 16/7/18.
//
//

#import <UIKit/UIKit.h>
#import "QGMallOrderModel.h"

@interface QGorderListHeader : UITableViewHeaderFooterView

@property (nonatomic) UILabel *orderIDLabel;
@property (nonatomic) UILabel *stateLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic ,strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIButton *Clickbutton;

@property (nonatomic) CGFloat contentMargin;
@property (nonatomic) QGMallOrderModel *order;

+ (CGFloat)userOrderHeaderHeight;

@end
