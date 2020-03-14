//
//  BLUContentReplyView.m
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUContentReplyView.h"
#import "BLUTextView.h"

@implementation BLUContentReplyView

- (instancetype)init {
    if (self = [super init]) {
        [self layoutIfNeeded];
        _textView = [BLUTextView new];
        _textView.cornerRadius = BLUThemeHighActivityCornerRadius;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.textColor = [UIColor blackColor];
        _textView.font = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);

        _promptButton = [UIButton new];
        [_promptButton setImage:[UIImage imageNamed:@"content-reply-view-reward"]
                       forState:UIControlStateNormal];

        _sendButton = [UIButton new];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:BLUThemeMainColor]
                               forState:UIControlStateNormal];
        _sendButton.cornerRadius = BLUThemeNormalActivityCornerRadius;
        NSString *title = NSLocalizedString(@"content-reply-view.send-title",
                                            @"Send");
        
        NSAttributedString *attributedSend = [self attributedSend:title];
        [_sendButton setAttributedTitle:attributedSend
                               forState:UIControlStateNormal];
        UIEdgeInsets sendButtonContentInsets = _sendButton.contentEdgeInsets;
        sendButtonContentInsets.top += BLUThemeMargin * 1.5;
        sendButtonContentInsets.bottom += BLUThemeMargin * 1.5;
        sendButtonContentInsets.left += BLUThemeMargin * 3;
        sendButtonContentInsets.right += BLUThemeMargin * 3;
        _sendButton.contentEdgeInsets = sendButtonContentInsets;
        [_sendButton addTarget:self
                        action:@selector(tapAndSend:)
              forControlEvents:UIControlEventTouchUpInside];
        _sendButton.enabled = NO;

        [self addSubview:_textView];
        [self addSubview:_promptButton];
        [self addSubview:_sendButton];

        self.clipsToBounds = YES;
        self.translucent = YES;
        self.barTintColor = [UIColor colorFromHexString:@"ebebeb"];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([self contentVerticalMargin]);
        make.left.equalTo(self).offset([self contentHorizonMargin]);
        make.right.equalTo(self).offset(-[self contentHorizonMargin]);
        make.height.equalTo(@([self textViewHeight]));
    }];

    [_promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self.textView mas_bottom]).offset([self contentVerticalMargin] + BLUThemeMargin);
        make.left.equalTo(self.textView.mas_left);
    }];

    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.promptButton.mas_centerY);
        make.right.equalTo(self).offset(-[self contentHorizonMargin]);
        make.bottom.equalTo(self).offset(-[self contentVerticalMargin]);
    }];

    [super updateConstraints];
}

- (void)tapAndSend:(UIButton *)button {
    if ([self.replyDelegate
         respondsToSelector:@selector(shouldSendContent:fromReplyView:)]) {
        [self.replyDelegate shouldSendContent:_textView.text fromReplyView:self];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    _textView.placeholder = placeHolder;
}

- (void)setPrompt:(NSString *)prompt {
    _prompt = prompt;
    [_promptButton setAttributedTitle:[self attributedPrompt:_prompt]
                             forState:UIControlStateNormal];
}

- (void)setPromptImage:(UIImage *)promptImage {
    _promptImage = promptImage;
    [_promptButton setImage:promptImage forState:UIControlStateNormal];
}


- (void)checkContent {
    if ([self.replyDelegate
         respondsToSelector:@selector(shouldEnableSendContent:fomReplyView:)]) {
        _sendButton.enabled =
        [self.replyDelegate shouldEnableSendContent:_textView.text
                                       fomReplyView:self];
    }
}

- (void)clear {
    [_textView resignFirstResponder];
    _textView.text = @"";
    [self checkContent];
}

- (void)becomeFirstResponder {
    [_textView becomeFirstResponder];
}

- (void)resignFirstResponder {
    [_textView resignFirstResponder];
}

- (CGFloat)textViewHeight {
    return 64.0;
}

- (CGFloat)contentVerticalMargin {
    return BLUThemeMargin * 2;
}

- (CGFloat)contentHorizonMargin {
    return BLUThemeMargin * 4;
}

- (NSAttributedString *)attributedPrompt:(NSString *)prompt {
    prompt = [NSString stringWithFormat:@" %@", prompt];
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:
          [UIColor colorWithHue:0.58 saturation:0.01 brightness:0.66 alpha:1],
      NSFontAttributeName:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};
    return
    [[NSAttributedString alloc] initWithString:prompt
                                    attributes:attributed];
}

- (NSAttributedString *)attributedSend:(NSString *)send {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeNormal)};
    return
    [[NSAttributedString alloc] initWithString:send
                                    attributes:attributed];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self checkContent];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self checkContent];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//    if([text isEqualToString:@"\n"]) {
//        if ([self.replyDelegate
//             respondsToSelector:@selector(shouldSendContent:fromReplyView:)]) {
//            [self.replyDelegate shouldSendContent:_textView.text fromReplyView:self];
//        }
//        return NO;
//    }
//
//    return YES;
//}

@end
