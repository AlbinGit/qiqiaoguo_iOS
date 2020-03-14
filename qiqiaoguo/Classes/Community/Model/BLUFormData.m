//
//  BLUFormData.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUFormData.h"

@implementation BLUFormData

- (instancetype)initWithData:(NSData *)data name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType {
    NSParameterAssert(data);
    NSParameterAssert(name);
//    NSParameterAssert(filename);
    NSParameterAssert(mimeType);
    
    if (self = [super init]) {
        _data = data;
        _name = name;
        _filename = filename;
        _mimeType = mimeType;
    }
    return self;
}

@end
