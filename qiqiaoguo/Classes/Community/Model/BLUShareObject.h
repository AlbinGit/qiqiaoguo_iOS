//
//  BLUShareObject.h
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUObject.h"
#import "BLUShareObjectHeader.h"

@protocol BLUShareObject <NSObject>

@required

- (BLUShareObjectType)objectType;

@optional

- (NSString *)shareTitle;
- (NSString *)shareContent;
- (NSURL *)shareRedirectURL;
- (NSURL *)shareImageURL;
- (UIImage *)shareDefaultImage;

@end
