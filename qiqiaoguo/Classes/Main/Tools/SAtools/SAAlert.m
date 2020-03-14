//
//  SAAlert.m
//  SaleAssistant
//
//  Created by Albin on 14-10-31.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAAlert.h"

@interface SAAlert ()
@property (nonatomic,copy)SAAlertConfirmBlock confirm;
@property (nonatomic,copy)SAAlertCancelBlock cancel;
@end

@implementation SAAlert

static SAAlert *_shareInstance = nil;
+ (SAAlert *)sharedInstance
{
    @synchronized(self)
    {
        if (!_shareInstance){
            _shareInstance = [[SAAlert alloc]init];
        }
    }
    return _shareInstance;
}

- (void)confirmClick:(SAAlertConfirmBlock)confirm
{
    _confirm = confirm;
}

- (void)cancelClick:(SAAlertCancelBlock)cancel
{
    _cancel = cancel;
}

// 确定
- (void)showAlertWithOnlyTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc]init];
    [alert setTitle:title];
    [alert addButtonWithTitle:@"确定"];
    [alert show];
}

- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message otherTitle:(NSString *)otherTitle
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:otherTitle, nil];
    [alert show];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherTitle:(NSString *)otherTitle
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitle, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if(_cancel)
        {
            _cancel();
        }
    }
    else if(buttonIndex == 1)
    {
        if(_confirm)
        {
            _confirm();
        }
    }
}

@end
