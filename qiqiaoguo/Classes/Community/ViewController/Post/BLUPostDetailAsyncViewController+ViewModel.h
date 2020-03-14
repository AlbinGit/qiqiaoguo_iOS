//
//  BLUPostDetailAsyncViewController+ViewModel.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostDetailAsyncViewModelDelegate.h"
#import "BLUPostDetailTakeSofaFooterViewDelegate.h"

@interface BLUPostDetailAsyncViewController (ViewModel)
<BLUPostDetailAsyncViewModelDelegate,
BLUPostDetailTakeSofaFooterViewDelegate>

@end
