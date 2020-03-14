//
//  BLUServer.m
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUServer.h"

@interface BLUServer ()

@property (nonatomic, copy, readwrite) NSString *baseURLString;

@end

@implementation BLUServer

+ (instancetype)sharedServer {
    static BLUServer *_sharedServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedServer = [BLUServer new];
        _sharedServer.baseURLString = QQG_BASE_APIURLString;
    });
    return _sharedServer;
}

@end
