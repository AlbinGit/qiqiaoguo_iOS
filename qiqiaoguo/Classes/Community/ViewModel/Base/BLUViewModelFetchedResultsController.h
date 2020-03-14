//
//  BLUViewModelFetchedResultsController.h
//  Blue
//
//  Created by Bowen on 22/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUViewModelHeader.h"

@class BLUViewModel;

@protocol BLUViewModelFetchedResultsController <NSObject>

- (void)viewModelWillChangeContent:(BLUViewModel *)viewModel;

- (void)viewModelDidChangeContent:(BLUViewModel *)viewModel;

- (void)viewModel:(BLUViewModel *)viewModel
  didChangeObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(BLUViewModelObjectChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath;

- (void)viewModel:(BLUViewModel *)viewModel
didChangeSectionAtIndex:(NSInteger)index
    forChangeType:(BLUViewModelObjectChangeType)type;

@end
