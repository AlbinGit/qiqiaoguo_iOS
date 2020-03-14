//
//  QGGoodLogisticsHeaderview.h
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import <UIKit/UIKit.h>

@interface QGGoodLogisticsHeaderview : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) CALayer *separator;

+ (CGFloat)requiredHeight;

@end
