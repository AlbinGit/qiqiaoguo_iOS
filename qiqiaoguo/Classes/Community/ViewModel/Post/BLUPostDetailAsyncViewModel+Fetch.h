//
//  BLUPostDetailAsyncViewModel+Fetch.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@interface BLUPostDetailAsyncViewModel (Fetch)

- (void)fetchAll;
- (void)fetchPost;
- (void)fetchFeatureComments;

- (void)fetchComments;
- (void)fetchCommentsWithBasePage:(BOOL)basePage forType:(BLUPostDetailAsyncCommentType)type;
- (void)fetchMoreComments;
- (BOOL)shouldFetchForNewType:(BLUPostDetailAsyncCommentType)type;

- (void)refreshCommentsForType:(BLUPostDetailAsyncCommentType)type;

@end
