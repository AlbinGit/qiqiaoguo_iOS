//
//  CVDownloadProgressView.m
//  ChinaVoice
//
//  Created by 史志杰 on 2018/4/18.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import "QGstudyProgressView.h"
#define kLineWidth 3
#define PL_COLOR_RGB(r,g,b)  [[UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1] CGColor];

@interface QGstudyProgressView()
@property (nonatomic,strong)CAShapeLayer *progressLayer;
@end
@implementation QGstudyProgressView
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		[self p_createUI:self.bounds];
	}
	return self;
}
- (instancetype)initWithFrame:(CGRect)frame 
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[self p_createUI:frame];
	}
	return self;
}

- (void)p_createUI:(CGRect)frame
{
	self.alpha = 0;
	[self p_createMainView:frame];
	[self p_showprogressView];
}

//圆形
- (void)p_createMainView:(CGRect)frame
{
	//进度条
	UIView *progressView = [[UIView alloc]init];
	progressView.frame = CGRectMake(0, 0, self.width, self.height);
	[self addSubview:progressView];
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	//    [path addArcWithCenter:CGPointMake(progressView.width / 2, progressView.height / 2) radius:(progressView.width - kLineWidth) / 2 startAngle:-(M_PI / 2) endAngle:M_PI * (2 - 0.5) clockwise:YES];
	
	//这个路径后面减前边等于2M_PI就是个圆了
//	[path addArcWithCenter:CGPointMake(progressView.width / 2, progressView.height / 2) radius:(progressView.width - kLineWidth) / 2 startAngle:(M_PI / 2) endAngle:2.5*M_PI clockwise:YES];
	
	[path addArcWithCenter:CGPointMake(progressView.width / 2, progressView.height / 2) radius:(progressView.width - kLineWidth) / 2 startAngle:1.5*M_PI endAngle:3.5*M_PI clockwise:YES];

	CAShapeLayer *trackLayer = [CAShapeLayer layer];
	trackLayer.frame = progressView.bounds;
	trackLayer.path = path.CGPath;
	trackLayer.lineWidth = kLineWidth;
//	trackLayer.strokeColor = PL_COLOR_RGB(231, 231, 231);
//	trackLayer.strokeColor = HEXColor(@"E5E5E5").CGColor;
	trackLayer.strokeColor = [UIColor colorFromHexString:@"E5E5E5"].CGColor;

	trackLayer.fillColor = [[UIColor clearColor] CGColor];
	[progressView.layer addSublayer:trackLayer];
	
	_progressLayer = [CAShapeLayer layer];
	_progressLayer.frame = progressView.bounds;
	_progressLayer.path = path.CGPath;
	_progressLayer.strokeEnd = 0.0;
	_progressLayer.lineWidth = kLineWidth;
//	_progressLayer.strokeColor = HEXColor(@"008FEF").CGColor;
	_progressLayer.strokeColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;

	_progressLayer.fillColor = [[UIColor clearColor] CGColor];
	[progressView.layer addSublayer:_progressLayer];
}



- (void)setProgress:(CGFloat)progress
{
	_progress = progress;
	//CATransaction动画
	[CATransaction begin];
	[CATransaction setAnimationDuration:0.001];
	if (progress >= 1.0)
	{
		[CATransaction setCompletionBlock:^{
			[self p_hiddenProgressView];
		}];
	}
	[_progressLayer setStrokeEnd:progress];
	[CATransaction commit];
}

- (void)p_showprogressView
{
	[UIView animateWithDuration:0.1 animations:^{
		self.alpha = 1;
	}];
}

- (void)p_hiddenProgressView
{
//	[UIView animateWithDuration:0.1 animations:^{
//	} completion:^(BOOL finished) {
//		
//		if ([_delegate respondsToSelector:@selector(progressViewLoadingFinish)])
//		{
//			[_delegate progressViewLoadingFinish];
//		}
//	}];
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"finishLoading" object:nil];
//	return;
}

- (void)cancelBtnClick
{
	[UIView animateWithDuration:0.3 animations:^{
		self.alpha = 0;
	}];
}

- (void)dealloc
{
	NSLog(@"释放progressView");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
