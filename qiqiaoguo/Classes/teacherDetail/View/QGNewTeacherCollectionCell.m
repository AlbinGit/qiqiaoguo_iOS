//
//  QGNewTeacherCollectionCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/3.
//

#import "QGNewTeacherCollectionCell.h"
@interface QGNewTeacherCollectionCell ()
@property (nonatomic,strong) UIImageView *imgView;
@end

@implementation QGNewTeacherCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		[self p_creatUI];
	}
	return self;
}
- (void)p_creatUI
{
	self.imgView = ({
		UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-6*2-30)/3, 111)];
		img.contentMode = UIViewContentModeScaleAspectFill;
		img.clipsToBounds = YES;
		[self.contentView addSubview:img];
		img;
	});
}
- (void)setImgUrl:(NSString *)imgUrl
{
	_imgUrl = imgUrl;	
	[_imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
}

@end
