//
//  BLUPostDetailAsyncViewController+PostDetailNode.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostDetailNodeDelegate.h"
#import "BLUPostDetailLikeNodeDelegate.h"
#import "BLUShowImageProtocol.h"

@interface BLUPostDetailAsyncViewController (PostDetailNode)
<BLUPostDetailNodeDelegate, BLUPostDetailLikeNodeDelegate>

@end
