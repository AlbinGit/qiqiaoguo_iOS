//
//  ASNetworkImageNode+BLUAddition.m
//  Blue
//
//  Created by Bowen on 9/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASNetworkImageNode+BLUAddition.h"

static void * const kImageURLKey = "kImageURLKey";

@implementation ASNetworkImageNode (BLUAddition)

- (NSURL *)imageURL {
    NSURL *url = objc_getAssociatedObject(self, kImageURLKey);
    return url;
}

- (void)setImageURL:(NSURL *)imageUrl {
    objc_setAssociatedObject(self, kImageURLKey, imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            self.image = image;
        }
    }];
}

@end
