//
//  BLUPostDetailAsyncViewModel+Delegate.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel+Delegate.h"

@implementation BLUPostDetailAsyncViewModel (Delegate)

- (void)sendSuccessMessage:(NSString *)message {
    if ([self.delegate respondsToSelector:@selector(viewModel:didSuccessWithMessage:)]) {
        [self.delegate viewModel:self didSuccessWithMessage:message];
    }
}

- (void)sendError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(viewModel:didMeetError:)]) {
        [self.delegate viewModel:self didMeetError:error];
    }
}

- (void)contentWillChange {
    if ([self.delegate respondsToSelector:@selector(viewModelWillChangeContent:)]) {
        [self.delegate viewModelWillChangeContent:self];
    }
}

- (void)contentDidChange {
    if ([self.delegate respondsToSelector:@selector(viewModelDidChangeContent:)]) {
        [self.delegate viewModelDidChangeContent:self];
    }
}

- (void)didChangeObject:(id)object
            atIndexPath:(NSIndexPath *)indexPath
          forChangeType:(BLUViewModelObjectChangeType)type
           newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.delegate
         respondsToSelector:
         @selector(viewModel:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        [self.delegate
         viewModel:self
         didChangeObject:object
         atIndexPath:indexPath
         forChangeType:type
         newIndexPath:newIndexPath];
    }
}

- (void)didChangeSectionAtIndex:(NSInteger)index
                  forChangeType:(BLUViewModelObjectChangeType)type {
    BLUParameterAssert(index != NSNotFound);
    if ([self.delegate
         respondsToSelector:@selector(viewModel:didChangeSectionAtIndex:forChangeType:)]) {
        [self.delegate
         viewModel:self
         didChangeSectionAtIndex:index
         forChangeType:type];
    }
}

- (void)didChangeObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths forChangeType:(BLUViewModelObjectChangeType)type {
    NSParameterAssert(objects.count == indexPaths.count);
    for (NSInteger i = 0; i < objects.count; ++i) {
        [self didChangeObject:objects[i] atIndexPath:indexPaths[i] forChangeType:type newIndexPath:nil];
    }
}

- (void)shouldShowNoCommentPrompt:(BOOL)show {
    if ([self.delegate respondsToSelector:@selector(shouldShowNoCommentPrompt:fromViewModel:)]) {
        [self.delegate shouldShowNoCommentPrompt:show fromViewModel:self];
    }
}

- (void)shouldShowRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(shouldShowRowAtIndexPath:fromViewModel:)]) {
        [self.delegate shouldShowRowAtIndexPath:indexPath fromViewModel:self];
    }
}

- (void)sendReplySuccessWithPost:(BLUPost *)post content:(NSString *)content {
    if ([self.delegate
         respondsToSelector:@selector(viewModel:didReplyPost:withContent:)]) {
        [self.delegate viewModel:self didReplyPost:post withContent:content];
    }
}

- (void)didReload {
    if ([self.delegate
         respondsToSelector:@selector(viewModelDidReload:)]) {
        [self.delegate viewModelDidReload:self];
    }
}

- (void)didLoadMoreData {
    if ([self.delegate
         respondsToSelector:@selector(viewModelDidLoadMoreData:)]) {
        [self.delegate viewModelDidLoadMoreData:self];
    }
}

- (void)didReloadData {
    if ([self.delegate
         respondsToSelector:@selector(viewModelDidReloadData:)]) {
        [self.delegate viewModelDidReloadData:self];
    }
}

@end
