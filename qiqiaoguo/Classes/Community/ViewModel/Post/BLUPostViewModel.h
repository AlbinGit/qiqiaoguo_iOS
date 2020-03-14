//
//  BLUPostViewModel.h
//  Blue
//
//  Created by Bowen on 24/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUPostType) {
    BLUPostTypeRecommended = 0,
    BLUPostTypeForUser,
    BLUPostTypeForCollection,
    BLUPostTypeForParticipated,
    BLUPostTypeForCircle,
    BLUPostTypeFresh,
    BLUPostTypeEssential,
    BLUPostTypeHot,
    BLUPostTypeTag,
    BLUPostTypeTagRecommended,
    BLUPostTypeGoodVideos,
    BLUPostTypeGoodRelevant,
    BLUPostTypeGoodEvaluation,
};

@class BLUPost;

@interface BLUPostViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSArray *posts;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger circleID;
@property (nonatomic, assign) NSInteger tagID;
@property (nonatomic, assign) NSInteger goodID;
@property (nonatomic, assign, readonly) BLUPostType type;
@property (nonatomic, assign, readonly) NSInteger fetchCount;
@property (nonatomic, assign, readonly) BOOL noMoreData;


@property (nonatomic, assign) BOOL locked;

@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, weak) RACDisposable *fetchNextDisposable;

- (RACSignal *)fetch;
- (RACSignal *)fetchNext;
- (RACSignal *)deletePost:(BLUPost *)post;

- (instancetype)initWithPostType:(BLUPostType)type;

@end
