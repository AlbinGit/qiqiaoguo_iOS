//
//  BLUCircleFollowedPostUserInfoNodeDelegate.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUCircleFollowedPostUserInfoNode;
@class BLUCircle;

@protocol BLUCircleFollowedPostUserInfoNodeDelegate2 <NSObject>

- (void)shouldChangeFollowStateForUser:(BLUUser *)user
                                  from:(BLUCircleFollowedPostUserInfoNode *)node
                                sender:(id)sender;


@end
