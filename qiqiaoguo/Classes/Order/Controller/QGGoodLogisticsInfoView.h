//
//  QGGoodLogisticsInfoView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import <UIKit/UIKit.h>
@class BLULogistics;
@interface QGGoodLogisticsInfoView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) CALayer *separator;

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat elementSpacing;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat separatorHeight;

@property (nonatomic, strong) BLULogistics *logistics;

+ (CGFloat)requiredHeight;
@end
