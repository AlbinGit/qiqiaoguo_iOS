//
//  BLUViewControllerRedirectController.h
//  Blue
//
//  Created by Bowen on 30/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUViewControllerRedirectDelegate.h"

@interface BLUViewControllerRedirectController : NSObject <BLUViewControllerRedirectDelegate>

@property (nonatomic, weak) BLUViewController *fromViewController;

@end
