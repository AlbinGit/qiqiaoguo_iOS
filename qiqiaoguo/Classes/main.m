//
//  main.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
#ifdef QGDEBUG
        int ret = 0;
        @try {
            ret = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        } @catch (NSException *ex) {
            NSLog(@"ex = %@", ex);
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#else
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#endif

    }
}
