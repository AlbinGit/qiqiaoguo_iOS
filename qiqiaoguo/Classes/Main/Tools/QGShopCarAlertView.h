//
//  QGShopCarAlertView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import <UIKit/UIKit.h>
#import "QGAlertView.h"

typedef void (^QGGoodsAlertViewBlock)(int index);

@interface QGShopCarAlertView : UIView

@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * otherButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;

@property (readwrite, copy) QGGoodsAlertViewBlock cancelButtonAction;
@property (readwrite, copy) QGAlertViewBlock otherButtonAction;

- (instancetype)initWithTitle:(NSString *)title ordinaryCount:(NSInteger)ordinarycount GlobalCount:(NSInteger)Globalcount cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (void)show;

//- (void)dismiss;

@end
