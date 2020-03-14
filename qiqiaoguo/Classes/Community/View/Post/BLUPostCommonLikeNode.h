//
//  BLUPostCommonLikeNode.h
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASControlNode.h"

@interface BLUPostCommonLikeNode : ASControlNode

@property (nonatomic, strong) ASImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *countNode;

@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) NSInteger likesCount;

- (instancetype)initWithLikesCount:(NSInteger)likesCount liked:(BOOL)liked;

@end
