//
//  BLUTableView.m
//  Blue
//
//  Created by Bowen on 30/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUTableView.h"

@interface BLUTableView ()

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation BLUTableView

#pragma mark - Manage Cache

- (NSMutableDictionary *)cache {
    if (_cache == nil) {
        _cache = [NSMutableDictionary new];
    }
    return _cache;
}

- (CGSize)_getCachedSizeForIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width {
    NSCache *cellCache = [self.cache objectForKey:@(width)];
    if (!cellCache) {
        cellCache = [NSCache new];
        [self.cache setObject:cellCache forKey:@(width)];
    }
    NSValue *sizeValue = [cellCache objectForKey:indexPath];
    return [sizeValue CGSizeValue];
}

- (void)_setCachedSize:(CGSize)size forIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width {
    NSCache *cellCache = [self.cache objectForKey:@(width)];
    if (!cellCache) {
        cellCache = [NSCache new];
        [self.cache setObject:cellCache forKey:@(width)];
    }
    NSValue *sizeValue = [NSValue valueWithCGSize:size];
    [cellCache setObject:sizeValue forKey:indexPath];
}

- (BOOL)_isCachedSizeExistForIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width {
    
    NSCache *cellCache = [self.cache objectForKey:@(width)];
    if (!cellCache) {
        cellCache = [NSCache new];
        [self.cache setObject:cellCache forKey:@(width)];
    }
    
    id object = [cellCache objectForKey:indexPath];
    if (object != nil && object != [NSNull null]) {
        return YES;
    }
    return NO;
}

- (CGSize)sizeForCellWithCellClass:(Class)cellClass cacheByIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width configuration:(void (^)(BLUCell *cell))configuration {
    CGSize size = CGSizeZero;
    if ([self _isCachedSizeExistForIndexPath:indexPath width:width]) {
        size = [self _getCachedSizeForIndexPath:indexPath width:width];
    } else {
        BLUCell *cell = [cellClass sharedCell];
        cell.cellForCalcingSize = YES;
        if (configuration) {
            configuration(cell);
        }
        size = [cellClass sizeForLayoutedCellWith:width sharedCell:cell];
        [self _setCachedSize:size forIndexPath:indexPath width:width];
    }
    return size;
}

- (CGSize)sizeForCellWithCellClass:(Class)cellClass cacheByIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width model:(id)model {
    return [self sizeForCellWithCellClass:cellClass cacheByIndexPath:indexPath width:width configuration:^(BLUCell *cell) {
        cell.model = model;
    }];
}

- (void)clearCache {
    [self.cache removeAllObjects];
}

#pragma mark - Override Method

- (BOOL)fd_autoCacheInvalidationEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)reloadData {
    [self clearCache];
    [super reloadData];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self clearCache];
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)reloadSectionIndexTitles {
    [self clearCache];
    [super reloadSectionIndexTitles];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self clearCache];
    [super reloadSections:sections withRowAnimation:animation];
}

- (void)setReloadDataBlock:(void (^)(NSInteger))reloadDataBlock {
    [self clearCache];
    [self setReloadDataBlock:reloadDataBlock];
}

// TODO: 需要优化
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self clearCache];
    [super insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self clearCache];
    [super deleteSections:sections withRowAnimation:animation];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self clearCache];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self clearCache];
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

@end
