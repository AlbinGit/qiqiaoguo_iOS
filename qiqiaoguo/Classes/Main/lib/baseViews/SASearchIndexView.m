//
//  SASearchIndexView.m
//  SaleAssistant
//
//  Created by Albin on 14-11-5.
//  Copyright (c) 2014年 platomix. All rights reserved.
//


#import "SASearchIndexView.h"

@interface SASearchIndexView ()

@property (nonatomic,copy)SASearchIndexViewLabelClickBlock click;

@end

@implementation SASearchIndexView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadIndexView
{
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    
    CGFloat height = (CGFloat)self.height / (CGFloat)[_indexArray count];
    
    int i = 0;
    for(i = 0;i < [_indexArray count];i++)
    {
        SALabel *indexLabel = [[SALabel alloc]init];
        indexLabel.tag = i + 5000;
        indexLabel.frame = CGRectMake(0, i * height, self.width, height);
        indexLabel.textColor = PL_UTILS_COLORRGB(108, 108, 108);
        indexLabel.text = _indexArray[i];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        [self addSubview:indexLabel];
        PL_CODE_WEAK(weakSelf)
        // 点击索引
        [indexLabel addClick:^(SALabel *label) {
            weakSelf.click(label);
        }];
    }
}

- (void)searchIndexViewLabelClick:(SASearchIndexViewLabelClickBlock)click
{
    _click = click;
}

- (void)setIndexArray:(NSMutableArray *)indexArray
{
    if(_indexArray != indexArray)
    {
        _indexArray = indexArray;
        [self loadIndexView];
    }
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
