//
//  customProgressView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import "customProgressView.h"
@implementation customProgressView

- (id)initWithFrame:(CGRect)frame withTheProgress:(float)progress
{
    self =[super initWithFrame:frame];
    if (self)
    {
        _progress=progress;
        [self createCustomProgressView];
    }
    return self;
}
- (void)createCustomProgressView
{
   
    UILabel *bgLab=[[UILabel alloc]init];
    bgLab.tag=10;
    [self addSubview:bgLab];
    
    UILabel *lab=[[UILabel alloc]init];
    lab.tag=20;
    lab.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    lab.textAlignment= NSTextAlignmentRight;
    [self addSubview:lab];
}
- (void)setProgressViewBackGroundCorlor:(UIColor *)progressViewBackGroundCorlor
{
    self.backgroundColor=progressViewBackGroundCorlor;
}
- (void)setProgressViewCorlor:(UIColor *)progressViewCorlor
{
    UILabel *bglab=(UILabel *)[self viewWithTag:10];
    bglab.backgroundColor=progressViewCorlor;
}
- (void)setProgressViewBorderColor:(UIColor *)progressViewBorderColor
{
    self.layer.borderWidth=0.1;
    self.layer.borderColor=progressViewBorderColor.CGColor;
    kRadius(self);
}
- (void)setProgressViewFillContentLab:(NSString *)progressViewFillContentLab
{
    UILabel *lab=(UILabel *)[self viewWithTag:20];
    lab.text=progressViewFillContentLab;

}
- (void)setProgressViewFillLabFont:(UIFont *)progressViewFillLabFont
{
    UILabel *lab=(UILabel *)[self viewWithTag:20];
    lab.font=progressViewFillLabFont;
}
- (void)setProgress:(float)progress
{
    UILabel *lab=(UILabel *)[self viewWithTag:10];
    float width=self.frame.size.width*progress;
    lab.frame=CGRectMake(0, 0, width, self.frame.size.height);
}
@end
