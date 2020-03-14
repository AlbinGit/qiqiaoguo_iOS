//
//  BLUApiManager+Dialogue.m
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager+Dialogue.h"
#import "BLUDialogue.h"

#define BLUApiDialogue    (BLUApiString(@"/Phone/Message/getDialogueMsgList"))
#define BLUApiDeleteDialogue    (BLUApiString(@"/Phone/Message/deleteDialogue"))

@implementation BLUApiManager (Dialogue)

- (RACSignal *)fetchDialogueWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUApiDialogue parameters:@{@"platform_id":PLATFORMID} pagination:pagination resultClass:[BLUDialogue class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)deleteDialogueWithDialogueID:(NSInteger)dialogueID {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUApiDeleteDialogue parameters:@{@"dialogue_id": @(dialogueID),@"platform_id":PLATFORMID} resultClass:nil objectKeyPath:nil] handleResponse];
}

@end
