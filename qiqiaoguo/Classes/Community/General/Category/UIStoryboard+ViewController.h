//
//  UIStoryboard+ViewController.h
//  Blue
//
//  Created by Bowen on 28/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUShoppingCartViewController;
@class BLUConfirmOrderViewController;
@class BLUSubmitOrderViewController;
@class BLUOrderDetailsViewController;
@class BLUPaymentResultsViewController;
@class BLUUserOrdersViewController;
@class BLULogisticsEditViewController;

@interface UIStoryboard (ViewController)

+ (BLUShoppingCartViewController *)shoppingCartViewController;
+ (BLUConfirmOrderViewController *)confirmOrderViewController;
+ (BLUSubmitOrderViewController *)submitOrderViewController;
+ (BLUOrderDetailsViewController *)orderDetailsViewController;
+ (BLUPaymentResultsViewController *)paymentResultsViewController;
+ (BLUUserOrdersViewController *)userOrdersViewController;
+ (BLULogisticsEditViewController *)logisticsEditViewController;

@end
