//
//  BLUDialogueViewModel.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUDialogueViewModelState) {
    BLUDialogueViewModelStateNormal = 0,
    BLUDialogueViewModelStateFetching,
    BLUDialogueViewModelStateFetchFailed,
    BLUDialogueViewModelStateFetchAgain,
};

@class BLUDialogueMO;

@interface BLUDialogueViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, readonly) BLUDialogueViewModelState state;

- (instancetype)initWithFetchedResultsControllerDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;
- (void)fetch;
- (void)deleteDialogue:(BLUDialogueMO *)dialogueMO;

@end
