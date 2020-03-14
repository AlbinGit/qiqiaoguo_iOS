//
//  BLUPostDetailAsyncViewController+Toolbar.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostDetailToolbarDelegate.h"
#import "BLUShareManagerDelegate.h"
#import "BLUPostDetailOptionsViewControllerDelegate.h"

@interface BLUPostDetailAsyncViewController (Toolbar)
<BLUPostDetailToolbarDelegate,
BLUShareManagerDelegate,
BLUPostDetailOptionsViewControllerDelegate>

@end
