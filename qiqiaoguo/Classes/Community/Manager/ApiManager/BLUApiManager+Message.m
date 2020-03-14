//
//  BLUApiManager+Message.m
//  Blue
//
//  Created by Bowen on 27/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager+Message.h"
#import "BLUMessage.h"

#define BLUApiMessage          (BLUApiString(@"/Phone/Message/sendChatMsg"))// Get, Post

#define BLUApigetChat          (BLUApiString(@"/Phone/Message/getChatMsgList"))

@implementation BLUApiManager (Message)

- (RACSignal *)fetchMessagesUser:(NSInteger)userID didRead:(BOOL)didRead pagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApigetChat parameters:@{@"target_id": @(userID),@"platform_id":PLATFORMID} pagination:pagination resultClass:[BLUMessage class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)sendMessageToUser:(NSInteger)userID content:(NSString *)content type:(NSInteger)type {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUApiMessage parameters:@{@"to_user_id": @(userID), @"message_type": @(type), @"message_content": content,@"platform_id":PLATFORMID} resultClass:[BLUMessage class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)sendMessageToUser:(NSInteger)userID
                     contentType:(BLUMessageType)contentType
                         content:(NSString *)content
                    redirectType:(BLUPageRedirectionType)redirectType
                      redirectID:(NSInteger)redirectID {

    NSDictionary *parameters =
    @{@"to_user_id": @(userID),
      @"message_type": @(contentType),
      @"message_content":content,
      @"jump_type": @(redirectType),
      @"jump_id": @(redirectID)};

    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost
                                                 URLString:BLUApiMessage
                                                parameters:parameters
                                               resultClass:[BLUMessage class]
                                             objectKeyPath:BLUApiObjectKeyItem]
            handleResponse];
}

@end
