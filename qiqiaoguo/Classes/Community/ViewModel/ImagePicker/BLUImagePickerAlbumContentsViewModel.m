//
//  BLUImagePickerAlbumContentsViewModel.m
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUImagePickerAlbumContentsViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BLUAssetPicker.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>

static NSString *const kSelectionPromptString = @"%@ / %@";

@interface BLUImagePickerAlbumContentsViewModel ()

@property (nonatomic, assign) NSInteger selectedCount;

@end

@implementation BLUImagePickerAlbumContentsViewModel

- (instancetype)initWithAlAssetsGroup:(ALAssetsGroup *)assetsGroup assetPickers:(NSMutableArray *)assetPickers maxImageCount:(NSInteger)count{
    NSParameterAssert(assetsGroup);
    NSParameterAssert(assetPickers);
    
    if (self = [super init]) {
        _assetPickers = assetPickers;
        _selectedCount = assetPickers.count;
        _assets = [[NSMutableArray alloc] init];
        _assetsGroup = assetsGroup;
        _assetsGroupName = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        _maxImageCount = count;
        
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [_assets addObject:result];
            }
        };
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [_assetsGroup setAssetsFilter:onlyPhotosFilter];
        [_assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
        
        RAC(self, prompt) = [RACObserve(self, selectedCount) map:^id(NSNumber *count) {
            return [NSString stringWithFormat:kSelectionPromptString, count, @(self.maxImageCount)];
        }];
        
        RAC(self, shouldSelect) = [self _validate];
    }

    return self;
}

- (RACCommand *)finishSelection {
    return [[RACCommand alloc] initWithEnabled:[self _validate] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableArray *images = [NSMutableArray new];
            NSArray *sortedAssetPickers = [self _sortedAssetPickersWithAssetPickers:self.assetPickers];
            
            for (BLUAssetPicker *assetPicker in sortedAssetPickers) {
                ALAssetRepresentation *rep = [assetPicker.asset defaultRepresentation];
                NSNumber *imageWidth = rep.metadata[(NSString *)kCGImagePropertyPixelWidth];
                NSNumber *imageHeight = rep.metadata[(NSString *)kCGImagePropertyPixelHeight];
                UIImage *image = nil;
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
                CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
                if ((imageWidth.floatValue >  screenWidth) &&
                    (imageHeight.floatValue >  screenHeight)){
                    image =
                    [UIImage imageWithCGImage:[rep fullScreenImage]
                                        scale:[rep scale]
                                  orientation:UIImageOrientationUp];
                } else {
                    image =
                    [UIImage imageWithCGImage:[rep fullResolutionImage]
                                        scale:[rep scale]
                                  orientation:UIImageOrientationUp];
                }

                [images addObject:image];
            }
            
            [subscriber sendNext:images];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

- (NSArray *)_sortedAssetPickersWithAssetPickers:(NSArray *)assetPickers {
    return [assetPickers sortedArrayUsingComparator:^NSComparisonResult(BLUAssetPicker *picker1, BLUAssetPicker *picker2) {
        if (picker1.order < picker2.order) {
            return NSOrderedAscending;
        } else if (picker1.order == picker2.order) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
}

- (RACSignal *)_validate {
    return [RACObserve(self, selectedCount) map:^(NSNumber *count) {
        return @(count.integerValue > 0 && count.integerValue <= self.maxImageCount);
    }];
}

- (NSInteger)lastOrder {
    NSInteger lastOrder = 0;
    for (BLUAssetPicker *assetPicker in self.assetPickers) {
        lastOrder = lastOrder > assetPicker.order ? lastOrder : assetPicker.order;
    }
    return lastOrder;
}

- (BOOL)_isAssetPickerExist:(BLUAssetPicker *)paramAssetPicker{
    BOOL ret = NO;
    for (BLUAssetPicker *assetPicker in self.assetPickers) {
        if ([assetPicker.groupName isEqualToString:paramAssetPicker.groupName]) {
            if (assetPicker.indexPath.section == paramAssetPicker.indexPath.section && assetPicker.indexPath.row == paramAssetPicker.indexPath.row) {
                ret = YES;
            }
        }
    }
    return ret;
}

- (BLUAssetPicker *)_assetPickerWithIndexPath:(NSIndexPath *)indexPath {
    BLUAssetPicker *assetPicker = nil;
    for (BLUAssetPicker *ap in self.assetPickers) {
        if (ap.indexPath.section == indexPath.section && ap.indexPath.row == indexPath.row && [ap.groupName isEqualToString:self.assetsGroupName]) {
            assetPicker = ap;
        }
    }
    return assetPicker;
}

- (void)selectAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCount < self.maxImageCount) {
        ALAsset *asset = self.reverseAssets[indexPath.row];
        BLUAssetPicker *assetPicker = [BLUAssetPicker new];
        
        assetPicker.order = [self lastOrder] + 1;
        assetPicker.indexPath = indexPath;
        assetPicker.asset = asset;
        assetPicker.groupName = self.assetsGroupName;
        
        if (![self _isAssetPickerExist:assetPicker]) {
            [self.assetPickers addObject:assetPicker];
            self.selectedCount++;
        }
    }
}

- (void)deselectAtIndexPath:(NSIndexPath *)indexPath {
    BLUAssetPicker *assetPicker = [self _assetPickerWithIndexPath:indexPath];
    if (self.selectedCount > 0 && assetPicker) {
        NSInteger deletedOrder = assetPicker.order;
        [self.assetPickers removeObject:assetPicker];
        for (BLUAssetPicker *assetPicker in self.assetPickers) {
            if (assetPicker.order > deletedOrder) {
                assetPicker.order--;
            }
        }
        self.selectedCount--;
    }
}

- (NSArray *)_currentImageSignals {
    NSMutableArray *currentAssetPickers = [NSMutableArray new];
    for (BLUAssetPicker *assetPicker in self.assetPickers) {
        if ([assetPicker.groupName isEqualToString:self.assetsGroupName]) {
            [currentAssetPickers addObject:assetPicker];
        }
    }
    NSArray *sortedAssetPickers = [self _sortedAssetPickersWithAssetPickers:currentAssetPickers];
   
    NSMutableArray *imageSignals = [NSMutableArray new];
 
    for (BLUAssetPicker *assetPicker in sortedAssetPickers) {
        RACSignal *imageSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ALAssetRepresentation *rep = [assetPicker.asset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                if (iref) {
                    UIImage *image = [UIImage imageWithCGImage:iref];
                    [subscriber sendNext:image];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:nil];
                }
            });
            return nil;
        }];
        [imageSignals addObject:imageSignal];
    }
    
    return imageSignals;
}

- (RACCommand *)previewSelction {
    return [[RACCommand alloc] initWithEnabled:[RACObserve(self, selectedCount) map:^id(NSNumber *count) {
        return @(count.integerValue > 0);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:[self _currentImageSignals]];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

- (NSArray *)reverseAssets {
    if (_reverseAssets == nil) {
        _reverseAssets = [[self.assets reverseObjectEnumerator] allObjects] ;
    }
    return _reverseAssets;
}

@end
