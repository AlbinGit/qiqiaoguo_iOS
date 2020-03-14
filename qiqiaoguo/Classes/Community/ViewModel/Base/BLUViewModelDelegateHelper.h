//
//  BLUViewModelDelegateHelper.h
//  Blue
//
//  Created by Bowen on 22/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUViewModelHeader.h"
#import "BLUViewModel.h"
#import "BLUViewModelDelegate.h"
#import "BLUViewModelFetchedResultsController.h"

@interface BLUViewModelDelegateHelper : NSObject

@property (nonatomic, weak) id <BLUViewModelDelegate> viewModelDelegate;
@property (nonatomic, weak) id <BLUViewModelFetchedResultsController> viewModelFetchedDelegate;
@property (nonatomic, weak) BLUViewModel *viewModel;

- (void)didMeetError:(NSError *)error;
- (void)successWithMessage:(NSString *)message;

- (void)willChangeContent;
- (void)didChangeContent;
- (void)didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(BLUViewModelObjectChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath;
- (void)didChangeSectionAtIndex:(NSInteger)index
                  forChangeType:(BLUViewModelObjectChangeType)type;

@end
