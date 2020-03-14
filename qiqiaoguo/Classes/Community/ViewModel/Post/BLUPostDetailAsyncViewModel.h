//
//  BLUPostDetailAsyncViewModel.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"
#import "BLUPostDetailAsyncViewModelDelegate.h"

typedef NS_ENUM(NSInteger, BLUPostDetailAsyncSectionType) {
    BLUPostDetailAsyncSectionTypeNone = 0,
    BLUPostDetailAsyncSectionTypePost,
    BLUPostDetailAsyncSectionTypeFeaturedComments,
    BLUPostDetailAsyncSectionTypeComments,
};

typedef NS_ENUM(NSInteger, BLUPostDetailAsyncObjectType) {
    BLUPostDetailAsyncObjectTypePost = 0,
    BLUPostDetailAsyncObjectTypeComment,
};

typedef NS_ENUM(NSInteger, BLUPostDetailAsyncCommentType) {
    BLUPostDetailAsyncCommentTypeAscComments = 0,
    BLUPostDetailAsyncCommentTypeDescComments,
    BLUPostDetailAsyncCommentTypeOwnerAscComments,
    BLUPostDetailAsyncCommentTypeOwnerDescComments,
};

@class BLUPost, BLUComment, BLUCommentReply;

@interface BLUPostDetailAsyncViewModel : BLUViewModel

@property (nonatomic, assign) NSInteger postID;

@property (nonatomic, assign) BOOL commentsReverse;
@property (nonatomic, assign) BOOL ownerCommentsRevers;
@property (nonatomic, assign) BLUPostDetailAsyncCommentType commentType;
@property (nonatomic, assign) BOOL showOwnerComments;
@property (nonatomic, assign) BOOL dataSourceLocked;
@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, weak) RACDisposable *disposable;

@property (nonatomic, strong) NSMutableArray *postDetails;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *featuredComments;

@property (nonatomic, strong) NSMutableArray *ascComments;
@property (nonatomic, strong) NSMutableArray *descComments;
@property (nonatomic, strong) NSMutableArray *ownerAscComments;
@property (nonatomic, strong) NSMutableArray *ownerDescComments;

@property (nonatomic, strong) BLUPagination *featuredCommentsPagination;

@property (nonatomic, strong) BLUPagination *ascCommentsPagination;
@property (nonatomic, strong) BLUPagination *descCommentsPagination;
@property (nonatomic, strong) BLUPagination *ownerAscCommentsPagination;
@property (nonatomic, strong) BLUPagination *ownerDescCommentsPagination;

@property (nonatomic, weak) id <BLUPostDetailAsyncViewModelDelegate> delegate;

// 当前type指向的comments
- (NSMutableArray *)currentComments;

// 当前在postDetails中的comments
- (NSMutableArray *)currentCommentsInPostDetails;

- (BLUPagination *)currentPagination;

- (BOOL)isReverseCommentsForCommentType:(BLUPostDetailAsyncCommentType)type;
- (BOOL)isOwnerCommentsForCommentType:(BLUPostDetailAsyncCommentType)type;
- (BLUPagination *)paginationForCommentType:(BLUPostDetailAsyncCommentType)type;
- (NSMutableArray *)commentsForCommentType:(BLUPostDetailAsyncCommentType)type;

@end


