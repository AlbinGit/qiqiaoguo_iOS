

//
//  QGCategroyHeardView.m
//  LongForTianjie
//
//  Created by xiaoliang on 15/6/29.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "QGCategroyHeardView.h"




@implementation QGCategroyHeardView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{
    CGFloat titleX =self.centerX ;
    
    CGFloat titleW = 40 ;
    self.backgroundColor = RGB(239, 239, 240);
    UIView *sepertView1 = [[UIView alloc]init];
    sepertView1.backgroundColor = PL_COLOR_200;
    sepertView1.frame = CGRectMake( titleX-90, 37, titleW, 1);
    [self addSubview:sepertView1];
    
    _title = [SALabel createLabelWithRect:CGRectMake( titleX-50 , 15, 100, 50) andWithColor:PL_COLOR_30 andWithFont:15 andWithAlign:NSTextAlignmentCenter andWithTitle:nil];
    [self addSubview:_title];
    
    UIView *sepertView2 = [[UIView alloc]init];
    sepertView2.backgroundColor = PL_COLOR_200;
    sepertView2.frame = CGRectMake( titleX +50, 37, titleW, 1);
    
    [self addSubview:sepertView2];
    
}

@end
