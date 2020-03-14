//
//  BLUCircleFollowedPostNodeDelegate.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUCircle;
@class BLUCircleFollowedPostNode;

@protocol BLUCircleFollowedPostUserInfoNodeDelegate <NSObject>

- (void)shouldShowCircleDetails:(BLUCircle *)circle
                           from:(BLUCircleFollowedPostNode *)node
                         sender:(id)sender;

- (void)shouldShowUserDetails:(BLUUser *)user
                         from:(BLUCircleFollowedPostNode *)node
                       sender:(id)sender;

@end
