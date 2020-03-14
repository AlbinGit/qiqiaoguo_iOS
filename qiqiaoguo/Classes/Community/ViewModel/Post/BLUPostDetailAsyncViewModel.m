//
//  BLUPostDetailAsyncViewModel.m
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUPost.h"
#import "BLUApiManager+Comment.h"
#import "BLUPostDetailAsyncViewModelHeader.h"

static const NSInteger kCommentPerpage = 20;

@implementation BLUPostDetailAsyncViewModel

- (instancetype)init {
    if (self = [super init]) {
        _showOwnerComments = NO;
        _commentsReverse = YES;
        _commentType = BLUPostDetailAsyncCommentTypeDescComments;
    }
    return self;
}

- (void)setPostID:(NSInteger)postID {
    BLUAssert(postID > 0, @"postID要求大于0，postID ==> %@", @(postID));
    _postID = postID;
}

- (BLUPagination *)featuredCommentsPagination {
    if (_featuredCommentsPagination == nil) {
        _featuredCommentsPagination = [[BLUPagination alloc] initWithPerpage:kCommentPerpage
                                                                       group:nil
                                                                       order:BLUPaginationOrderNone];
    }
    return _featuredCommentsPagination;
}

- (NSMutableArray *)postDetails {
    if (_postDetails == nil) {
        _postDetails = [NSMutableArray new];
    }
    return _postDetails;
}

- (NSMutableArray *)posts {
    if (_posts == nil) {
        _posts = [NSMutableArray new];
    }
    return _posts;
}

- (NSMutableArray *)featuredComments {
    if (_featuredComments == nil) {
        _featuredComments = [NSMutableArray new];
    }
    return _featuredComments;
}

- (NSMutableArray *)comments {
    return [self commentsForCommentType:_commentType];
}

- (NSMutableArray *)ascComments {
    if (_ascComments == nil) {
        _ascComments = [NSMutableArray new];
    }
    return _ascComments;
}

- (NSMutableArray *)descComments {
    if (_descComments == nil) {
        _descComments = [NSMutableArray new];
    }
    return _descComments;
}

- (NSMutableArray *)ownerAscComments {
    if (_ownerAscComments == nil) {
        _ownerAscComments = [NSMutableArray new];
    }
    return _ownerAscComments;
}

- (NSMutableArray *)ownerDescComments {
    if (_ownerDescComments == nil) {
        _ownerDescComments = [NSMutableArray new];
    }
    return _ownerDescComments;
}

- (BLUPagination *)ascCommentsPagination {
    if (_ascCommentsPagination == nil) {
        _ascCommentsPagination =
        [[BLUPagination alloc] initWithPerpage:kCommentPerpage
                                         group:nil
                                         order:BLUPaginationOrderAsc];
    }
    return _ascCommentsPagination;
}

- (BLUPagination *)descCommentsPagination {
    if (_descCommentsPagination == nil) {
        _descCommentsPagination =
        [[BLUPagination alloc] initWithPerpage:kCommentPerpage
                                         group:nil
                                         order:BLUPaginationOrderDesc];
    }
    return _descCommentsPagination;
}

- (BLUPagination *)ownerAscCommentsPagination {
    if (_ownerAscCommentsPagination == nil) {
        _ownerAscCommentsPagination =
        [[BLUPagination alloc] initWithPerpage:kCommentPerpage
                                         group:nil
                                         order:BLUPaginationOrderAsc];
    }
    return _ownerAscCommentsPagination;
}

- (BLUPagination *)ownerDescCommentsPagination {
    if (_ownerDescCommentsPagination == nil) {
        _ownerDescCommentsPagination =
        [[BLUPagination alloc] initWithPerpage:kCommentPerpage
                                         group:nil
                                         order:BLUPaginationOrderDesc];
    }
    return _ownerDescCommentsPagination;
}

- (void)setDelegate:(id<BLUPostDetailAsyncViewModelDelegate>)delegate {
    _delegate = delegate;
    [self shouldShowNoCommentPrompt:NO];
}

- (void)setCommentsReverse:(BOOL)commentsReverse {
    if (_commentsReverse != commentsReverse) {
        _commentsReverse = commentsReverse;
        [self configureCommentType];
    }
}

- (void)setShowOwnerComments:(BOOL)showOwnerComments {
    if (_showOwnerComments != showOwnerComments) {
        _showOwnerComments = showOwnerComments;
        [self configureCommentType];
    }
}

- (void)setCommentType:(BLUPostDetailAsyncCommentType)commentType {
    if (_commentType != commentType) {
        _commentType = commentType;
        [self configureReverseAndOwnerState];
        [self updateUIForNewCommentType:_commentType];
        if ([self shouldFetchForNewType:commentType]) {
            [self fetchComments];
        }
    }
}

- (void)configureCommentType {
    if (_showOwnerComments) {
        if (_commentsReverse) {
            self.commentType = BLUPostDetailAsyncCommentTypeOwnerDescComments;
        } else {
            self.commentType = BLUPostDetailAsyncCommentTypeOwnerAscComments;
        }
    } else {
        if (_commentsReverse) {
            self.commentType = BLUPostDetailAsyncCommentTypeDescComments;
        } else {
            self.commentType = BLUPostDetailAsyncCommentTypeAscComments;
        }
    }
}

- (void)configureReverseAndOwnerState {
    switch (self.commentType) {
        case BLUPostDetailAsyncCommentTypeDescComments: {
            _showOwnerComments = NO;
            _commentsReverse = YES;
        } break;
        case BLUPostDetailAsyncCommentTypeAscComments: {
            _showOwnerComments = NO;
            _commentsReverse = NO;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerAscComments: {
            _showOwnerComments = YES;
            _commentsReverse = NO;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            _showOwnerComments = YES;
            _commentsReverse = YES;
        } break;
    }
}

- (NSMutableArray *)currentComments {
    NSMutableArray *rows = nil;
    switch (self.commentType) {
        case BLUPostDetailAsyncCommentTypeDescComments: {
            rows = self.descComments;
        } break;
        case BLUPostDetailAsyncCommentTypeAscComments: {
            rows = self.ascComments;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerAscComments: {
            rows = self.ownerAscComments;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            rows = self.ownerDescComments;
        } break;
    }
    return rows;
}

- (NSMutableArray *)currentCommentsInPostDetails {
    NSMutableArray *commentsArray = [NSMutableArray new];
    for (NSMutableArray *comments in self.postDetails) {
        if (comments == self.ascComments ||
            comments == self.descComments ||
            comments == self.ownerAscComments ||
            comments == self.ownerDescComments) {
            [commentsArray addObject:comments];
        }
    }
    BLUAssert(commentsArray.count <= 1, @"当前postDetails中数据有误");
    if (commentsArray.count > 0) {
        return commentsArray.firstObject;
    } else {
        return nil;
    }
}

- (BLUPagination *)currentPagination {
    BLUPagination *pagination;
    switch (self.commentType) {
        case BLUPostDetailAsyncCommentTypeDescComments: {
            pagination = self.descCommentsPagination;
        } break;
        case BLUPostDetailAsyncCommentTypeAscComments: {
            pagination = self.ascCommentsPagination;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerAscComments: {
            pagination = self.ownerDescCommentsPagination;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            pagination = self.ownerAscCommentsPagination;
        } break;
    }
    return pagination;
}

- (BLUPagination *)paginationForCommentType:(BLUPostDetailAsyncCommentType)type {
    BLUPagination *pagination;
    switch (type) {
        case BLUPostDetailAsyncCommentTypeAscComments: {
            pagination = self.ascCommentsPagination;
        } break;
        case BLUPostDetailAsyncCommentTypeDescComments: {
            pagination = self.descCommentsPagination;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerAscComments: {
            pagination = self.ownerAscCommentsPagination;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            pagination = self.ownerDescCommentsPagination;
        } break;
        default: {
            BLUAssert(NO, @"错误的commentType, type ==> %@", @(type));
        } break;
    }
    return pagination;
}

- (NSMutableArray *)commentsForCommentType:(BLUPostDetailAsyncCommentType)type {
    NSMutableArray *comments;
    switch (type) {
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            comments = self.ownerDescComments;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerAscComments: {
            comments = self.ownerAscComments;
        } break;
        case BLUPostDetailAsyncCommentTypeDescComments: {
            comments = self.descComments;
        } break;
        case BLUPostDetailAsyncCommentTypeAscComments: {
            comments = self.ascComments;
        } break;
        default: {
            BLUAssert(NO, @"错误的commentType, type ==> %@", @(type));
        } break;
    }
    return comments;
}

- (BOOL)isReverseCommentsForCommentType:(BLUPostDetailAsyncCommentType)type {
    BOOL isReverse;
    switch (type) {
        case BLUPostDetailAsyncCommentTypeDescComments:
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            isReverse = YES;
        } break;
        case BLUPostDetailAsyncCommentTypeOwnerAscComments:
        case BLUPostDetailAsyncCommentTypeAscComments: {
            isReverse = NO;
        } break;
        default: {
            BLUAssert(NO, @"错误的commentType, type ==> %@", @(type));
        } break;
    }
    return isReverse;
}

- (BOOL)isOwnerCommentsForCommentType:(BLUPostDetailAsyncCommentType)type {
    BOOL isOwner;
    switch (type) {
        case BLUPostDetailAsyncCommentTypeOwnerAscComments:
        case BLUPostDetailAsyncCommentTypeOwnerDescComments: {
            isOwner = YES;
        } break;
        case BLUPostDetailAsyncCommentTypeDescComments:
        case BLUPostDetailAsyncCommentTypeAscComments: {
            isOwner = NO;
        } break;
        default: {
            BLUAssert(NO, @"错误的commentType, type ==> %@", @(type));
        } break;
    }
    return isOwner;
}

@end
