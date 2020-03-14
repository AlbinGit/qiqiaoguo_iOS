//
//  BLUShowImageDelegate.m
//  Blue
//
//  Created by Bowen on 18/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUShowImageController.h"
#import "BLUOneImageViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface BLUShowImageController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *backgroundView;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIImage *image;

@end

@implementation BLUShowImageController

- (void)showImage:(UIImage *)image fromSender:(id)sender {
    if (self.fromViewController && image && sender) {
        self.imageView = nil;
        self.backgroundView = nil;
        self.downloadButton = nil;
        self.image = image;
        UIView *view = (UIView *)sender;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.backgroundView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.oldFrame = [view convertRect:view.bounds toView:window];
        self.backgroundView.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
        self.backgroundView.alpha = 0;
        self.imageView = [[UIImageView alloc] initWithFrame:self.oldFrame];
        self.imageView.image = image;
        [self.backgroundView addSubview:self.imageView];
        self.backgroundView.contentSize = self.imageView.size;
        self.backgroundView.minimumZoomScale = 1.0;
        self.backgroundView.maximumZoomScale = 3.0;
        self.backgroundView.delegate = self;

        self.downloadButton = [UIButton new];
        self.downloadButton.image = [UIImage imageNamed:@"common-download-image"];
        self.downloadButton.backgroundColor = [UIColor colorFromHexString:@"000000" alpha:0.8];
        self.downloadButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin * 2, BLUThemeMargin * 4, BLUThemeMargin * 2, BLUThemeMargin * 4);
        self.downloadButton.cornerRadius = BLUThemeNormalActivityCornerRadius;
        [self.downloadButton addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.downloadButton sizeToFit];
        self.downloadButton.x = self.backgroundView.width - self.downloadButton.width - BLUThemeMargin * 6;
        self.downloadButton.y = self.backgroundView.height - self.downloadButton.height - BLUThemeMargin * 6;
        self.downloadButton.alpha = 0;

        [window addSubview:self.backgroundView];
        [window addSubview:self.downloadButton];
        window.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];

        [self.backgroundView addGestureRecognizer:tapBackground];


        [UIView animateWithDuration:0.2
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.downloadButton.alpha = 1.0;

                             self.backgroundView.alpha = 1;

                             CGFloat resizeRatio;
                             CGSize imageSize = self.imageView.image.size;

                             if (imageSize.width > MAIN_SCREEN_WIDTH || imageSize.height > MAIN_SCREEN_HEIGHT) {
                                 if (imageSize.width > MAIN_SCREEN_WIDTH && imageSize.height > MAIN_SCREEN_HEIGHT) {
                                     if (imageSize.width > imageSize.height) {
                                         resizeRatio = MAIN_SCREEN_WIDTH / imageSize.width;
                                     } else {
                                         resizeRatio = MAIN_SCREEN_HEIGHT / imageSize.height;
                                     }
                                 } else if (imageSize.width > MAIN_SCREEN_WIDTH) {
                                     resizeRatio = MAIN_SCREEN_WIDTH / imageSize.width;
                                 } else if (imageSize.height > MAIN_SCREEN_HEIGHT) {
                                     resizeRatio = MAIN_SCREEN_HEIGHT / imageSize.height;
                                 }
                             } else {
                                 if (imageSize.width > imageSize.height) {
                                     resizeRatio = imageSize.width / MAIN_SCREEN_WIDTH;
                                 } else {
                                     resizeRatio = imageSize.height / MAIN_SCREEN_HEIGHT;
                                 }
                             }

                             self.imageView.width = resizeRatio * imageSize.width;
                             self.imageView.height = resizeRatio * imageSize.height;
                             self.imageView.x = 0;
                             self.imageView.y = 0;
                             
                             CGFloat top = self.backgroundView.height / 2.0 - self.imageView.height / 2.0;
                             top = top > 0 ? top : 0;
                             CGFloat left = self.backgroundView.width / 2.0 - self.imageView.width / 2.0;
                             left = left > 0 ? left : 0;
                             self.backgroundView.contentInset = UIEdgeInsetsMake(top, left, 0, 0);
                             self.backgroundView.contentSize = self.imageView.size;
                         } completion:^(BOOL finished) {
                         }];
    }
}

- (void)hideImage:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 0.0;
        self.backgroundView.contentInset = UIEdgeInsetsZero;
        self.imageView.alpha = 0.0;
        self.imageView.frame = self.oldFrame;
        self.downloadButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.downloadButton removeFromSuperview];
        [self.imageView removeFromSuperview];
        self.backgroundView = nil;
        self.downloadButton = nil;
        self.imageView = nil;
    }];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat top = self.backgroundView.height / 2.0 - self.imageView.height / 2.0;
    top = top > 0 ? top : 0;
    CGFloat left = self.backgroundView.width / 2.0 - self.imageView.width / 2.0;
    left = left > 0 ? left : 0;
    scrollView.contentInset = UIEdgeInsetsMake(top, left, 0, 0);

    BLULogDebug(@"contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
    BLULogDebug(@"contentInset = %@", NSStringFromUIEdgeInsets(scrollView.contentInset));
    BLULogDebug(@"contentSize = %@", NSStringFromCGSize(scrollView.contentSize));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)saveImage:(id)sender {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library saveImage:self.image toAlbum:@"Blue" completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [self.fromViewController showTopIndicatorWithSuccessMessage:NSLocalizedString(@"show-image-delegate.save-image-success", "Saved")];
            [self hideImage:nil];
        } else {
            [self.fromViewController showTopIndicatorWithError:error];
        }
    } failure:^(NSError *error) {
        [self.fromViewController showTopIndicatorWithError:error];
    }];
}

@end
