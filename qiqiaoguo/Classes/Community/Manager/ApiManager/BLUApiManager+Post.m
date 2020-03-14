//
//  BLUApiManager+Post.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager+Post.h"
#import "BLUApiManager+Circle.h"
#import "BLUPost.h"
#import "BLUResponse.h"
#import "BLUApiManager+User.h"
#import "BLUPostTag.h"
#import "BLUApiManager+Others.h"
#import "BLUContentParagraph.h"

#define BLUPostApiLikePost          (BLUApiString(@"/post/like"))
#define BLUPostApiLikedPosts        (BLUApiString(@"/user/liked/posts")) // TODO:

#define BLUPostApiCollection        (BLUApiString(@"/posts/collection"))
#define BLUPostApiCollect           (BLUApiString(@"/post/collect"))
#define BLUPostApiParticipate       (BLUApiString(@"/posts/participated"))
#define BLUPostApiPost              (BLUApiString(@"/posts/user")) // Post, Put, Delete
#define BLUPostApiCirclePost        (BLUApiString(@"/posts/all"))

#define BLUPostApiRecommended       (BLUApiString(@"/post/recommended")) // Post, Put, Delete

#define BLUPostApiFresh             (BLUApiString(@"/posts/fresh"))
#define BLUPostApiEssential         (BLUApiString(@"/posts/essential"))
#define BLUPostApiDetail            (BLUApiString(@"/post/detail"))

#define BLUPostApiHotTags           (BLUApiString(@"/posttag/hot"))
#define BLUPostApiTagSearch         (BLUApiString(@"/posttag/search"))
#define BLUPostApiSendV2            (BLUApiString(@"/post/detail"))
#define BLUPostApiFollowPost        (BLUApiString(@"/posts/following"))
#define BLUPostApiHotPost           (BLUApiString(@"/posts/hot"))
#define BLUPostApiTagPost           (BLUApiString(@"/posttag/allpost"))
#define BLUPostApiTagHot            (BLUApiString(@"/posttag/hotdetail"))
#define BLUPostApiTagRecommendPost  (BLUApiString(@"/posttag/recommendedpost"))
#define BLUPostApiGoodVideos        (BLUApiString(@"/toy/video"))
#define BLUPostApiGoodRelevants     (BLUApiString(@"/toy/post"))
#define BLUPostApiGoodEvaluations   (BLUApiString(@"/toy/ceping"))

@implementation BLUApiManager (Post)

- (RACSignal *)collectPostWithPostID:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiCollect parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)cancelCollectPostWithPostID:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUPostApiCollect parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)deletePostForUserWithPostID:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUPostApiPost       parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)likePostWithPostID:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiLikePost parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)dislikePostWithPostID:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodDelete URLString:BLUPostApiLikePost parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)sendPostWithTitle:(NSString *)title content:(NSString *)content circleID:(NSInteger)circleID images:(NSArray *)images anonymousEable:(BOOL)anonymousEnable {
    
    BLULogInfo(@"title = %@, content = %@, circle id = %@, images = %@, anonymousEnable = %@", title, content, @(circleID), images, @(anonymousEnable));
    
    NSParameterAssert(title);
    NSMutableArray *formDataArray = [NSMutableArray new];
    
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        NSData *fileData = UIImageJPEGRepresentation(image, BLUApiImageCompressionQuality);
        NSString *name = [NSString stringWithFormat:@"image%@", @(idx)];
        NSString *filename = [NSString stringWithFormat:@"%@.jpg", name];
        BLUFormData *formData = [[BLUFormData alloc] initWithData:fileData name:name filename:filename mimeType:BLUApiMimeTypeImageJPEG];
        [formDataArray addObject:formData];
    }];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[BLUPostApiKeyTitle] = title;
    parameters[BLUCircleApiKeyCircleID] = @(circleID);
    parameters[BLUPostApiKeyAnonymousEnable] = @(anonymousEnable);
    if (content.length > 0) {
        parameters[BLUPostApiKeyContent] = content;
    }
    
    NSData *JSON = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    BLUFormData *parameterFormData = [[BLUFormData alloc] initWithData:JSON name:@"data" filename:nil mimeType:BLUApiMimeTypeJSON];
    [formDataArray addObject:parameterFormData];
    
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUPostApiDetail parameters:nil formDataArray:formDataArray resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)sendPostToCircle:(NSInteger)circleID
                          title:(NSString *)title
                     paragraphs:(NSArray *)paragraphs
                      tagTitles:(NSArray *)tagTitles
                      anonymous:(BOOL)anonymous {
    BLUAssertObjectIsKindOfClass(title, [NSString class]);
    BLUParameterAssert(circleID > 0);
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"title"] = title;
    NSMutableArray *contentDicts = [NSMutableArray new];
    for (BLUContentParagraph *paragraph in paragraphs) {
        BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
        if (paragraph.type == BLUPostParagraphTypeText) {
            BLUAssertObjectIsKindOfClass(paragraph.text, [NSString class]);
            NSDictionary *dict =
            @{@"text": paragraph.text,
              @"type": @(paragraph.type)};
            [contentDicts addObject:dict];
        } else if (paragraph.type == BLUPostParagraphTypeImage) {
            BLUParameterAssert(paragraph.imageRes.imageID > 0);
            NSDictionary *dict =
            @{@"image_id": @(paragraph.imageRes.imageID),
              @"type": @(paragraph.type)};
            [contentDicts addObject:dict];
        }
    }
    parameters[@"contents"] = contentDicts;
    parameters[@"post_tags"] = tagTitles;
    parameters[@"anonymous_status"] = @(anonymous);
    parameters[@"circle_id"] = @(circleID);
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost
                                                 URLString:BLUPostApiSendV2
                                                parameters:parameters
                                               resultClass:[BLUPost class]
                                             objectKeyPath:BLUApiObjectKeyItem]
            handleResponse];
}

- (RACSignal *)sendPostWithTitle:(NSString *)title contents:(NSArray *)contents tagTitles:(NSArray *)tagTitles circleID:(NSInteger)circleID anonymous:(BOOL)anonymous {

    NSParameterAssert([title isPostTitle]);
    NSParameterAssert(contents.count > 0);
    NSParameterAssert(circleID > 0);

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"title"] = title;
    parameters[@"contents"] = contents;
    parameters[@"anonymous_status"] = @(anonymous);
    if (tagTitles.count > 0) {
        parameters[@"post_tags"] = tagTitles;
    }

    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodPost URLString:BLUPostApiSendV2 parameters:parameters resultClass:nil objectKeyPath:nil] handleResponse];
}

- (RACSignal *)fetchRecommendedPosts:(BLUPagination *)pagination {
    BLULogInfo(@"Pagination = %@", pagination.description);
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiRecommended parameters:nil pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchPostsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"userID = %@", @(userID));
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiPost parameters:parameters pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchCollectedPostsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"userID = %@", @(userID));
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiCollection parameters:parameters pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchParticipatedPostsForUser:(NSInteger)userID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"userID = %@", @(userID));
    NSDictionary *parameters = @{BLUUserApiKeyUserID: @(userID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiParticipate parameters:parameters pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchPostsForCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"circleID = %@", @(circleID));
    NSDictionary *parameters = @{BLUCircleApiKeyCircleID: @(circleID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiCirclePost parameters:parameters pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchFreshPostsForCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"circleID = %@, pagination = %@", @(circleID), pagination);
    NSDictionary *parameters = @{BLUCircleApiKeyCircleID: @(circleID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiFresh parameters:parameters pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchEssentialPostsForCircle:(NSInteger)circleID pagination:(BLUPagination *)pagination {
    BLULogInfo(@"circleID = %@, pagination = %@", @(circleID), pagination);
    NSDictionary *parameters = @{BLUCircleApiKeyCircleID: @(circleID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiEssential parameters:parameters pagination:pagination resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchPostDetail:(NSInteger)postID {
    BLULogInfo(@"postID = %@", @(postID));
    NSDictionary *parameters = @{BLUPostApiKeyPostID: @(postID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiDetail parameters:parameters resultClass:[BLUPost class] objectKeyPath:BLUApiObjectKeyItem] handleResponse];
}

- (RACSignal *)fetchHotTags {
    BLULogInfo(@"Fetch hot tags");
    NSDictionary *parameters = @{@"page": @(1), @"per_page": @(1000)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiHotTags parameters:parameters resultClass:[BLUPostTag class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchHotTagForPagination:(BLUPagination *)pagination {
    BLULogInfo(@"Fetch hot tag----");
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet
                                                 URLString:BLUPostApiTagHot
                                                parameters:nil
                                                pagination:pagination
                                               resultClass:[BLUPostTag class]
                                             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];

}

- (RACSignal *)searchTagWithKeyword:(NSString *)keyword {
    BLULogInfo(@"keyword = %@", keyword);
    NSDictionary *parameters = @{@"tag_key_word": keyword, @"page": @(1), @"per_page": @(1000)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet URLString:BLUPostApiTagSearch parameters:parameters resultClass:[BLUPostTag class] objectKeyPath:BLUApiObjectKeyItems] handleResponse];
}

- (RACSignal *)fetchFollowPostWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet
                                                 URLString:BLUPostApiFollowPost
                                                parameters:nil
                                                pagination:pagination
                                               resultClass:[BLUPost class]
                                             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)fetchHotPostWithPagination:(BLUPagination *)pagination {
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet
                                                 URLString:BLUPostApiHotPost
                                                parameters:nil
                                                pagination:pagination
                                               resultClass:[BLUPost class]
                                             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)fetchPostsWithTag:(NSInteger)tagID pagination:(BLUPagination *)pagination {
    NSDictionary *parameter = @{@"post_tag_id": @(tagID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet
                                                 URLString:BLUPostApiTagPost
                                                parameters:parameter
                                                pagination:pagination
                                               resultClass:[BLUPost class]
                                             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)fetchRecommendedPostsWithTag:(NSInteger)tagID pagination:(BLUPagination *)pagination {
    NSDictionary *parameter = @{@"post_tag_id": @(tagID)};
    return [[[BLUApiManager sharedManager] fetchWithMethod:BLUApiHttpMethodGet
                                                 URLString:BLUPostApiTagRecommendPost
                                                parameters:parameter
                                                pagination:pagination
                                               resultClass:[BLUPost class]
                                             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)fetchGoodVideoPostsWithGoodID:(NSInteger)goodID pagination:(BLUPagination *)pagination {
    NSDictionary *parameters = @{@"toy_id": @(goodID)};
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUPostApiGoodVideos
             parameters:parameters
             pagination:pagination
             resultClass:[BLUPost class]
             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)fetchGoodRelevantPostsWithGoodID:(NSInteger)goodID pagination:(BLUPagination *)pagination {
    NSDictionary *parameters = @{@"toy_id": @(goodID)};
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUPostApiGoodRelevants
             parameters:parameters
             pagination:pagination
             resultClass:[BLUPost class]
             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

- (RACSignal *)fetchGoodEvaluationPostsWithGoodID:(NSInteger)goodID pagination:(BLUPagination *)pagination {
    NSDictionary *parameters = @{@"toy_id": @(goodID)};
    return [[[BLUApiManager sharedManager]
             fetchWithMethod:BLUApiHttpMethodGet
             URLString:BLUPostApiGoodEvaluations
             parameters:parameters
             pagination:pagination
             resultClass:[BLUPost class]
             objectKeyPath:BLUApiObjectKeyItems]
            handleResponse];
}

@end
