//
//  QGaddFooterView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGaddFooterView.h"

@implementation QGaddFooterView

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
    sepertView1.backgroundColor = [UIColor colorFromHexString:@"e1e1e1"];
    sepertView1.frame = CGRectMake( titleX-130, 29, titleW, 1);
    [self addSubview:sepertView1];
    
    _title = [SALabel createLabelWithRect:CGRectMake( titleX-90 , 5, 180, 50) andWithColor:QGCellContentColor andWithFont:13 andWithAlign:NSTextAlignmentCenter andWithTitle:nil];
    [self addSubview:_title];
    
    UIView *sepertView2 = [[UIView alloc]init];
    sepertView2.backgroundColor = [UIColor colorFromHexString:@"e1e1e1"];
    sepertView2.frame = CGRectMake( titleX +90, 29, titleW, 1);
    [self addSubview:sepertView2];
    
}

@end
