//
//  BLUPost.h
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"
#import "BLUShareObject.h"

typedef NS_ENUM(NSInteger, BLUPostState) {
    BLUPostTypeNormal = 0,
    BLUPostTypeFeature,
};

typedef NS_ENUM(NSInteger, BLUPostContentTypes) {
    BLUPostContentTypeNormal = 0,
    BLUPostContentTypeParagraph,
};

UIKIT_EXTERN NSInteger BLUPostTitleMaxLength;
UIKIT_EXTERN NSInteger BLUPostContentMaxLength;
UIKIT_EXTERN NSInteger BLUPostMaxPhotosCount;

UIKIT_EXTERN NSString * const BLUPostKeyPostID;
UIKIT_EXTERN NSString * const BLUPostKeyPost;

@class BLUUser;
@class BLUCircle;

@interface BLUPost : BLUObject

@property (nonatomic, assign, readonly) NSInteger postID;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) BLUUser *author;
@property (nonatomic, copy, readonly) BLUCircle *circle;
@property (nonatomic, assign, readonly) BLUPostState postType;
@property (nonatomic, assign, readonly) NSInteger commentCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign, readonly) NSInteger photoCount;
@property (nonatomic, assign, readonly) NSInteger collectedCount;
@property (nonatomic, copy, readonly) NSArray *photos;
@property (nonatomic, copy) NSArray *likedUsers;
@property (nonatomic, copy, readonly) NSArray *tags;

@property (nonatomic, copy, readonly) NSArray *paragraphs;
@property (nonatomic, assign, readonly) BLUPostContentTypes contentType;

@property (nonatomic, assign, getter=didLike) BOOL like;
@property (nonatomic, assign, getter=didCollect) BOOL collect;

@property (nonatomic, assign, readonly) BOOL anonymousEnable;

@property (nonatomic, assign, readonly) BOOL hasVideo;

@property (nonatomic, assign, readonly) BOOL isTop;

@property (nonatomic, assign, getter=didFollow) BOOL follow;
@property (nonatomic, assign, getter=isRecommend) BOOL recommend;

@property (nonatomic, strong, readonly) NSURL *videoCoverURL;
@property (nonatomic, assign, readonly) NSInteger accessCount;

- (void)generateParagraphFromNormalContent;
- (void)generateParagraphFromPhotos;

@end

@interface BLUPost (Share)
<BLUShareObject>

@end

@interface BLUPost (Validation)

+ (RACSignal *)validatePostTitle:(RACSignal *)titleSignal;
+ (RACSignal *)validatePostContent:(RACSignal *)contentSignal;

@end

@interface NSString (BLUPost)

- (BOOL)isPostTitle;
- (BOOL)isPostContent;

@end
