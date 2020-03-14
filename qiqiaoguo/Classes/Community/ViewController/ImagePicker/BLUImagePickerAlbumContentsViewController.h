//
//  BLUImagePickerAlbumContentsViewController.h
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@class ALAssetsGroup, BLUImagePickerAlbumContentsViewController;

@protocol  BLUImagePickerAlbumContentsViewControllerDelegate <NSObject>

@optional
- (void)albumContentsViewController:(BLUImagePickerAlbumContentsViewController *)viewController didSelectImageDictionary:(NSDictionary *)imageDictionary inAssetsGroup:(ALAssetsGroup *)assetsGroup;

- (void)albumContentsViewController:(BLUImagePickerAlbumContentsViewController *)viewController didFinishSelectingImages:(NSArray *)images;

@end

@interface BLUImagePickerAlbumContentsViewController : BLUViewController

// NOTE: 使用这个进行初始化
- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup assetPickers:(NSMutableArray *)assetPickers maxImageCount:(NSInteger)count;

@property (nonatomic, weak) id <BLUImagePickerAlbumContentsViewControllerDelegate> delegate;

@end
