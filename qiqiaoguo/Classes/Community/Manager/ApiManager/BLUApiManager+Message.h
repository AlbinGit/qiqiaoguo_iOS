//
//  BLUApiManager+Message.h
//  Blue
//
//  Created by Bowen on 27/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager.h"
#import "BLUPageRedirection.h"
#import "BLUMessageHeader.h"

@interface BLUApiManager (Message)

- (RACSignal *)fetchMessagesUser:(NSInteger)userID
                         didRead:(BOOL)didRead
                      pagination:(BLUPagination *)pagination;

- (RACSignal *)sendMessageToUser:(NSInteger)userID
                         content:(NSString *)content
                            type:(NSInteger)type;

- (RACSignal *)sendMessageToUser:(NSInteger)userID
                     contentType:(BLUMessageType)contentType
                         content:(NSString *)content
                    redirectType:(BLUPageRedirectionType)redirectType
                      redirectID:(NSInteger)redirectID;

@end
