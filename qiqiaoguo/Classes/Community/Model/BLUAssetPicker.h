//
//  BLUAssetPicker.h
//  Blue
//
//  Created by Bowen on 8/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface BLUAssetPicker : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) ALAsset *asset;

@end
