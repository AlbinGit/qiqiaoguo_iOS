//
//  SASearchBar.m
//  SaleAssistant
//
//  Created by Albin on 14-11-6.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SASearchBar.h"

@implementation SASearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSearchBar];
    }
    return self;
}

- (void)createSearchBar
{
    for (UIView *view in self.subviews)
    {
        if(PL_UTILS_IOS7)
        {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
            }
        }
        else
        {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                
            }
        }
    }
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = PL_UTILS_COLORRGB_CG(220, 220, 220);
    self.layer.masksToBounds = YES;
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
