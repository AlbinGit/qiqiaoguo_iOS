//
//  BLUNavigationController.m
//  Blue
//
//  Created by Bowen on 30/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUNavigationController.h"

@interface BLUNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BLUNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    __weak BLUNavigationController *weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = weakSelf;
//        self.delegate = weakSelf;
//    }
//
//    self.view.backgroundColor = BLUThemeMainColor;
}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = NO;
//    [super pushViewController:viewController animated:animated];
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.navigationController.viewControllers.count == 1) {
//        return NO;
//    } else {
//        return YES;
//    }
//}
//
//#pragma mark UINavigationControllerDelegate
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = YES;
//}
@end
