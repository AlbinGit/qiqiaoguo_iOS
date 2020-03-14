//
//  BLUPostCommentToolBar.m
//  Blue
//
//  Created by Bowen on 12/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPostCommentToolbar.h"
#import "BLUComment.h"

@interface BLUPostCommentToolbar () <UITextFieldDelegate>

@property (nonatomic, strong) NSString *comment;

@end

@implementation BLUPostCommentToolbar

- (instancetype)init {
    if (self = [super init]) {
        [self _config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _config];
    }
    return self;
}

- (void)_config {

    self.clipsToBounds = YES;
    UIView *superview = self;
    superview.backgroundColor = BLUThemeMainTintBackgroundColor;

    // Send button
    _sendButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
//    _sendButton.contentEdgeInsets = UIEdgeInsetsMake([BLUCurrentTheme topMargin], [BLUCurrentTheme leftMargin], [BLUCurrentTheme bottomMargin], [BLUCurrentTheme rightMargin]);
    _sendButton.rac_command = [self _send];
    _sendButton.titleFont = [UIFont systemFontOfSize:13];
    _sendButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin * 2.0, BLUThemeMargin * 4 + 2, BLUThemeMargin * 2.0, BLUThemeMargin * 4 + 2);
    _sendButton.backgroundColor = [UIColor whiteColor];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:APPBackgroundColor] forState:UIControlStateDisabled];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:QGMainRedColor] forState:UIControlStateNormal];
    _sendButton.borderColor = [UIColor clearColor];
    _sendButton.borderWidth = 0.0;
    _sendButton.titleColor = [UIColor whiteColor];
    [_sendButton setTitleColor:QGCellbottomLineColor forState:UIControlStateDisabled];
    [superview addSubview:_sendButton];
    
    // Text text field
    _textField = [UITextField new];
    _textField.cornerRadius = [BLUCurrentTheme normalActivityCornerRadius];
    _textField.delegate = self;
    _textField.layer.sublayerTransform = CATransform3DMakeTranslation(BLUThemeMargin * 2, 1, 0);
    _textField.backgroundColor = BLUThemeMainTintBackgroundColor;
    _textField.font = _sendButton.titleFont;
    _textField.returnKeyType = UIReturnKeySend;
    [superview addSubview:_textField];
   
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).offset(BLUThemeMargin * 2);
        make.centerY.equalTo(superview);
        make.height.equalTo(_sendButton);
    }];
   
    [_sendButton setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [_sendButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview);
        make.right.equalTo(superview).offset(-[BLUCurrentTheme rightMargin] * 2);
        make.left.equalTo(_textField.mas_right).offset([BLUCurrentTheme leftMargin] * 2);
    }];
    
    // TEST
    _sendButton.title = NSLocalizedString(@"post-comment-toolbar.send-button.title.send", @"Send");

    [self.textField.rac_textSignal subscribeNext:^(id x) {
        NSString *str = x;
        BOOL Enabled = str.length > 0;
        self.sendButton.enabled = Enabled;
    }];

    
    self.clipsToBounds = YES;
    self.translucent = YES;
    self.barTintColor = [UIColor colorFromHexString:@"c9c9c9"];
}

- (RACCommand *)_send {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validateComment] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            if ([self.postCommentToolbarDelegate respondsToSelector:@selector(toolbar:didSendComment:)]) {
                [self.postCommentToolbarDelegate toolbar:self didSendComment:self.textField.text];
                [self.textField resignFirstResponder];
                [subscriber sendCompleted];
            }
            return nil;
        }];
    }];
}

- (RACSignal *)_validateComment {
    return [BLUComment validateCommentContent:RACObserve(self, comment)];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.comment = [textField.text stringByReplacingCharactersInRange:range withString:string];

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.postCommentToolbarDelegate respondsToSelector:@selector(toolbar:didSendComment:)]) {
        [self.postCommentToolbarDelegate toolbar:self didSendComment:self.textField.text];
        self.textField.text = @"";
        self.comment = @"";
        [self.textField resignFirstResponder];
    }
    return YES;
}

@end
