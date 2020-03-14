//
//  BLUShareManager.m
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUShareManager.h"
#import "BLUShareObject.h"
#import "BLUPost.h"

@implementation BLUShareManager

- (void)shareContentWithObject:(id <BLUShareObject>)shareObject shareType:(BLUShareType)shareType{
    switch ([shareObject objectType]) {
        case BLUShareObjectTypeTag:
        case BLUShareObjectTypePost: {
            if ([[shareObject shareImageURL] isKindOfClass:[NSURL class]]) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[shareObject shareImageURL] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        [self shareContentWithObject:shareObject image:image shareType:shareType];
                    } else {
                        [self sendError:error forObject:nil];
                        [self shareContentWithObject:shareObject image:shareObject.shareDefaultImage shareType:shareType];
                    }
                }];
            } else {
                [self shareContentWithObject:shareObject image:shareObject.shareDefaultImage shareType:shareType];
            }
        } break;
        case BLUShareObjectTypeDefault: break;
    }
}

- (void)shareContentWithObject:(id <BLUShareObject>)shareObject image:(UIImage *)image shareType:(BLUShareType)shareType{
    @weakify(self);
    [[QGSocialService postShareContentWithType:shareType
                                          title:shareObject.shareTitle
                                        content:shareObject.shareContent
                                          image:image
                                       jumpsURL:shareObject.shareRedirectURL.absoluteString
                                       location:nil
                                    resourceURL:nil
                                   resourceType:BLUShareResourceTypeDefault
                            presentedController:_presentedViewController] subscribeNext:^(id x) {
        BLULogDebug(@"x = %@", x);
    } error:^(NSError *error) {
        @strongify(self);
        [self sendError:error forObject:shareObject];
    } completed:^{
        @strongify(self);
        [self sendCompleteForObject:shareObject];
    }];
}

- (void)sendError:(NSError *)error forObject:(id <BLUShareObject>)object{
    if ([self.delegate
         respondsToSelector:@selector(shareManager:didShareObjectFailed:WithError:)]) {
        [self.delegate shareManager:self
               didShareObjectFailed:object
                          WithError:error];
    }
}

- (void)sendCompleteForObject:(id <BLUShareObject>)shareObject {
    if ([self.delegate
         respondsToSelector:@selector(shareManage:didShareObject:withMessage:)]) {
        [self.delegate shareManage:self
                    didShareObject:shareObject
                       withMessage:NSLocalizedString(@"share-manager.success", @"Share success.")];
    }
}

- (void)copyURLToPasteboardWithShareObject:(id <BLUShareObject>)post {
    [[UIPasteboard generalPasteboard] setString:post.shareRedirectURL.absoluteString];
    if ([self.delegate
         respondsToSelector:@selector(shareManage:didShareObject:withMessage:)]) {
        [self.delegate shareManage:self
                    didShareObject:nil
                       withMessage:NSLocalizedString(@"share-manager.copy-to-pasteboard-success", @"Did copy to the pasteboard.")];
    }
    
}

@end

@implementation BLUViewController (BLUShareManager)

- (void)shareManager:(BLUShareManager *)shareManage
didShareObjectFailed:(id <BLUShareObject>)object
           WithError:(NSError *)error {
    [self showTopIndicatorWithError:error];
}

- (void)shareManage:(BLUShareManager *)shareManage
     didShareObject:(id <BLUShareObject>)object
        withMessage:(NSString *)message {
    [self showTopIndicatorWithSuccessMessage:message];
}

@end
