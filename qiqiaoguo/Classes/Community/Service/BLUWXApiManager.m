//
//  BLUWXApiManager.m
//  Blue
//
//  Created by Bowen on 31/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUWXApiManager.h"
#import "WXApi.h"

@implementation BLUWXApiManager

#pragma mark - Life cycle

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static BLUWXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[BLUWXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess: {
                if ([self.delegate
                     respondsToSelector:@selector(managerDidPaymentSuccess:)]) {
                    [self.delegate managerDidPaymentSuccess:self];
                }
            } break;

            default: {
                if ([self.delegate
                     respondsToSelector:@selector(manager:didPaymentFailed:)]) {
                    NSError *error = [NSError errorWithDomain:@"WXApiDelegate"
                                                         code:resp.errCode
                                                  description:resp.errStr
                                                       reason:resp.errStr];
                    [self.delegate manager:self didPaymentFailed:error];
                }
            } break;
        }
    }
}

@end
