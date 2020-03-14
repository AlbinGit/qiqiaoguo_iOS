//
//  BLUApiManager+Post.h
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"

static NSString * const BLUPostApiKeyPostID                 = @"post_id";
static NSString * const BLUPostApiKeyTitle                  = @"title";
static NSString * const BLUPostApiKeyContent                = @"content";
static NSString * const BLUPostApiKeyAnonymousEnable        = @"anonymous_status";

@interface BLUApiManager (Post)

- (RACSignal *)collectPostWithPostID:(NSInteger)postID;
- (RACSignal *)cancelCollectPostWithPostID:(NSInteger)postID;

- (RACSignal *)deletePostForUserWithPostID:(NSInteger)postID;

- (RACSignal *)likePostWithPostID:(NSInteger)postID;
- (RACSignal *)dislikePostWithPostID:(NSInteger)postID;

- (RACSignal *)sendPostWithTitle:(NSString *)title content:(NSString *)content circleID:(NSInteger)circleID images:(NSArray *)images anonymousEable:(BOOL)anonymousEnable;

- (RACSignal *)sendPostToCircle:(NSInteger)circleID
                          title:(NSString *)title
                     paragraphs:(NSArray *)paragraphs
                      tagTitles:(NSArray *)tagTitles
                      anonymous:(BOOL)anonymous;

- (RACSignal *)fetchRecommendedPosts:(BLUPagination *)pagination;
- (RACSignal *)fetchPostsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchCollectedPostsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchParticipatedPostsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchPostsForCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchFreshPostsForCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchEssentialPostsForCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchPostDetail:(NSInteger)postID;

- (RACSignal *)fetchHotTags;

- (RACSignal *)fetchHotTagForPagination:(BLUPagination *)pagination;

- (RACSignal *)searchTagWithKeyword:(NSString *)keyword;

- (RACSignal *)fetchFollowPostWithPagination:(BLUPagination *)pagination;

- (RACSignal *)fetchHotPostWithPagination:(BLUPagination *)pagination;

- (RACSignal *)fetchPostsWithTag:(NSInteger)tagID pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchRecommendedPostsWithTag:(NSInteger)tagID pagination:(BLUPagination *)pagination;

- (RACSignal *)fetchGoodVideoPostsWithGoodID:(NSInteger)goodID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchGoodRelevantPostsWithGoodID:(NSInteger)goodID pagination:(BLUPagination *)pagination;
- (RACSignal *)fetchGoodEvaluationPostsWithGoodID:(NSInteger)goodID pagination:(BLUPagination *)pagination;

@end
