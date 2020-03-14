//
//  BLUChatViewModel.h
//  Blue
//
//  Created by Bowen on 30/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUChatViewModelState) {
    BLUChatViewModelStateNormal = 0,
    BLUChatViewModelStateFetching,
    BLUChatViewModelStateFetchFailed,
    BLUChatViewModelStateFetchAgain,
};

@class BLUMessageMO;
@class BLUGoodMO;

@interface BLUChatViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, readonly) BLUChatViewModelState state;
@property (nonatomic, weak) BLUViewController *viewController;

- (instancetype)initWithUserID:(NSInteger)userID fetchedResultsControllerDelegate:(id <NSFetchedResultsControllerDelegate>)delegate;

- (RACSignal *)sendMessage:(NSString *)message;
- (void)generateGoodHint:(BLUGoodMO *)goodMO;
- (RACSignal *)sendGood:(BLUGoodMO *)goodMO;
- (RACSignal *)resendMessage:(BLUMessageMO *)messageMO;

- (void)fetch;
- (void)deleteAllMessages;

@end
