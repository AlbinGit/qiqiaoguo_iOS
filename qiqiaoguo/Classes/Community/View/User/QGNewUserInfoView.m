//
//  QGNewUserInfoView.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/9.
//

#import "QGNewUserInfoView.h"
//static const CGFloat kHeigt = 210+Height_TopBar;
//#define kHeight 210+Height_TopBar
@interface QGNewUserInfoView()
@property (nonatomic,strong) UIButton *settingBtn;
@property (nonatomic,strong) UIButton *messageBtn;

@property (nonatomic,strong) UILabel *collectionNumLabel;
@property (nonatomic,strong) UILabel *collectionLabel;
@property (nonatomic,strong) UILabel *concernNumLabel;
@property (nonatomic,strong) UILabel *concernLabel;
@property (nonatomic,strong) UILabel *fansNumLabel;
@property (nonatomic,strong) UILabel *fansLabel;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong) UIButton *concernBtn;
@property (nonatomic,strong) UIButton *fansBtn;

@end

@implementation QGNewUserInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self p_creatUI];
	}
	return self;
}

- (void)p_creatUI
{
//	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
	
	self.settingBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, Height_StatusBar+23, 20, 20);
//		[tabBtn setImage:[UIImage imageNamed:@"ic_留言"] forState:UIControlStateNormal];
		[tabBtn setBackgroundImage:[UIImage imageNamed:@"ic_设置"]];
		[tabBtn addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:tabBtn];
		tabBtn;
	});

		self.messageBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = CGRectMake(SCREEN_WIDTH-15-20, Height_StatusBar+23, 20, 20);
			[tabBtn setBackgroundImage:[UIImage imageNamed:@"ic_新留言"]];
			[tabBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:tabBtn];
			tabBtn;
		});

	self.messageLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-15,_messageBtn.top-7,15,15)];
		label.font = FONT_SYSTEM(10);
		label.text = @"33";
		label.textColor = [UIColor colorFromHexString:@"E62C2A"];
		label.layer.masksToBounds = YES;
		label.layer.cornerRadius = 15/2;
		label.adjustsFontSizeToFitWidth = YES;
		label.backgroundColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		label;
	});

	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(15, _settingBtn.bottom+15, SCREEN_WIDTH-30, 185)];
	bgView.backgroundColor = [UIColor whiteColor];
	bgView.layer.masksToBounds = YES;
	bgView.layer.cornerRadius = 10;
	[self addSubview:bgView];


	self.personImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
		img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
		img1.layer.masksToBounds = YES;
		img1.layer.cornerRadius = 60/2;
		img1.userInteractionEnabled = YES;
		[bgView addSubview:img1];
		img1;
	});
	
	self.nameLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_personImgView.right+15,15, 120, 60)];
		label.font = FONT_SYSTEM(18);
		label.text = @"Lida1110";
		label.textColor = [UIColor colorFromHexString:@"333333"];
		label.adjustsFontSizeToFitWidth = YES;
//		label.backgroundColor = [UIColor redColor];
		label.textAlignment = NSTextAlignmentLeft;
		[bgView addSubview:label];
		label;
	});

	self.loginBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = _nameLabel.frame;
		[tabBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
//		tabBtn.backgroundColor = [UIColor redColor];
		[bgView addSubview:tabBtn];
		tabBtn;
	});

		self.signBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = CGRectMake(bgView.width-15-64, (60-24)/2+15, 64, 24);
			[tabBtn addTarget:self action:@selector(signClick:) forControlEvents:UIControlEventTouchUpInside];
			tabBtn.layer.masksToBounds = YES;
			tabBtn.layer.cornerRadius = 12;
			tabBtn.layer.borderWidth = 1;
			[tabBtn setTitle:@"签到" forState:UIControlStateNormal];
//			[tabBtn setTitle:@"已签到" forState:UIControlStateSelected];
			[tabBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
			tabBtn.titleLabel.font = FONT_CUSTOM(12);
			tabBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;
			[bgView addSubview:tabBtn];
			tabBtn;
		});

		CGFloat kWidth = bgView.width/3;
	
		self.collectionNumLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0,_personImgView.bottom+20, kWidth, 33)];
			label.font = [UIFont boldSystemFontOfSize:24];
			label.text = @"23";
			label.textColor = [UIColor colorFromHexString:@"E62C2A"];
			label.adjustsFontSizeToFitWidth = YES;
			label.textAlignment = NSTextAlignmentCenter;
			[bgView addSubview:label];
			label;
		});

	self.collectionLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0,_collectionNumLabel.bottom+2, kWidth, 17)];
		label.font = FONT_SYSTEM(12);
		label.text = @"收藏课程";
		label.textColor = [UIColor colorFromHexString:@"232323"];
		label.textAlignment = NSTextAlignmentCenter;
		[bgView addSubview:label];
		label;
	});

		self.concernNumLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_collectionNumLabel.right,_personImgView.bottom+20,kWidth, 33)];
			label.font = [UIFont boldSystemFontOfSize:24];
			label.text = @"5";
			label.textColor = [UIColor colorFromHexString:@"E62C2A"];
			label.adjustsFontSizeToFitWidth = YES;
			label.textAlignment = NSTextAlignmentCenter;
			[bgView addSubview:label];
			label;
		});

	self.concernLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_collectionNumLabel.right,_collectionNumLabel.bottom+2, kWidth, 17)];
		label.font = FONT_SYSTEM(12);
		label.text = @"关注老师";
		label.textColor = [UIColor colorFromHexString:@"232323"];
		label.textAlignment = NSTextAlignmentCenter;
		[bgView addSubview:label];
		label;
	});

		self.fansNumLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_concernLabel.right,_personImgView.bottom+20,kWidth, 33)];
			label.font = [UIFont boldSystemFontOfSize:24];
			label.text = @"18";
			label.textColor = [UIColor colorFromHexString:@"E62C2A"];
			label.adjustsFontSizeToFitWidth = YES;
			label.textAlignment = NSTextAlignmentCenter;
			[bgView addSubview:label];
			label;
		});

	self.fansLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_concernLabel.right,_collectionNumLabel.bottom+2, kWidth, 17)];
		label.font = FONT_SYSTEM(12);
		label.text = @"粉丝";
		label.textColor = [UIColor colorFromHexString:@"232323"];
		label.textAlignment = NSTextAlignmentCenter;
		[bgView addSubview:label];
		label;
	});

		self.collectionBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = CGRectMake(0, _collectionNumLabel.top, kWidth, 50);
			[tabBtn addTarget:self action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
			[bgView addSubview:tabBtn];
			tabBtn;
		});

	self.concernBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(_collectionBtn.right, _collectionNumLabel.top, kWidth, 50);
		[tabBtn addTarget:self action:@selector(concernClick:) forControlEvents:UIControlEventTouchUpInside];
		[bgView addSubview:tabBtn];
		tabBtn;
	});

	self.fansBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(_concernBtn.right, _collectionNumLabel.top, kWidth, 50);
		[tabBtn addTarget:self action:@selector(fansClick:) forControlEvents:UIControlEventTouchUpInside];
		[bgView addSubview:tabBtn];
		tabBtn;
	});

	
}
- (void)setUser:(BLUUser *)user {
    _user = user;
//	NSLog(@"%@--%@---%@",user.is_checkIn_status,user.following_teacher_count,user.nickname);
//    if (!user) {
//        self.followingCountButton.title = @"0";
//        self.followerCountButton.title = @"0";
//        self.nicknameLabel.text = [NSString stringWithFormat:@"%@%@",@" ",user.nickname];
//        self.avatarButton.image = [UIImage imageNamed:@"user-logout-icon"];
//        self.genderButton.hidden = YES;
//        self.signatureLabel.hidden = YES;
//        self.genderButtonBackgroundView.hidden = YES;
//        self.nicknameLabel.hidden = YES;
//        self.lvBackgroundImageView.hidden = YES;
//        self.messeageLab.hidden = YES;
//        if ([BLUAppManager sharedManager].currentUser) {
//            self.loginButton.enabled = NO;
//        }else
//        {
//            self.loginButton.enabled = YES;
//        }
//        self.loginButton.hidden = NO;
//
//
//    } else {
//        self.nicknameLabel.hidden = NO;
//        self.nicknameLabel.text = [NSString stringWithFormat:@"%@%@",@" ",user.nickname];
//        self.signatureLabel.text = user.signatureDesc;
//        self.avatarButton.user = user;
//        self.signatureLabel.hidden = NO;
//
//        self.signImageButton.enabled = !user.isCheckIn;
//        self.signTitleButton.enabled = !user.isCheckIn;
//
//        self.followingCountButton.title = @(user.followingCount).description;
//        self.followerCountButton.title = @(user.followerCount).description;
//
//        self.loginButton.hidden = YES;
//    }
	
	if (!user) {
		self.personImgView.image = [UIImage imageNamed:@"未登录头像"];
		self.nameLabel.text = @"登录/注册";
		self.collectionNumLabel.text = @"0";
		self.concernNumLabel.text = @"0";
		self.fansNumLabel.text = @"0";
		self.messageLabel.hidden = YES;
	}else
	{
			if (user.avatar.thumbnailURL) {
				[self.personImgView sd_setImageWithURL:user.avatar.thumbnailURL placeholderImage:[UIImage imageNamed:@"未登录头像"]];

		  } else if(user.WechatHeadimgURL){
			  [self.personImgView sd_setImageWithURL:user.WechatHeadimgURL placeholderImage:[UIImage imageNamed:@"未登录头像"]];
		  }
		if (user.is_checkIn_status==0) {
			[self.signBtn setTitle:@"签到" forState:UIControlStateNormal];
			self.signBtn.enabled = YES;
		}else
		{
			[self.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
			self.signBtn.enabled = NO;
		}
		self.messageLabel.hidden = NO;
		self.nameLabel.text = user.nickname;
		self.collectionNumLabel.text = @(user.collection_course_count).description;
		self.concernNumLabel.text = @(user.following_teacher_count).description;
		self.fansNumLabel.text = [NSString stringWithFormat:@"%ld",user.followingCount];

	}

	
}

- (void)setClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shouldSettingUesrInfoFromUserInfoView:)]) {
        [self.delegate shouldSettingUesrInfoFromUserInfoView:self];
    }
}
- (void)messageClick:(UIButton *)btn
{
//	if ([self.delegate respondsToSelector:@selector(shouldChatWithUser:fromUserInfoView:)]) {
//        [self.delegate shouldChatWithUser:self.user fromUserInfoView:self];
//    }
	
    if ([self.delegate respondsToSelector:@selector(shouldShowNewsFromUserInfoView:)]) {
        [self.delegate shouldShowNewsFromUserInfoView:self];
    }

}
- (void)loginClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shouldLoginFromUserInfoView:)]) {
        [self.delegate shouldLoginFromUserInfoView:self];
    }

}
- (void)signClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shouldSignActionfromUserInfoView:)]) {
        [self.delegate shouldSignActionfromUserInfoView:self];
    }
}
- (void)collectionClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shouldCollectionfromUserInfoView:)]) {
        [self.delegate shouldCollectionfromUserInfoView:self];
    }
}
- (void)concernClick:(UIButton *)btn
{
	
	if ([self.delegate respondsToSelector:@selector(shouldShowFollowersFromUserInfoView:)]) {
		[self.delegate shouldShowFollowersFromUserInfoView:self];
	}
}
- (void)fansClick:(UIButton *)btn
{
	if ([self.delegate respondsToSelector:@selector(shouldShowFollowingsFromUserInfoView:)]) {
		   [self.delegate shouldShowFollowingsFromUserInfoView:self];
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
