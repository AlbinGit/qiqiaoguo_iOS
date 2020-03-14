//
//  BLUAd.h
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"
#import "BLUPageRedirection.h"
//#import "BLUObject+PageRedirection.h"

@interface BLUAd : BLUObject <BLUPageRedirection>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *imageURL;

@end
