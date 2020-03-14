//
//  BLUImagePickerViewModel.m
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUImagePickerViewModel.h"

@implementation BLUImagePickerViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        _groups = [[NSMutableArray alloc] init];
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
            
            NSString *errorMessage = nil;
            switch ([error code]) {
                case ALAssetsLibraryAccessGloballyDeniedError:
                case ALAssetsLibraryAccessUserDeniedError: {
                    errorMessage = @"The user has declined access to it.";
                } break;
                default: {
                    errorMessage = @"Reason unknown";
                } break;
            }
            
            if ([self.delegate respondsToSelector:@selector(imagePickerViewModel:AccessAssetsFailureWithErrorMessage:)]) {
                [self.delegate imagePickerViewModel:self AccessAssetsFailureWithErrorMessage:errorMessage];
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if ([group numberOfAssets] > 0) {
                [_groups addObject:group];
            
                BLULogDebug(@"group name = %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            } else {
                if ([self.delegate respondsToSelector:@selector(imagePickerViewModelAccessAssetsSuccess:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self.delegate imagePickerViewModelAccessAssetsSuccess:self];
                    });
                }
            }
        };
        
        NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
        [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
        
    }
    return self;
}

- (NSMutableArray *)assetPickers {
    if (_assetPickers == nil) {
        _assetPickers = [NSMutableArray new];
    }
    return _assetPickers;
}

@end
