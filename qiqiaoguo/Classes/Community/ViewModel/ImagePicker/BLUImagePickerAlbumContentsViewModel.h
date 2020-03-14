//
//  BLUImagePickerAlbumContentsViewModel.h
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@class ALAssetsGroup;

@interface BLUImagePickerAlbumContentsViewModel : BLUViewModel

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSString *assetsGroupName;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSArray *reverseAssets;
@property (nonatomic, strong) NSMutableArray *assetPickers;
@property (nonatomic, assign) BOOL shouldSelect;
@property (nonatomic, assign) NSInteger maxImageCount;

@property (nonatomic, strong) NSString *prompt;

- (instancetype)initWithAlAssetsGroup:(ALAssetsGroup *)assetsGroup assetPickers:(NSMutableArray *)assetPickers maxImageCount:(NSInteger)count;

- (RACCommand *)finishSelection;
- (RACCommand *)previewSelction;

- (void)selectAtIndexPath:(NSIndexPath *)indexPath;
- (void)deselectAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)lastOrder;

@end


