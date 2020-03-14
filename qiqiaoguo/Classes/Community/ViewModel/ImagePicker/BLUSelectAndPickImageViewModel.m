//
//  BLUImagePickerViewModel.m
//  Blue
//
//  Created by Bowen on 18/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSelectAndPickImageViewModel.h"

@implementation BLUSelectAndPickImageViewModel

- (void)selectAndPickImage {
   
    if (_viewController == nil && _sourceView) {
        return ;
    }
    
    if (objc_getClass("UIAlertController") != nil) {
        //make and use a UIAlertController
        UIAlertController *alertController = [UIAlertController new];
        alertController.title = nil;
        
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.take-photo", @"Take photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [_viewController presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.get-from-photo-library", @"Get from photo library") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [_viewController presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:takePhotoAction];
        [alertController addAction:photoLibraryAction];
        [alertController addAction:cancelAction];

        alertController.popoverPresentationController.sourceRect = self.sourceRect;
        alertController.popoverPresentationController.sourceView = self.sourceView;
        [_viewController presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"select-and-pick-image-view-model.cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"select-and-pick-image-view-model.take-photo", @"Take photo"), NSLocalizedString(@"select-and-pick-image-view-model.get-from-photo-library", @"Get from photo library"), nil];
        actionSheet.delegate = self;
        [actionSheet showInView:_viewController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 1) return ;
    if (_viewController == nil) {
        return ;
    }
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    if (buttonIndex == 0) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePickerController.delegate = self;
    [_viewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * originalHeaderImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData * compressedHeaderImageData = UIImageJPEGRepresentation(originalHeaderImage, 0.3);
    UIImage * compressedImage = [UIImage imageWithData:compressedHeaderImageData];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.pickedImage = compressedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
