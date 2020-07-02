//
//  QGSelImgView.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import "QGSelImgView.h"

@implementation QGSelImgView
{
	BOOL _isSelect;
}
- (instancetype)initWithFrame:(CGRect)frame
{
	if ([super initWithFrame:frame]) {
		[self p_creatUI];
	}
	return self;
}
-(void)p_creatUI
{
	CGFloat selWidth = 80;
	self.selImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, (50-20)/2, 20, 20)];
		img1.image = [UIImage imageNamed:@"ic_未选"];
		img1.userInteractionEnabled = YES;
		[self addSubview:img1];
		img1;
	});
	
	self.label = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_selImgView.right+2,0,58,50)];
		label.font = FONT_SYSTEM(16);
		label.text = @"在校生";
		label.textColor = [UIColor blackColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self addSubview:label];
		label;
	});

	self.selButton = ({
		UIButton * tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tapBtn.backgroundColor = [UIColor clearColor];
		[tapBtn addTarget:self action:@selector(tapBtnClick) forControlEvents:UIControlEventTouchUpInside];
		tapBtn.frame = CGRectMake(0, 0, selWidth, 50);
		[self addSubview:tapBtn];
		tapBtn;
	});

}
- (void)tapBtnClick
{
	if (_selBlock) {
		_selBlock(_isSelect);
	}
}
- (void)chageSelect:(BOOL)isSel
{
	_isSelect = isSel;
	if (isSel) {
		_selImgView.image = [UIImage imageNamed:@"ic_已选"];

	}else
	{
		_selImgView.image = [UIImage imageNamed:@"ic_未选"];

	}
}

@end
