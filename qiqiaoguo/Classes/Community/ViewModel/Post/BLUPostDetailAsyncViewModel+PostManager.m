//
//  BLUPostDetailAsyncViewModel+PostManager.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel+PostManager.h"
#import "BLUPostDetailAsyncViewModelHeader.h"

@implementation BLUPostDetailAsyncViewModel (PostManager)

- (void)insertOrUpdatePost:(BLUPost *)post {
    NSParameterAssert([post isKindOfClass:[BLUPost class]]);
    if (![self isPostInPostDetails]) {
        [self.postDetails insertObject:self.posts
                               atIndex:[[self postIndexPath] section]];
        [self didChangeSectionAtIndex:[[self postIndexPath] section]
                        forChangeType:BLUViewModelObjectChangeTypeInsert];
    }
    if ([self isPostExist]) {
        [self updatePost:post];
    } else {
        [self insertPost:post];
    }
}

- (void)insertPost:(BLUPost *)post {
    // 任何时候都只有一个post
    [self.posts removeAllObjects];
    [self.posts addObject:post];
    [self didChangeObject:post
              atIndexPath:[self postIndexPath]
            forChangeType:BLUViewModelObjectChangeTypeInsert
             newIndexPath:nil];
    [self didChangeObject:post
              atIndexPath:[self postLikeIndexPath]
            forChangeType:BLUViewModelObjectChangeTypeInsert
             newIndexPath:nil];
}

- (void)updatePost:(BLUPost *)post {
    [self.posts removeAllObjects];
    [self.posts addObject:post];
    [self didChangeObject:post
              atIndexPath:[self postIndexPath]
            forChangeType:BLUViewModelObjectChangeTypeUpdate
             newIndexPath:nil];
    [self didChangeObject:post
              atIndexPath:[self postLikeIndexPath]
            forChangeType:BLUViewModelObjectChangeTypeUpdate
             newIndexPath:nil];
}

- (void)removePost {
    BOOL hadPost = self.posts.count > 0;
    [self.posts removeAllObjects];
    if (hadPost) {
        [self didChangeObject:nil
                  atIndexPath:[self postIndexPath]
                forChangeType:BLUViewModelObjectChangeTypeDelete
                 newIndexPath:nil];
        [self didChangeObject:nil
                  atIndexPath:[self postLikeIndexPath]
                forChangeType:BLUViewModelObjectChangeTypeDelete
                 newIndexPath:nil];
    } else {
        return;
    }
}

- (BOOL)isPostExist {
    if (self.posts.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPostInPostDetails {
    return [self isRowsInPostDetails:self.posts];
}

- (BLUPost *)post {
    BLUPost *post = self.posts.firstObject;
    NSParameterAssert([post isKindOfClass:[BLUPost class]]);
    return post;
}

- (NSIndexPath *)postIndexPath {
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath *)postLikeIndexPath {
    return [NSIndexPath indexPathForRow:1 inSection:0];
}



@end
