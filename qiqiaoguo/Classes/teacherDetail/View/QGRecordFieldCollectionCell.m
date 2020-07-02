//
//  QGRecordFieldCollectionCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import "QGRecordFieldCollectionCell.h"

@implementation QGRecordFieldCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
//		self.backgroundColor = [UIColor greenColor];
		[self p_creatUI];
	}
	return self;
}
- (void)p_creatUI
{
	self.imgView = ({
		UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-30-15)/2, 108)];
		img.backgroundColor = [UIColor whiteColor];
		img.contentMode = UIViewContentModeScaleAspectFill;
		img.clipsToBounds = YES;
		[self.contentView addSubview:img];
		img;
	});
	
	UIView * blackView = [[UIView alloc]initWithFrame:CGRectMake(_imgView.width-5-83, _imgView.height-5-18, 83, 18)];
	blackView.backgroundColor = [UIColor blackColor];
	blackView.alpha = 0.5;
	blackView.layer.cornerRadius = 9;
	[self.imgView addSubview:blackView];
	
//	UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 7, 8)];
//	img.userInteractionEnabled = YES;
//	img.image = [UIImage imageNamed:@"ic_视频学习"];
//	[blackView addSubview:img];

	self.titleLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 83,18)];
		label.font = FONT_SYSTEM(11);
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		[blackView addSubview:label];
		label;
	});


}
@end
