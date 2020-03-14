//
//  BLUTextEditViewController.h
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@class BLUTextEditViewController;

@protocol BLUTextEditViewControllerDelegate <NSObject>

@required
- (void)textEditViewController:(BLUTextEditViewController *)textEditViewController didEditText:(NSString *)text;

@end

@interface BLUTextEditViewController : BLUViewController

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) BLUTextFieldContainer *textFieldContainer;
@property (nonatomic, weak) id <BLUTextEditViewControllerDelegate> delegate;

@property (nonatomic, strong) UILabel *textCountPromptLabel;
@property (nonatomic, strong) UIView *promptContainer;

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text;

@end
