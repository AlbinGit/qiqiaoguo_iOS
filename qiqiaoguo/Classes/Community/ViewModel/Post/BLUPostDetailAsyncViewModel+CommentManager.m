//
//  BLUPostDetailAsyncViewModel+CommentManager.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel+CommentManager.h"
#import "BLUPostDetailAsyncViewModelHeader.h"

@implementation BLUPostDetailAsyncViewModel (CommentManager)

- (void)addFeaturedComments:(NSArray *)comments {
    NSParameterAssert([comments isKindOfClass:[NSArray class]]);
    NSParameterAssert(comments.count > 0);
    [self shouldShowNoCommentPrompt:NO];

    [self insertFeaturedCommentsToPostDetailsIfNeeded];

    NSArray *newIndexPaths =
    [self newIndexPathOfRows:self.featuredComments
                     newRows:comments
                     section:[self sectionOfFeaturedComments]];
    [self.featuredComments addObjectsFromArray:comments];
    [self didChangeObjects:comments
              atIndexPaths:newIndexPaths
             forChangeType:BLUViewModelObjectChangeTypeInsert];
}

// 直接在comments和currentComments插入数据
- (void)addComments:(NSArray *)comments {
    BLUAssertObjectIsKindOfClass(comments, [NSArray class]);
    BLUAssert(comments.count > 0, @"不可以插入空评论。");

    NSMutableArray *currentComments = [self currentComments];

    [self insertCommentsTOPostDetailIfNeeded:currentComments];
    [self shouldShowNoCommentPrompt:NO];

    NSArray *newIndexpaths = [self newIndexPathOfRows:currentComments
                                              newRows:comments
                                              section:[self sectionOfComments]];

    [currentComments addObjectsFromArray:comments];
    [self didChangeObjects:comments
              atIndexPaths:newIndexpaths
             forChangeType:BLUViewModelObjectChangeTypeInsert];
}

- (void)addComments:(NSArray *)comments
        toViewComments:(NSMutableArray *)viewComments {
    BLUAssertObjectIsKindOfClass(comments, [NSArray class]);
    BLUAssert(comments.count > 0, @"不可以插入空评论。");
    BLUAssertObjectIsKindOfClass(viewComments, [NSMutableArray class])

    [self insertCommentsTOPostDetailIfNeeded:viewComments];
    [self shouldShowNoCommentPrompt:NO];

    [viewComments addObjectsFromArray:comments];

    if ([self currentComments] == viewComments) {
        NSArray *newIndexpaths = [self newIndexPathOfRows:viewComments
                                                  newRows:comments
                                                  section:[self sectionOfComments]];

        [self didChangeObjects:comments
                  atIndexPaths:newIndexpaths
                 forChangeType:BLUViewModelObjectChangeTypeInsert];
    }
}

- (void)insertComment:(BLUComment *)comment
        toViewComment:(NSMutableArray *)viewComments
              atIndex:(NSInteger)index {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    BLUAssertObjectIsKindOfClass(viewComments, [NSMutableArray class])

    [self insertCommentsTOPostDetailIfNeeded:viewComments];
    [self shouldShowNoCommentPrompt:NO];

    [viewComments insertObject:comment atIndex:index];

    if ([self currentComments] == viewComments) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:index inSection:[self sectionOfComments]];

        [self didChangeObject:comment
                  atIndexPath:indexPath
                forChangeType:BLUViewModelObjectChangeTypeInsert
                 newIndexPath:nil];
    }
}

- (BOOL)isFeaturedCommentsInPostDetails {
    return [self isRowsInPostDetails:self.featuredComments];
}

- (BOOL)isCommentsInPostDetails {
    return [self currentCommentsInPostDetails] != nil;
}

- (void)insertCommentsTOPostDetailIfNeeded:(NSMutableArray *)comments {
    if ([self.postDetails containsObject:comments]) {
        return;
    } else {
        if ([self currentCommentsInPostDetails] == nil) {
            [self.postDetails addObject:comments];
            [self didChangeSectionAtIndex:[self sectionOfRows:comments] forChangeType:BLUViewModelObjectChangeTypeInsert];
        } else {
            BLUAssert([self currentCommentsInPostDetails] != comments, @"PostDetails 中的数据出现了错误");
        }
    }
}

- (void)insertFeaturedCommentsToPostDetailsIfNeeded {
    if (![self isFeaturedCommentsInPostDetails]) {
        if ([self isCommentsInPostDetails]) {
            NSInteger section = [self sectionOfComments];
            NSParameterAssert(section != NSNotFound);
            [self.postDetails insertObject:self.featuredComments
                                   atIndex:section];
            [self didChangeSectionAtIndex:section
                            forChangeType:BLUViewModelObjectChangeTypeInsert];
        } else {
            [self.postDetails addObject:self.featuredComments];
            NSInteger section = [self sectionOfFeaturedComments];
            NSParameterAssert(section != NSNotFound);
            [self didChangeSectionAtIndex:section
                            forChangeType:BLUViewModelObjectChangeTypeInsert];
        }
    }
}

- (NSInteger)sectionOfComments {
    return [self sectionOfRows:[self currentComments]];
}

- (NSInteger)sectionOfFeaturedComments {
    return [self sectionOfRows:self.featuredComments];
}

- (void)updateUIForNewCommentType:(BLUPostDetailAsyncCommentType)type {
    
    NSArray *oldComments = [self currentCommentsInPostDetails];
    if (oldComments == nil) {
        return;
    }
    
    [self contentWillChange];
    NSArray *oldIndexPaths =
    [self indexPathsOfRows:oldComments
                   section:[self sectionOfRows:oldComments]];

    [self.postDetails removeObject:oldComments];

    [self didChangeObjects:oldComments
              atIndexPaths:oldIndexPaths
             forChangeType:BLUViewModelObjectChangeTypeDelete];

    NSArray *newComments = [self commentsForCommentType:type];
    [self.postDetails addObject:newComments];

    NSArray *newIndexPaths =
    [self indexPathsOfRows:newComments
                   section:[self sectionOfRows:newComments]];

    [self didChangeObjects:newComments
              atIndexPaths:newIndexPaths
             forChangeType:BLUViewModelObjectChangeTypeInsert];

//    NSInteger section = [self sectionOfFeaturedComments];
//
//    if (!self.showOwnerComments &&
//        self.featuredComments.count > 0 &&
//        section == NSNotFound) {
//        NSInteger newSection = [self postIndexPath].section + 1;
//        if ([self post]) {
//            [self.postDetails insertObject:self.featuredComments atIndex:newSection];
//            [self didChangeSectionAtIndex:newSection forChangeType:BLUViewModelObjectChangeTypeInsert];
//            NSArray *featureCommentIndexPaths =
//            [self indexPathsOfRows:self.featuredComments section:[self sectionOfRows:self.featuredComments]];
//            [self didChangeObjects:self.featuredComments atIndexPaths:featureCommentIndexPaths forChangeType:BLUViewModelObjectChangeTypeInsert];
//        }
//    }
//
//    if (self.showOwnerComments) {
//        if (section != NSNotFound) {
//            [self.postDetails removeObject:self.featuredComments];
//            [self didChangeSectionAtIndex:section forChangeType:BLUViewModelObjectChangeTypeDelete];
//            NSArray *featureCommentIndexPaths =
//            [self indexPathsOfRows:self.featuredComments section:[self sectionOfRows:self.featuredComments]];
//            [self didChangeObjects:self.featuredComments atIndexPaths:featureCommentIndexPaths forChangeType:BLUViewModelObjectChangeTypeDelete];
//        }
//    }

    [self contentDidChange];
}

- (void)updateCommentsUIAtIndexPath:(NSIndexPath *)indexPath {
    BLUAssertObjectIsKindOfClass(indexPath, [NSIndexPath class]);
    [self contentWillChange];
    [self didChangeObject:nil
              atIndexPath:indexPath
            forChangeType:BLUViewModelObjectChangeTypeUpdate
             newIndexPath:nil];
    [self contentDidChange];
}

- (void)updateCommentsUIForComment:(BLUComment *)comment {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class])
    NSIndexPath *indexPath = [self indexPathForComment:comment];
    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
        [self updateCommentsUIAtIndexPath:indexPath];
    }

    indexPath = [self indexPathForFeaturedComment:comment];
    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
        [self updateCommentsUIAtIndexPath:indexPath];
    }
}

- (void)updateCommentForAllComments:(BLUComment *)comment {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    NSArray *commentsCollection = @[self.featuredComments,
                                    self.ascComments,
                                    self.descComments,
                                    self.ownerAscComments,
                                    self.ownerDescComments];

    for (NSMutableArray *comments in commentsCollection) {
        BLUAssertObjectIsKindOfClass(comments, [NSMutableArray class]);
        [self updateComment:comment forComments:comments];
    }
}

- (void)updateComment:(BLUComment *)comment
          forComments:(NSMutableArray *)comments {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    BLUAssertObjectIsKindOfClass(comments, [NSMutableArray class]);
    NSInteger index = [self indexForComment:comment inComments:comments];
    if (index != NSNotFound) {
        [comments replaceObjectAtIndex:index withObject:comment];
    }
}

- (NSInteger)indexForComment:(BLUComment *)comment inComments:(NSArray *)comments {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    BLUAssertObjectIsKindOfClass(comments, [NSArray class]);
    __block NSInteger index = NSNotFound;
    [comments enumerateObjectsUsingBlock:^(BLUComment *iterComment, NSUInteger idx, BOOL * _Nonnull stop) {
        BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
        if (iterComment.commentID == comment.commentID) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (NSIndexPath *)indexPathForFeaturedComment:(BLUComment *)comment {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    NSArray *featuredComments = [self featuredComments];
    NSInteger section = [self sectionOfFeaturedComments];
    NSInteger index = [self indexForComment:comment inComments:featuredComments];
    if (section != NSNotFound && index != NSNotFound) {
        return [NSIndexPath indexPathForRow:index inSection:section];
    } else {
        return nil;
    }
}

- (NSIndexPath *)indexPathForComment:(BLUComment *)comment {
    BLUAssertObjectIsKindOfClass(comment, [BLUComment class]);
    NSArray *currentComments = [self currentComments];
    NSInteger section = [self sectionOfComments];
    NSInteger index = [self indexForComment:comment inComments:currentComments];
    if (section != NSNotFound && index != NSNotFound) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:index inSection:section];
        return indexPath;
    } else {
        return nil;
    }
}

- (NSArray *)featuredCommentsIndexPaths {
    if (self.featuredComments.count > 0) {
        return [self indexPathsOfRows:self.featuredComments
                              section:[self sectionOfRows:self.featuredComments]];
    } else {
        return nil;
    }
}

- (void)deleteAllFeaturedComments {
    NSArray *indexPaths =
    [self indexPathsOfRows:self.featuredComments
                   section:[self sectionOfFeaturedComments]];
    for (NSIndexPath *indexPath in indexPaths) {
        [self didChangeObject:nil
                  atIndexPath:indexPath
                forChangeType:BLUViewModelObjectChangeTypeDelete
                 newIndexPath:nil];
    }
    [self.featuredComments removeAllObjects];
}

- (void)deleteFeaturedCommentAtIndex:(NSInteger)index {
    BLUParameterAssert(NO);
}

- (void)deleteFeaturedCommentWithComment:(BLUComment *)comment {
    BLUParameterAssert(NO);
}

- (void)deleteCommentAtIndex:(NSInteger)index
             forViewComments:(NSMutableArray *)viewComments {
    BLUParameterAssert(NO);
}

- (void)deleteComment:(BLUComment *)comment
      forViewComments:(NSMutableArray *)viewComments {
    BLUParameterAssert(NO);
}

- (void)deleteAllComments {
    NSMutableArray *currentComments = [self currentComments];

    NSArray *indexPaths =
    [self indexPathsOfRows:currentComments section:[self sectionOfComments]];
    [self didChangeObjects:currentComments
              atIndexPaths:indexPaths
             forChangeType:BLUViewModelObjectChangeTypeDelete];
    [currentComments removeAllObjects];

    [self.ascComments removeAllObjects];
    [self.descComments removeAllObjects];
    [self.ownerAscComments removeAllObjects];
    [self.ownerDescComments removeAllObjects];
}

- (void)deleteCurrentComments {
    NSMutableArray *currentComments = [self currentComments];

    NSArray *indexPaths =
    [self indexPathsOfRows:currentComments section:[self sectionOfComments]];
    for (NSIndexPath *indexPath in indexPaths) {
        [self didChangeObject:nil
                  atIndexPath:indexPath
                forChangeType:BLUViewModelObjectChangeTypeDelete
                 newIndexPath:nil];
    }
    [currentComments removeAllObjects];
}

@end
