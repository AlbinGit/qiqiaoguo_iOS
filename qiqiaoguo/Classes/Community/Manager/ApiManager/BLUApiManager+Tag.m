//
//  BLUApiManager+Tag.m
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager+Tag.h"
#import "BLUPostTag.h"

#define BLUPostApiTag           (BLUApiString(@"/posttag/detail"))

@implementation BLUApiManager (Tag)

- (RACSignal *)fetchTagWithTagID:(NSInteger)tagID {
    NSDictionary *parameter = @{@"post_tag_id": @(tagID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet
                                                 URLString:BLUPostApiTag
                                                parameters:parameter
                                               resultClass:[BLUPostTag class]
                                             objectKeyPath:BLUApiObjectKeyItem]
            handleResponse];
}

@end
