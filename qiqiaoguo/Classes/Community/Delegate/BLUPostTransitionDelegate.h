//
//  BLUPostTransitionDelegate.h
//  Blue
//
//  Created by Bowen on 29/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUPostTransitionProtocal.h"

@interface BLUPostTransitionDelegate : NSObject <BLUPostTransitionDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@end
