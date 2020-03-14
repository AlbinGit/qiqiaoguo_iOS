//
//  BLUPostDetailAsyncViewController+Reply.h
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUContentReplyViewDelegate.h"

@interface BLUPostDetailAsyncViewController (Reply)
<BLUContentReplyViewDelegate>

- (void)keyboardChanged:(NSNotification *)notification;

@end
