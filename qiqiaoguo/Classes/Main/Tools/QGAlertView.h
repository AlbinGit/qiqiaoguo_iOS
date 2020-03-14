//
//  QGAlertView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^QGAlertViewBlock)(void);

@interface QGAlertView : UIView

@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * otherButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;

@property (readwrite, copy) QGAlertViewBlock cancelButtonAction;
@property (readwrite, copy) QGAlertViewBlock otherButtonAction;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

- (void)show;

//- (void)dismiss;

@end
