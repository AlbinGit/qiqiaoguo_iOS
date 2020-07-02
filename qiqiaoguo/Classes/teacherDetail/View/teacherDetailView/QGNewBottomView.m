//
//  QGNewBottomView.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import "QGNewBottomView.h"
#import "BLUChatViewController.h"
@interface QGNewBottomView()
@property (nonatomic,strong) UIImageView *collectionImg;

@end

@implementation QGNewBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self p_creatUI];
	}
	return self;
}

- (void)p_creatUI
{
	UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
	lineV.backgroundColor = [UIColor colorFromHexString:@"EDEDED"];
	[self addSubview:lineV];
	UIImageView * message = [[UIImageView alloc]initWithFrame:CGRectMake(15, (54+Height_BottomSafe-20)/2, 20, 20)];
	message.image = [UIImage imageNamed:@"ic_咨询"];
	[self addSubview:message];
	
	UILabel * messageLab = [[UILabel alloc]initWithFrame:CGRectMake(message.right+3, (54+Height_BottomSafe-20)/2, 40, 20)];
	messageLab.textAlignment = NSTextAlignmentLeft;
	messageLab.text = @"咨询";
	[self addSubview:messageLab];
		
	
	UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	messageBtn.frame = CGRectMake(0, 0, messageLab.right, 54+Height_BottomSafe);
	[messageBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:messageBtn];
	
	
	
	UIImageView * collectionImg = [[UIImageView alloc]initWithFrame:CGRectMake(messageLab.right+20, (54+Height_BottomSafe-20)/2, 20, 20)];
	collectionImg.image = [UIImage imageNamed:@"ic_收藏"];
	[self addSubview:collectionImg];
	_collectionImg = collectionImg;
	
	UILabel * collectionLab = [[UILabel alloc]initWithFrame:CGRectMake(collectionImg.right+3, (54+Height_BottomSafe-20)/2, 40, 20)];
	collectionLab.textAlignment = NSTextAlignmentLeft;
	collectionLab.text = @"收藏";
	[self addSubview:collectionLab];
		
	
	UIButton * collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	collectionBtn.frame = CGRectMake(collectionImg.left, 0, messageLab.right, 54+Height_BottomSafe);
	[collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:collectionBtn];
	
	
	UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	payBtn.frame = CGRectMake(collectionBtn.right+5 , (54+Height_BottomSafe-40)/2,self.width- collectionBtn.right-25, 40);
	payBtn.backgroundColor = [UIColor colorFromHexString:@"EFAF11"];
	[payBtn setTitle:@"立即报名" forState:UIControlStateNormal];
	payBtn.layer.masksToBounds = YES;
	payBtn.layer.cornerRadius = 20;
	[payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:payBtn];
}
- (void)payBtnClick:(UIButton *)btn
{
	NSLog(@"payBtnClick");
	
	if (_payForLessonsBlock) {
		_payForLessonsBlock();
	}

}
- (void)messageClick:(UIButton *)btn
{
		NSLog(@"messageClick");
		BLUChatViewController *vc = [[BLUChatViewController alloc]
									 initWithUserID:_service_id.integerValue];
	   UIViewController *viewController = [SAUtils findViewControllerWithView:self];
	   [viewController.navigationController pushViewController:vc animated:YES];
}
- (void)collectionBtnClick:(UIButton *)btn
{
	NSLog(@"collectionBtnClick");
	if (_collectionBlock) {
		_collectionBlock(_isFollowed);
	}

}
- (void)setService_id:(NSString *)service_id
{
	_service_id = service_id;
}
- (void)setIsFollowed:(BOOL)isFollowed
{
	_isFollowed = isFollowed;
	if (_isFollowed) {
		_collectionImg.image = [UIImage imageNamed:@"ic_已收藏"];
	}else
	{
		_collectionImg.image = [UIImage imageNamed:@"ic_收藏"];
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
