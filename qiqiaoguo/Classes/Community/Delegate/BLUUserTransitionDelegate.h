//
//  BLUUserTransitionDelegate.h
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUUserTransitionProtocal.h"

@interface BLUUserTransitionDelegate : NSObject <BLUUserTransitionDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@end
