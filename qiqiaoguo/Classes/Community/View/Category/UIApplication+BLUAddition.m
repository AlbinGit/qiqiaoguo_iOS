//
//  UIApplication+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIApplication+BLUAddition.h"

@implementation UIApplication (BLUAddition)

static NSLock *networkOperationCountLock;
static NSInteger networkOperationCount;

+ (void)startNetworkActivity {
    [self createLock];
    [networkOperationCountLock lock];
    networkOperationCount++;
    [networkOperationCountLock unlock];
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

+ (void)finishNetworkActivity {
    [self createLock];
    [networkOperationCountLock lock];
    networkOperationCount--;
    [networkOperationCountLock unlock];
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

+ (void)createLock {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkOperationCountLock = [NSLock new];
    });
}

- (void)updateNetworkActivityIndicator {
    [self setNetworkActivityIndicatorVisible:(networkOperationCount > 0 ? TRUE : FALSE)];
    
    [networkOperationCountLock lock];
    if (networkOperationCount < 0) {
        networkOperationCount = 0;
    }
    [networkOperationCountLock unlock];
}

@end
