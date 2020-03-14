//
//  BLUViewModelDelegateHelper.m
//  Blue
//
//  Created by Bowen on 22/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUViewModelDelegateHelper.h"

#define BLUViewModelValidation BLUParameterAssert(self.viewModel != nil)
#define BLUViewModelDelegateValidation BLUParameterAssert([self.viewModelDelegate conformsToProtocol:@protocol(BLUViewModelDelegate)])
#define BLUViewModelFetchedDelegateValidation BLUParameterAssert([self.viewModelFetchedDelegate conformsToProtocol:@protocol(BLUViewModelFetchedResultsController)])

@implementation BLUViewModelDelegateHelper

- (void)didMeetError:(NSError *)error {
    BLUViewModelValidation;
    BLUViewModelDelegateValidation;
    if ([self.viewModelDelegate
         respondsToSelector:@selector(viewModel:didMeetError:)]) {
        [self.viewModelDelegate viewModel:self.viewModel didMeetError:error];
    }
}

- (void)successWithMessage:(NSString *)message {
    BLUViewModelValidation;
    BLUViewModelDelegateValidation;
    if ([self.viewModelDelegate
         respondsToSelector:@selector(viewModel:didSuccessWithMessage:)]) {
        [self.viewModelDelegate viewModel:self.viewModel didSuccessWithMessage:message];
    }
}

- (void)willChangeContent {
    BLUViewModelValidation;
    BLUViewModelFetchedDelegateValidation;
    if ([self.viewModelFetchedDelegate
         respondsToSelector:@selector(viewModelWillChangeContent:)]) {
        [self.viewModelFetchedDelegate
         viewModelWillChangeContent:self.viewModel];
    }
}

- (void)didChangeContent {
    BLUViewModelValidation;
    BLUViewModelFetchedDelegateValidation;
    if ([self.viewModelFetchedDelegate
         respondsToSelector:@selector(viewModelDidChangeContent:)]) {
        [self.viewModelFetchedDelegate
         viewModelDidChangeContent:self.viewModel];
    }
}

- (void)didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(BLUViewModelObjectChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    BLUViewModelValidation;
    BLUViewModelFetchedDelegateValidation;
    if ([self.viewModelFetchedDelegate
         respondsToSelector:
         @selector(viewModel:
                   didChangeObject:
                   atIndexPath:
                   forChangeType:
                   newIndexPath:)]) {
        [self.viewModelFetchedDelegate
         viewModel:self.viewModel
         didChangeObject:object
         atIndexPath:indexPath
         forChangeType:type
         newIndexPath:newIndexPath];
    }
}

- (void)didChangeSectionAtIndex:(NSInteger)index forChangeType:(BLUViewModelObjectChangeType)type {
    BLUViewModelValidation;
    BLUViewModelFetchedDelegateValidation;
    if ([self.viewModelFetchedDelegate
         respondsToSelector:
         @selector(viewModel:
                   didChangeSectionAtIndex:
                   forChangeType:)]) {
        [self.viewModelFetchedDelegate
         viewModel:self.viewModel
         didChangeSectionAtIndex:index
         forChangeType:type];
    }
}

@end
