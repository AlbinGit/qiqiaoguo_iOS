//
//  SAAlert.h
//  SaleAssistant
//
//  Created by Albin on 14-10-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SAAlertConfirmBlock)(void);
typedef void(^SAAlertCancelBlock)(void);

@interface SAAlert : NSObject<UIAlertViewDelegate>

+ (SAAlert *)sharedInstance;
- (void)showAlertWithOnlyTitle:(NSString *)title;
- (void)showAlertWithTitle:(NSString *)title;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message otherTitle:(NSString *)otherTitle;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherTitle:(NSString *)otherTitle;
- (void)confirmClick:(SAAlertConfirmBlock)confirm;
- (void)cancelClick:(SAAlertCancelBlock)cancel;


@end
