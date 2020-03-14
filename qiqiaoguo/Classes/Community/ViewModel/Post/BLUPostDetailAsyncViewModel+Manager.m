//
//  BLUPostDetailAsyncViewModel+Manager.m
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel+Manager.h"
#import "BLUPostDetailAsyncViewModelHeader.h"

@implementation BLUPostDetailAsyncViewModel (Manager)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    BLUAssertIndexInCollection(indexPath.section, self.postDetails);
    NSArray *rows = self.postDetails[indexPath.section];
    BLUAssertObjectIsKindOfClass(rows, [NSArray class]);

    if (rows == self.posts) {
        return self.posts.firstObject;
    } else {
        BLUAssertIndexInCollection(indexPath.row, rows);
        return rows[indexPath.row];
    }
}

- (BLUPostDetailAsyncSectionType)sectionTypeOfSection:(NSInteger)section {
    if (section >= self.postDetails.count) {
        return BLUPostDetailAsyncSectionTypeNone;
    }

    BLUPostDetailAsyncSectionType type = NSNotFound;

    NSArray *rows = self.postDetails[section];

    if (rows == self.posts) {
        type = BLUPostDetailAsyncSectionTypePost;
    } else if (rows == self.featuredComments) {
        type = BLUPostDetailAsyncSectionTypeFeaturedComments;
    } else if (rows == [self currentComments]) {
        type = BLUPostDetailAsyncSectionTypeComments;
    }

//    NSAssert(type != NSNotFound, @"Cannot handle this section type.\n"
//                                 @"Section ==> %@\n"
//                                 @"PostDetails ==> %@\n", @(section), self.postDetails);

    return type;
}

- (BLUPostDetailAsyncObjectType)objectTypeOfRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    BLUAssertIndexInCollection(section, self.postDetails);
    NSArray *rows = self.postDetails[section];

    BLUPostDetailAsyncObjectType type = NSNotFound;

    if (self.postDetails.count == 0) {
        NSAssert(NO, @"到这里不可能为空.");
    } else if (self.postDetails.count == 1) {
        if (section == 0) {
            type = BLUPostDetailAsyncObjectTypePost;
        } else {
            type = NSNotFound;
        }
    } else {
        if (rows == self.posts) {
            type = BLUPostDetailAsyncObjectTypePost;
        } else if (rows == [self currentComments] || self.featuredComments) {
            type = BLUPostDetailAsyncObjectTypeComment;
        } else {
            type = NSNotFound;
        }
    }

    NSAssert(type != NSNotFound, @"不能找到正确的对象类型.\n"
                                 @"indexPath ==> %@\n"
                                 @"PostDetails ==> %@\n", indexPath, self.postDetails);
    return type;
}

- (NSString *)titleOfHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    NSAssert(section < self.postDetails.count, @"Section超过了PostDetails的边界\n"
             @"Section ==> %@\n"
             @"PostDetail ==> %@\n", @(section), self.postDetails);

    NSArray *rows = self.postDetails[section];

    if (rows == self.posts) {
        title = nil;
    } else if (rows == self.featuredComments) {
        title = NSLocalizedString(@"post-detail-async-view-model.featured-comments.header",
                                  @"Featured comments");
    } else if (rows == [self currentComments]) {
        title = NSLocalizedString(@"post-detail-async-view-model.all-comments.header",
                                  @"All comments");
    }

    return title;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    BLUAssertIndexInCollection(section, self.postDetails);
    NSArray *rows = self.postDetails[section];
    BLUAssertObjectIsKindOfClass(rows, [NSArray class]);
    if (rows == self.posts) {
        return 2;
    } else {
        return rows.count;
    }
}

- (NSInteger)numberOfSections {
    return self.postDetails.count;
}

- (NSInteger)sectionOfRows:(NSArray *)rows {
    __block NSInteger section = NSNotFound;

    [self.postDetails enumerateObjectsUsingBlock:^(NSArray *i,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
        if (i == rows) {
            section = idx;
            *stop = YES;
        }
    }];
    return section;
}

- (NSMutableArray *)rowsAtSection:(NSInteger)section {
    NSParameterAssert(section >= 0 && section < self.postDetails.count);
    NSMutableArray *rows = self.postDetails[section];
    NSParameterAssert([rows isKindOfClass:[NSMutableArray class]]);
    return rows;
}

- (BOOL)isRowsInPostDetails:(NSArray *)rows {
    for (NSArray *i in self.postDetails) {
        if (i == rows) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)indexPathsOfRows:(NSArray *)rows section:(NSInteger)section {
    NSParameterAssert([rows isKindOfClass:[NSArray class]]);
    NSParameterAssert(section >= 0);

    NSMutableArray *indexPaths = [NSMutableArray new];
    [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                       NSUInteger idx,
                                       BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx
                                                    inSection:section];
        [indexPaths addObject:indexPath];
    }];
    return indexPaths;
}

- (NSArray *)newIndexPathOfRows:(NSMutableArray *)rows
                        newRows:(NSArray *)newRows
                        section:(NSInteger)section{
    NSParameterAssert([rows isKindOfClass:[NSMutableArray class]]);
    NSParameterAssert([rows isKindOfClass:[NSArray class]]);
    NSParameterAssert(section >= 0);

    NSArray *oldIndexPaths = [self indexPathsOfRows:rows section:section];
    NSIndexPath *lastIndexPath = oldIndexPaths.lastObject;
    NSInteger row = 0;
    if (lastIndexPath) {
        row = lastIndexPath.row + 1;
    }
    NSMutableArray *newIndexPaths = [NSMutableArray new];
    [newRows enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                          NSUInteger idx,
                                          BOOL * _Nonnull stop) {
        NSIndexPath *newIndexPath =
        [NSIndexPath indexPathForRow:(idx + row) inSection:section];
        [newIndexPaths addObject:newIndexPath];
    }];
    return newIndexPaths;
}

@end
