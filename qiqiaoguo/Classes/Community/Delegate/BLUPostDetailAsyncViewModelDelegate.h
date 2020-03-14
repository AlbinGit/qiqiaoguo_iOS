//
//  BLUPostDetailAsyncViewModelDelegate.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BLUViewModel.h"

@class BLUPost;
@class BLUPostDetailAsyncViewModel;

@protocol BLUPostDetailAsyncViewModelDelegate <NSObject>

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
     didMeetError:(NSError *)error;

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
didSuccessWithMessage:(NSString *)message;

- (void)viewModelWillChangeContent:(BLUPostDetailAsyncViewModel *)viewModel;

- (void)viewModelDidChangeContent:(BLUPostDetailAsyncViewModel *)viewModel;

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
  didChangeObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(BLUViewModelObjectChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath;

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
didChangeSectionAtIndex:(NSInteger)index
    forChangeType:(BLUViewModelObjectChangeType)type;

- (void)viewModelDidReloadData:(BLUPostDetailAsyncViewModel *)viewModel;

- (void)shouldShowNoCommentPrompt:(BOOL)show
                    fromViewModel:(BLUPostDetailAsyncViewModel *)viewModel;

- (void)shouldShowRowAtIndexPath:(NSIndexPath *)indexPath
                   fromViewModel:(BLUPostDetailAsyncViewModel *)viewModel;

- (void)viewModel:(BLUPostDetailAsyncViewModel *)viewModel
     didReplyPost:(BLUPost *)post
      withContent:(NSString *)content;

- (void)viewModelDidReload:(BLUPostDetailAsyncViewModel *)viewModel;

- (void)viewModelDidLoadMoreData:(BLUPostDetailAsyncViewModel *)viewModel;

@end
