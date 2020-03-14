//
//  BLUContentReplyViewDelegate.h
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUContentReplyView;

@protocol BLUContentReplyViewDelegate <NSObject>

- (BOOL)shouldEnableSendContent:(NSString *)content
                   fomReplyView:(BLUContentReplyView *)replyView;

- (void)shouldSendContent:(NSString *)content
            fromReplyView:(BLUContentReplyView *)replyView;

@end
