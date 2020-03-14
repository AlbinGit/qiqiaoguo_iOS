//
//  BLUApiManager+MessageCategory.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager+MessageCategory.h"
#import "BLUMessageCategory.h"
#import "QGMessageTypeModel.h"

#define BLUApiMessageDynamic       (BLUApiString(@"/Phone/Message/getMessageCount"))

@implementation BLUApiManager (MessageCategory)

- (RACSignal *)fetchMessageCategories {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiMessageDynamic parameters:@{@"platform_id":PLATFORMID} resultClass:[QGMessageTypeModel class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

@end
