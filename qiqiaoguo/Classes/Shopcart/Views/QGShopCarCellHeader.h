//
//  QGShopCarCellHeader.h
//  qiqiaoguo
//
//  Created by cws on 16/7/23.
//
//

#import <UIKit/UIKit.h>
#import "QGGoodsMO.h"

@interface QGShopCarCellHeader : UITableViewHeaderFooterView
@property (nonatomic) UILabel *orderIDLabel;
@property (nonatomic) UILabel *stateLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic ,strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIButton *Clickbutton;

@property (nonatomic) CGFloat contentMargin;
@property (nonatomic) QGGoodsMO *goods;
@property (nonatomic) NSArray *goodsArray;

+ (CGFloat)userOrderHeaderHeight;
@end
