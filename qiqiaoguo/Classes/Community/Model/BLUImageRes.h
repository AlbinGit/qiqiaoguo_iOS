//
//  BLUImageRes.h
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString * BLUImageResKeyID;
UIKIT_EXTERN NSString * BLUImageResKeyThumbnailURL;
UIKIT_EXTERN NSString * BLUImageResKeyOriginURL;
UIKIT_EXTERN NSString * BLUImageResKeyHeight;
UIKIT_EXTERN NSString * BLUImageResKeyWeight;
UIKIT_EXTERN NSString * BLUImageResKeyCreateDate;

@interface BLUImageRes : BLUObject

@property (nonatomic, assign) NSInteger imageID;
@property (nonatomic, copy, readonly) NSURL *thumbnailURL;
@property (nonatomic, copy, readonly) NSURL *originURL;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) UIImage *image;

- (instancetype)initWithThumbnailURL:(NSURL *)thumbailURL originURL:(NSURL *)originURL;
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name;
- (instancetype)initWithWidth:(CGFloat)width
                       height:(CGFloat)height
                    originURL:(NSURL *)originURL
                 thumbnailURL:(NSURL *)thumbnailURL;

@end
