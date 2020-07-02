//
//  QGRegisterView.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/18.
//

#import "QGRegisterView.h"

@implementation QGRegisterView
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self p_creatUI];
	}
	return self;
}

- (void)p_creatUI
{
	self.titleLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20,0,70,50)];
		label.font = FONT_SYSTEM(16);
		label.text = @"姓名";
		label.textColor = [UIColor blackColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		label;
	});
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
