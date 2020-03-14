//
//  QGViewController+QGReturnToTheTop.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/23.
//
//

#import "QGViewController.h"

#import <UIKit/UIKit.h>



typedef void(^QGReturnToTheTopBlock)();

@interface QGViewController (QGReturnToTheTop)

@property (nonatomic, strong) UIButton *returnTopButton;
@property (nonatomic, copy) QGReturnToTheTopBlock returnToTheTopBlock;

- (void)addReturnToTheTopButtonFrame:(CGRect)buttonCGRect WithBackgroundImage:(UIImage *)image CallBackblock:(void(^)())Callblock;

@end