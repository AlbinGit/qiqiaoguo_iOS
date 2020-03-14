//
//  BLUPostDetailAsyncViewModel+Delegate.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@interface BLUPostDetailAsyncViewModel (Delegate)

- (void)sendError:(NSError *)error;
- (void)sendSuccessMessage:(NSString *)message;
- (void)contentWillChange;
- (void)contentDidChange;
- (void)didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(BLUViewModelObjectChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath;

- (void)didChangeSectionAtIndex:(NSInteger)index
                  forChangeType:(BLUViewModelObjectChangeType)type;

- (void)didChangeObjects:(NSArray *)objects
            atIndexPaths:(NSArray *)indexPaths
           forChangeType:(BLUViewModelObjectChangeType)type;

- (void)shouldShowNoCommentPrompt:(BOOL)show;
- (void)shouldShowRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)sendReplySuccessWithPost:(BLUPost *)post content:(NSString *)content;

- (void)didReload;
- (void)didLoadMoreData;
- (void)didReloadData;

@end
