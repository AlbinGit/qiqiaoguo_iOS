//
//  BLUSendPost2ViewControllerDelegate.h
//  Blue
//
//  Created by Bowen on 11/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUSendPost2ViewController;

@protocol BLUSendPost2ViewControllerDelegate <NSObject>

- (void)sendPostViewControllerDidSendPost:(BLUSendPost2ViewController *)viewController;

@end
