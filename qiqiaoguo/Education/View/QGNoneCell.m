
//
//  QGNoneCell.m
//  LongForTianjie
//
//  Created by xiaoliang on 15/6/30.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "QGNoneCell.h"

@implementation QGNoneCell
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
    SALabel *label = [SALabel createLabelWithRect:CGRectMake(0, 0, 100, 20) andWithColor:[UIColor grayColor] andWithFont:15 andWithAlign:NSTextAlignmentCenter andWithTitle:@"暂无商品"];
    [self.contentView addSubview:label];
    //[self.contentView setBackgroundColor:[UIColor redColor]];
}
@end
