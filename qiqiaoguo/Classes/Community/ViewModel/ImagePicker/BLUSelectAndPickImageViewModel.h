//
//  BLUImagePickerViewModel.h
//  Blue
//
//  Created by Bowen on 18/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_OPTIONS(NSUInteger, BLUSelectAndPickImageOptions) {
    BLUSelectAndPickImageOptionTakePhotoForAvatar        = 1 << 0,
    BLUSelectAndPickImageOptionGetFromLibraryForAvatar   = 1 << 1,
    BLUSelectAndPickImageOptionsGetMultiFromLibrary      = 1 << 2,
} NS_ENUM_AVAILABLE_IOS(4_0);

@interface BLUSelectAndPickImageViewModel : BLUViewModel <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;

- (void)selectAndPickImage;

@end
