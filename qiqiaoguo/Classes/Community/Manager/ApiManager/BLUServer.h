//
//  BLUServer.h
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "MTLModel.h"

@interface BLUServer : MTLModel

@property (nonatomic, copy, readonly) NSString *baseURLString;

+ (BLUServer *)sharedServer;

@end
