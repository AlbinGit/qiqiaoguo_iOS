//
//  BLUSendPost2ViewController+Text.h
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController.h"

@interface BLUSendPost2ViewController (Text) <UITextFieldDelegate, UITextViewDelegate>

- (void)insertImageToContentTextView:(UIImage *)image;
- (void)textFieldDidChanged:(NSNotification *)notification;

@end
