//
//  QGSearchPromptHeader.h
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import <UIKit/UIKit.h>

@interface QGSearchPromptHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CALayer *separator;
@property (nonatomic, assign) UIEdgeInsets titleInsets;

+ (CGFloat)headerHeight;


@end
