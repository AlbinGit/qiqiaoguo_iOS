//
//  BLUShareManager.h
//  Blue
//
//  Created by Bowen on 4/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGSocialService.h"
#import "BLUShareManagerDelegate.h"
#import "BLUShareObject.h"

@class BLUPost;

@interface BLUShareManager : NSObject

@property (nonatomic, weak) id <BLUShareManagerDelegate> delegate;
@property (nonatomic, weak) UIViewController *presentedViewController;

- (void)shareContentWithObject:(id <BLUShareObject>)shareObject shareType:(BLUShareType)shareType;
- (void)copyURLToPasteboardWithShareObject:(id <BLUShareObject>)post;

@end

@interface BLUViewController (BLUShareManager)
<BLUShareManagerDelegate>

@end
