//
//  BLUNicknameEditViewController.m
//  Blue
//
//  Created by Bowen on 28/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUNicknameEditViewController.h"

@interface BLUNicknameEditViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSString *nickname;

@end

@implementation BLUNicknameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = [self _done];

    RAC(self, textCountPromptLabel.text) = [self.textFieldContainer.textField.rac_textSignal map:^id(NSString *text) {
        return [NSString stringWithFormat:@"%@ / %@", @(text.length), @(BLUUserNicknameMaxLength)];
    }];
    self.textFieldContainer.textField.delegate = self;
    @weakify(self);
    [self.textFieldContainer.textField.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        if (text.length > BLUUserNicknameMaxLength) {
            self.textFieldContainer.textField.text = [text substringWithRange:NSMakeRange(0, BLUUserNicknameMaxLength - 1)];
        }
    }];
}

- (RACCommand *)_done {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validate] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self _complete];
    }];
}

- (RACSignal *)_validate {
    @weakify(self);
    return [self.textFieldContainer.textField.rac_textSignal map:^id(NSString *nickname) {
        @strongify(self);
        return @([nickname isNickname] && ![nickname isEqualToString:self.text]);
    }];
}

- (RACSignal *)_complete {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(textEditViewController:didEditText:)]) {
                [self.delegate textEditViewController:self didEditText:self.textFieldContainer.textField.text];
                [subscriber sendNext:self.textFieldContainer.textField.text];
                [subscriber sendCompleted];
            } else {
                NSError *error = [NSError errorWithDomain:NSStringFromClass([BLUNicknameEditViewController class]) code:-1 description:@"Data return error" reason:nil];
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= BLUUserNicknameMaxLength;
}

@end
