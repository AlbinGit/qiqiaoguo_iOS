////
////  UIStoryboard+ViewController.m
////  Blue
////
////  Created by Bowen on 28/3/2016.
////  Copyright © 2016 com.boki. All rights reserved.
////
//
//#import "UIStoryboard+ViewController.h"
//#import "BLUShoppingCartViewController.h"
//#import "BLUConfirmOrderViewController.h"
//#import "BLUSubmitOrderViewController.h"
//#import "BLUOrderDetailsViewController.h"
//#import "BLUPaymentResultsViewController.h"
//#import "BLUUserOrdersViewController.h"
//#import "BLULogisticsEditViewController.h"
//
//#define BLUToyStoryboardName @"toy"
//#define BLUGoodExchangeStoryboardName @"GoodExchange"
//
//@implementation UIStoryboard (ViewController)
//
//+ (BLUShoppingCartViewController *)shoppingCartViewController {
//    return
//    (BLUShoppingCartViewController *)
//    [UIStoryboard toyViewControllerWithClass:
//     [BLUShoppingCartViewController class]];
//}
//
//+ (BLUConfirmOrderViewController *)confirmOrderViewController {
//    return
//    (BLUConfirmOrderViewController *)
//    [UIStoryboard toyViewControllerWithClass:
//     [BLUConfirmOrderViewController class]];
//}
//
//+ (BLUSubmitOrderViewController *)submitOrderViewController {
//    return
//    (BLUSubmitOrderViewController *)
//    [UIStoryboard toyViewControllerWithClass:
//     [BLUSubmitOrderViewController class]];
//}
//
//+ (BLUOrderDetailsViewController *)orderDetailsViewController {
//    return
//    (BLUOrderDetailsViewController *)
//    [UIStoryboard toyViewControllerWithClass:
//     [BLUOrderDetailsViewController class]];
//}
//
//+ (BLUUserOrdersViewController *)userOrdersViewController {
//    return
//    (BLUUserOrdersViewController *)
//    [UIStoryboard toyViewControllerWithClass:
//     [BLUUserOrdersViewController class]];
//}
//
//+ (BLUPaymentResultsViewController *)paymentResultsViewController {
//    return
//    (BLUPaymentResultsViewController *)
//    [UIStoryboard toyViewControllerWithClass:
//     [BLUPaymentResultsViewController class]];
//}
//
//+ (UIViewController *)viewControllerWithStoryboardName:(NSString *)name bundle:(NSBundle *)bundle viewControllerIdentifier:(NSString *)identifier {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:name
//                                                 bundle:bundle];
//
//    BLUConfirmOrderViewController *vc =
//    [sb instantiateViewControllerWithIdentifier:identifier];
//
//    return vc;
//}
//
//+ (UIViewController *)toyViewControllerWithClass:(Class)cls {
//    return [UIStoryboard viewControllerWithStoryboardName:BLUToyStoryboardName
//                                            bundle:[NSBundle mainBundle]
//                          viewControllerIdentifier:NSStringFromClass(cls)];
//}
//
//+ (BLULogisticsEditViewController *)logisticsEditViewController {
//    return
//    (BLULogisticsEditViewController *)
//    [UIStoryboard goodExchangeViewControllerWithClass:
//            [BLULogisticsEditViewController class]];
//}
//
//+ (UIViewController *)goodExchangeViewControllerWithClass:(Class)cls {
//    return [UIStoryboard viewControllerWithStoryboardName:BLUGoodExchangeStoryboardName
//                                                   bundle:[NSBundle mainBundle]
//                                 viewControllerIdentifier:NSStringFromClass(cls)];
//}
//
//@end
