//
//  BLUImagePickerViewModel.h
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@class BLUImagePickerViewModel;

@protocol BLUImagePickerViewModelDelegate  <NSObject>

@required

- (void)imagePickerViewModel:(BLUImagePickerViewModel *)imagePickerViewModel AccessAssetsFailureWithErrorMessage:(NSString *)errorMessage;

- (void)imagePickerViewModelAccessAssetsSuccess:(BLUImagePickerViewModel *)imagePickerViewModel;

@end

@interface BLUImagePickerViewModel : BLUViewModel

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, weak) id <BLUImagePickerViewModelDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *assetPickers;
@property (nonatomic, assign) NSInteger maxImageCount;

@end