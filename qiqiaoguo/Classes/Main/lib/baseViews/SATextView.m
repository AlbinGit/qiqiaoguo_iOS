//
//  SATextView.m
//  SaleAssistant
//
//  Created by Albin on 14-8-26.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SATextView.h"

@implementation SATextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBaseTextView];
    }
    return self;
}

- (void)createBaseTextView
{
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont boldSystemFontOfSize:KAPPTextFont];
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
