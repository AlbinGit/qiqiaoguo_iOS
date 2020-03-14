//
//  SAView.m
//  SaleAssistant
//
//  Created by Albin on 14-8-25.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAView.h"

@implementation SAView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = CLEARCOLOR;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"---->%@",NSStringFromClass([self class]));
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
