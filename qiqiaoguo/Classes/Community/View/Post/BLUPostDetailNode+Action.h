//
//  BLUPostDetailNode+Action.h
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailNode.h"

@interface BLUPostDetailNode (Action)

- (void)addActionToTextNode:(ASTextNode *)node;
- (void)addActionToImageNode:(ASNetworkImageNode *)imageNode;
- (void)touchAndRedirectToWeb:(id)sender;
- (void)touchAndRedirectToPost:(id)sender;
- (void)touchAndRedirectToCircle:(id)sender;
- (void)touchAndPlayVideo:(id)sender;
- (void)touchAndShowImage:(id)sender;
- (void)touchAndChangeLikeStatePost:(id)sender;
- (void)touchAndShowUserDetails:(id)sender;
- (void)touchAndShowLikedUsers:(id)sender;

@end
