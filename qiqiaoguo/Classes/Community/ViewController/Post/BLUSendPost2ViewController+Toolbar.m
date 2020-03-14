//
//  BLUSendPost2ViewController+Toolbar.m
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController+Toolbar.h"
#import "BLUSendPost2ViewController+Text.h"
#import "BLUPostTagSelectionViewController.h"
#import "BLUSendPost2ViewController+Helper.h"
#import "BLUSendPost2ViewModel.h"

static const NSInteger kMaxImageCount = 6;

@implementation BLUSendPost2ViewController (Toolbar)

- (void)toolbarShouldSelectImage:(BLUSendPost2Toolbar *)toolbar sender:(id)sender{
    if (self.reminingImagesCount <= 0) {
        return;
    }
    if (objc_getClass("UIAlertController") != nil) {
        //make and use a UIAlertController
        UIAlertController *alertController = [UIAlertController new];
        alertController.title = nil;

        UIImagePickerController * imagePickerController =
        [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;

        UIAlertAction *takePhotoAction =
        [UIAlertAction
         actionWithTitle:
         NSLocalizedString(@"select-and-pick-image-view-model.take-photo", @"Take photo")
         style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];

        UIAlertAction *photoLibraryAction =
        [UIAlertAction
         actionWithTitle:
         NSLocalizedString(@"select-and-pick-image-view-model.get-from-photo-library", @"Get from photo library")
         style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            imagePickerController.sourceType =
             UIImagePickerControllerSourceTypePhotoLibrary;
            BLUImagePickerViewController *imagePickerViewController =
             [[BLUImagePickerViewController alloc]
              initWithMaxImageCount:self.reminingImagesCount > kMaxImageCount ?
              kMaxImageCount : self.reminingImagesCount];
            imagePickerViewController.albumContentsViewControllerDelegate = self;
            BLUNavigationController *imagePickerNavVC =
             [[BLUNavigationController alloc]
              initWithRootViewController:imagePickerViewController];
            [self presentViewController:imagePickerNavVC animated:YES completion:^{
                BLULogDebug(@"Image picker view controller presented");
            }];
        }];

        UIAlertAction *cancelAction =
        [UIAlertAction
         actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.cancel", @"Cancel")
         style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:takePhotoAction];
        [alertController addAction:photoLibraryAction];
        [alertController addAction:cancelAction];
        alertController.popoverPresentationController.sourceView = (UIButton *)sender;
        alertController.popoverPresentationController.sourceRect = ((UIButton *)sender).bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)toolbarShouldSelectTag:(BLUSendPost2Toolbar *)toolbar sender:(id)sender {
    BLUPostTagSelectionViewController *vc =
    [[BLUPostTagSelectionViewController alloc]
     initWithTags:self.tagContainer.allTags];
    vc.delegate = self;
    [self pushViewController:vc];
}

- (void)toolbarDidSetAnonymous:(BOOL)anonymous
                       toolbar:(BLUSendPost2Toolbar *)toolbar
                        sender:(id)sender {
    self.viewModel.anonymous = anonymous;
}

- (void)toolbarShouldHideKeyboard:(BLUSendPost2Toolbar *)toolbar
                           sender:(id)sender {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

#pragma mark - BLUImagePickerAlbumContentsViewController.

- (void)albumContentsViewController:(BLUImagePickerAlbumContentsViewController *)viewController
           didFinishSelectingImages:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(UIImage *image,
                                         NSUInteger idx,
                                         BOOL * _Nonnull stop) {
        [self insertImageToContentTextView:image];
    }];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    dispatch_async_default_global_queue(^{
        UIImage * originalHeaderImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData * compressedHeaderImageData = UIImageJPEGRepresentation(originalHeaderImage, 0.9);
        UIImage * compressedImage = [UIImage imageWithData:compressedHeaderImageData];
        // FIXME: 这里图片会发生旋转，原因不明
        dispatch_async_main_queue(^{
            [self insertImageToContentTextView:compressedImage];
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
