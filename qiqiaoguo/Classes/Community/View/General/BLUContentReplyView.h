//
//  BLUContentReplyView.h
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUContentReplyViewDelegate.h"

@class BLUTextView;

@interface BLUContentReplyView : UIToolbar <UITextViewDelegate>

@property (nonatomic, strong) BLUTextView *textView;
@property (nonatomic, strong) UIButton *promptButton;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) UIImage *promptImage;

@property (nonatomic, weak) id <BLUContentReplyViewDelegate> replyDelegate;

- (void)clear;
- (void)resignFirstResponder;
- (void)becomeFirstResponder;
- (CGFloat)textViewHeight;
- (CGFloat)contentVerticalMargin;
- (CGFloat)contentHorizonMargin;

@end
