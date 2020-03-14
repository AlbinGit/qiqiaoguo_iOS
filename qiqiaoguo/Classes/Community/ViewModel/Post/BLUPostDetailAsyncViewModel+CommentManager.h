//
//  BLUPostDetailAsyncViewModel+CommentManager.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@interface BLUPostDetailAsyncViewModel (CommentManager)

- (void)addFeaturedComments:(NSArray *)comments;
- (void)addComments:(NSArray *)comments;
- (void)addComments:(NSArray *)comments
        toViewComments:(NSMutableArray *)viewComments;

- (void)insertComment:(BLUComment *)comments
        toViewComment:(NSMutableArray *)viewComments
              atIndex:(NSInteger)index;

- (void)deleteAllFeaturedComments;
- (void)deleteFeaturedCommentAtIndex:(NSInteger)index;
- (void)deleteFeaturedCommentWithComment:(BLUComment *)comment;

- (void)deleteCommentAtIndex:(NSInteger)index
             forViewComments:(NSMutableArray *)viewComments;
- (void)deleteComment:(BLUComment *)comment
      forViewComments:(NSMutableArray *)viewComments;
- (void)deleteAllComments;
- (void)deleteCurrentComments;

- (void)updateUIForNewCommentType:(BLUPostDetailAsyncCommentType)type;

- (void)updateCommentsUIAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateCommentsUIForComment:(BLUComment *)comment;

- (void)updateCommentForAllComments:(BLUComment *)comment;

- (void)updateComment:(BLUComment *)comment
          forComments:(NSArray *)comments;

- (NSInteger)indexForComment:(BLUComment *)comment
                  inComments:(NSArray *)comments;

- (NSIndexPath *)indexPathForComment:(BLUComment *)comment;

- (NSArray *)featuredCommentsIndexPaths;

@end
