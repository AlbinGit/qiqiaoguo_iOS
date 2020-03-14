//
//  BLUPostDetailAsyncViewController+Reply.m
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController+Reply.h"
#import "BLUPostDetailAsyncViewModel+CommentInteraction.h"
#import "BLUContentReplyView.h"
#import "BLUPostDetailAsyncViewController.h"

@implementation BLUPostDetailAsyncViewController (Reply)

- (BOOL)shouldEnableSendContent:(NSString *)content
                   fomReplyView:(BLUContentReplyView *)replyView {
    return [[content stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceCharacterSet]] length] > 0;
}

- (void)shouldSendContent:(NSString *)content
            fromReplyView:(BLUContentReplyView *)replyView {
    [self.viewModel replyToPostWithContent:content];
}

- (void)keyboardChanged:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    CGRect keyboardBeginFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];

    if (notification.name == UIKeyboardWillShowNotification) {
        self.tableView.userInteractionEnabled = NO;
    } else {
        self.tableView.userInteractionEnabled = YES;
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (notification.name == UIKeyboardWillShowNotification) {
            CGFloat offset = keyboardEndFrame.size.height;
            make.bottom.equalTo(self.view).offset(-offset);
        } else {
            make.top.equalTo(self.view.mas_bottom);
        }
    }];

    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

@end
