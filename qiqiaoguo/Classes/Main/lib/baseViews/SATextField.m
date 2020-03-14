//
//  SATextField.m
//  ToysOnline
//
//  Created by Albin on 14-8-20.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SATextField.h"

@implementation SATextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBaseTextField];
    }
    return self;
}

- (void)createBaseTextField
{    
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; // 垂直居中
    self.font = [UIFont boldSystemFontOfSize:KAPPTextFont];
}

- (void)addInputAccessoryView
{
    self.keyboardType = UIKeyboardTypeNumberPad;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor = PL_UTILS_COLORRGB(246, 246, 246);
    SAButton *doneBtn = [SAButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(260, 0, 50, 50);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:PL_UTILS_COLORRGB(12, 89, 244) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [view addSubview:doneBtn];
    self.inputAccessoryView = view;
}

- (void)doneClick:(SAButton *)btn
{
    [self resignFirstResponder];
}


- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(5, 0, bounds.size.width - 5, bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(5, 0, bounds.size.width - 5, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(5, 0, bounds.size.width - 5, bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
