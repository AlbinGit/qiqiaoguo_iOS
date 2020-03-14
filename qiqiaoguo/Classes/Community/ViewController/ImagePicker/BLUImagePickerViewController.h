//
//  BLUImagePickerViewController.h
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@protocol BLUImagePickerAlbumContentsViewControllerDelegate;

@interface BLUImagePickerViewController : BLUViewController

@property (nonatomic, weak) id <BLUImagePickerAlbumContentsViewControllerDelegate> albumContentsViewControllerDelegate;
@property (nonatomic, assign, readonly) NSInteger maxImageCount;

- (instancetype)initWithMaxImageCount:(NSInteger)count;

@end
