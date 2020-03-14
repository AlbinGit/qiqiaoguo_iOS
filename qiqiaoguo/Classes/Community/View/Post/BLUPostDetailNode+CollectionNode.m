//
//  BLUPostDetailNode+CollectionNode.m
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailNode+CollectionNode.h"
#import "BLUPost.h"
#import "BLUPostDetailLikedUserNode.h"

@implementation BLUPostDetailNode (CollectionNode)

//- (NSInteger)collectionView:(UICollectionView *)collectionView
//     numberOfItemsInSection:(NSInteger)section {
//    return self.post.likedUsers.count;
//}
//
//- (ASCellNode *)collectionView:(ASCollectionView *)collectionView
//        nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    BLUPostDetailLikedUserNode *node = [[BLUPostDetailLikedUserNode alloc] initWithUser:self.post.likedUsers[indexPath.row]];
//    node.preferredFrameSize = CGSizeMake(24, 24);
//    return node;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView
//didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if ([self.delegate
//         respondsToSelector:
//         @selector(shouldShowUserDetail:from:sender:)]) {
//        [self.delegate shouldShowUserDetail:self.post.likedUsers[indexPath.row]
//                                       from:self
//                                     sender:[collectionView cellForItemAtIndexPath:indexPath]];
//    }
//}

@end
