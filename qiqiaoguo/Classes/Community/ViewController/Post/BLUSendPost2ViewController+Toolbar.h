//
//  BLUSendPost2ViewController+Toolbar.h
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController.h"
#import "BLUSendPost2Toolbar.h"
#import "BLUImagePickerAlbumContentsViewController.h"
#import "BLUImagePickerViewController.h"

@interface BLUSendPost2ViewController (Toolbar)
<BLUSendPost2ToolBarDelegate,
BLUImagePickerAlbumContentsViewControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@end
