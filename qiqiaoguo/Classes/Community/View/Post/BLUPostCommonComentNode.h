//
//  BLUPostNodeCommentNode.h
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASControlNode.h"

@interface BLUPostCommonComentNode : ASControlNode

@property (nonatomic, strong) ASImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *countNode;

@property (nonatomic, assign) NSInteger comentsCount;

- (instancetype)initWithComentsCount:(NSInteger)comentsCount;

@end
