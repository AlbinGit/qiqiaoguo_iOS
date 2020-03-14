//
//  BLUPostTitleCell.h
//  Blue
//
//  Created by Bowen on 11/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUCircleTransitionProtocal.h"

@class BLUPostTitleCell, BLUPost;

@protocol BLUPostTitleCellDelegate <NSObject>

@optional
- (void)postTitleCell:(BLUPostTitleCell *)cell didCommentPost:(BLUPost *)post;

@end

@interface BLUPostTitleCell : BLUCell

@property (nonatomic, weak) id <BLUPostTitleCellDelegate> delegate;
@property (nonatomic, weak) id <BLUCircleTransitionDelegate> circleTransitionDelegate;

@end
