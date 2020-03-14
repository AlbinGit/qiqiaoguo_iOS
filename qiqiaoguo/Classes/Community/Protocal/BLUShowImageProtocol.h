//
//  BLUShowImageProtocol.h
//  Blue
//
//  Created by Bowen on 18/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUShowImageProtocol <NSObject>

@optional
- (void)showImage:(UIImage *)image fromSender:(id)sender;
- (void)showImages:(NSArray *)images fromSender:(id)sender;
- (void)showImageWithURL:(NSURL *)imageURL fromSender:(id)sender;
- (void)showImageWithURLs:(NSArray *)imageURLs fromSender:(id)sender;
- (void)showImageWithSignal:(RACSignal *)imageSignal fromSender:(id)sender;
- (void)showImagesWithSignals:(NSArray *)signals fromSender:(id)sender;

@end
