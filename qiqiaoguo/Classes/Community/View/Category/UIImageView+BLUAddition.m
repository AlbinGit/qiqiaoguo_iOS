//
//  UIImageView+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIImageView+BLUAddition.h"

static void * const kBackgroundImageURLKey = "kBackgroundImageURLKey";

@implementation UIImageView (BLUAddition)

- (void)setImageURL:(NSURL *)imageUrl {
    objc_setAssociatedObject(self, kBackgroundImageURLKey, imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            self.image = image;
        }
    }];

}

@end
