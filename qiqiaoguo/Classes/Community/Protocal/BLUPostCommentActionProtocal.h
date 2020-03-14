//
//  BLUPostCommentActionProtocal.h
//  Blue
//
//  Created by Bowen on 7/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUPostCommentActionProtocal.h"

@protocol BLUPostCommentActionDelegate <NSObject>

@required
- (void)shouldLikeComment:(NSDictionary *)commentInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldDislikeComment:(NSDictionary *)commentInfo fromView:(UIView *)view sender:(id)sender;
- (void)shouldShowMoreRepliesForComment:(NSDictionary *)commentInfo formView:(UIView *)view sender:(id)sender;

@end
