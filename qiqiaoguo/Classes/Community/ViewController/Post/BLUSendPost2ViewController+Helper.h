//
//  BLUSendPost2ViewController+Helper.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController.h"
#import "BLUPostTagSelectionViewControllerDelegate.h"
#import "BLUSendPost2CircleSelectorDelegate.h"
#import "BLUCircleSearchViewControllerDelegate.h"
#import "BLUPostTagContainerDelegate.h"

@interface BLUSendPost2ViewController (Helper) <
    BLUPostTagSelectionViewControllerDelegate,
    BLUSendPost2CircleSelectorDelegate,
    BLUCircleSearchViewControllerDelegate,
    BLUPostTagContainerDelegate
>

@end
