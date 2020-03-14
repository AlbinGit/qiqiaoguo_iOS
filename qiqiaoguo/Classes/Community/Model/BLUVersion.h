//
//  BLUVersion.h
//  Blue
//
//  Created by Bowen on 17/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

UIKIT_EXTERN NSString *BLUVersionKeyType;

#import "BLUObject.h"

@interface BLUVersion : BLUObject

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, copy, readonly) NSString *type;

@end
