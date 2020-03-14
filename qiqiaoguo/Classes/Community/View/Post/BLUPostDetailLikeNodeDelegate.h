//
//  BLUPostDetailLikeNodeDelegate.h
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPostDetailLikeNode;
@class BLUPost;

@protocol BLUPostDetailLikeNodeDelegate <NSObject>

- (void)shouldChangeLikeStateForPost:(BLUPost *)post
                                from:(BLUPostDetailLikeNode *)node
                              sender:(id)sender;

- (void)shouldShowUserDetailsForUser:(BLUUser *)user
                                from:(BLUPostDetailLikeNode *)node
                              sender:(id)sender;

- (void)shouldShowLikedUsersForPost:(BLUPost *)post
                               from:(BLUPostDetailLikeNode *)node
                             sender:(id)sender;

@end
