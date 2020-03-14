//
//  BLUPostCommentViewModel.h
//  Blue
//
//  Created by Bowen on 26/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUPostCommentType) {
    BLUPostCommentTypeForPost = 0,
    BLUPostCommentTypeForOwner,
};

@class BLUComment;

@interface BLUPostCommentViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSArray *comments;
@property (nonatomic, assign, readonly) NSInteger commentCount;
@property (nonatomic, assign) NSInteger postID;

@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, weak) RACDisposable *fetchNextDisposable;

- (RACSignal *)fetch;
- (RACSignal *)fetchNext;
- (RACSignal *)fetchCommentWithCommentID:(NSInteger)commentID;

- (NSInteger)deleteComment:(BLUComment *)comment;
- (void)insertComment:(BLUComment *)comment atIndex:(NSInteger)index;

- (instancetype)initWithPostCommentType:(BLUPostCommentType)postCommentType;

@end
