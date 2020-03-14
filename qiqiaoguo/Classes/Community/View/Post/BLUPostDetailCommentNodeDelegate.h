//
//  ASPostDetailCommentNodeDelegate.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPost;
@class BLUPostTag;
@class BLUCircle;
@class BLUUser;
@class BLUComment;
@class BLUPostDetailCommentNode;
@class BLUCommentReply;

@protocol BLUPostDetailCommentNodeDelegate <NSObject>

- (void)shouldUpdateLikeStateForComment:(BLUComment *)comment
                                   from:(BLUPostDetailCommentNode *)node
                                 sender:(id)sender;

- (void)shouldShowUserDetailForUser:(BLUUser *)user
                               from:(BLUPostDetailCommentNode *)node
                             sender:(id)sender;

@end
