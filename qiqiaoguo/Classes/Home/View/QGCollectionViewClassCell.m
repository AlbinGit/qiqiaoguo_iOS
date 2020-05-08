//
//  QGCollectionViewClassCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/8.
//

#import "QGCollectionViewClassCell.h"

@interface QGCollectionViewClassCell()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation QGCollectionViewClassCell
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
		UILabel * label = [[UILabel alloc]init];
		label.frame = CGRectMake(0, 0, (SCREEN_WIDTH-60)/3, 50);
		label.textAlignment = NSTextAlignmentCenter;
		label.text = @"小班";
		label.layer.masksToBounds = YES;
		label.layer.cornerRadius = 5;
		label.textColor = PL_COLOR_black;
		label.backgroundColor = PL_COLOR_230;
		[self.contentView addSubview:label];
		label;
	});
}
- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	if (selected) {
		self.titleLabel.backgroundColor = [UIColor redColor];
		self.titleLabel.textColor = [UIColor whiteColor];
	}else
	{
		self.titleLabel.backgroundColor = PL_COLOR_230;
		self.titleLabel.textColor = PL_COLOR_black;
	}
}
@end
