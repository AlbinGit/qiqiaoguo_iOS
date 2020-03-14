//
//  ASNetworkImageNode+BLUAddition.m
//  Blue
//
//  Created by Bowen on 9/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASNetworkImageNode+BLUAddition.h"
#import "SDWebImageDownloader.h"
static void * const kImageURLKey = "kImageURLKey";

@implementation ASNetworkImageNode (BLUAddition)

- (NSURL *)imageURL {
    NSURL *url = objc_getAssociatedObject(self, kImageURLKey);
    return url;
}

- (void)setImageURL:(NSURL *)imageUrl {
    objc_setAssociatedObject(self, kImageURLKey, imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        if (image) {
//            self.image = image;
//        }
//    }];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            self.image = image;
        }
    }];
}

@end
