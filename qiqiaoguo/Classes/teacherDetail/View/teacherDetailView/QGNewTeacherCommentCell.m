//
//  QGNewTeacherCommentCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import "QGNewTeacherCommentCell.h"
#import "QGStarView.h"
#import "QGNewCommentModel.h"

@interface QGNewTeacherCommentCell()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIView * lineView;

@property (nonatomic,strong)QGStarView * starView;

@end
@implementation QGNewTeacherCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
	}
	return self;
}
- (void)p_creatUI
{
			self.iconImgView = ({
				UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
//				img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
				img1.layer.masksToBounds = YES;
				img1.layer.cornerRadius = 40/2;
				img1.userInteractionEnabled = YES;
				[self.contentView addSubview:img1];
				img1;
			});
		self.titleLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgView.right+10,15, SCREEN_WIDTH-20-_iconImgView.right,22)];
			label.font = FONT_SYSTEM(16);
			label.text = @"发解放路健身房房间爱了看见";
			label.textAlignment = NSTextAlignmentLeft;
			[self.contentView addSubview:label];
			label;
		});
		
			self.timeLabel = ({
				UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgView.right+10, _titleLabel.bottom+2,SCREEN_WIDTH-20-_iconImgView.right,16)];
				label.text = @"16.08.2018 17:30";
				label.font = FONT_SYSTEM(12.);
				label.textAlignment = NSTextAlignmentLeft;
				label.textColor = [UIColor colorFromHexString:@"888888"];
				[self.contentView addSubview:label];
				label;
			});

	self.starView = ({
		QGStarView *starView = [[QGStarView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-15, 15, 100, 40) starSize:CGSizeZero withStyle:QGStarTypeInteger];
		starView.isTouch = NO;
//		starView.backgroundColor = [UIColor redColor];
		[self.contentView addSubview:starView];
		starView;
	});
	
		self.contentLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgView.right+10,_iconImgView.bottom+15, SCREEN_WIDTH-_iconImgView.right-15,44)];
			label.font = FONT_SYSTEM(16);
			label.text = @"发解放路健身房房间爱了看见fa就发了开发可垃圾分类科技风科技房间爱了看见山大路口附近房间爱了放假拉开的芳姐";
			label.textAlignment = NSTextAlignmentLeft;
			label.numberOfLines = 2;
			[self.contentView addSubview:label];
			label;
		});

	self.lineView = ({
		UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(14, _contentLabel.bottom+14.5, SCREEN_WIDTH-28, 0.5)];
		lineView.backgroundColor = [UIColor colorFromHexString:@"EDEDED"];
		[self.contentView addSubview:lineView];
		lineView;
	});
}
- (void)setModel:(QGNewCommentModel *)model
{
	_model = model;
	[_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.headimgurl]];
	_titleLabel.text = model.username;
	_timeLabel.text = model.createdate;
	_contentLabel.text = model.content;
	_starView.star = [model.level floatValue];
//	_starView.star = 5;
	[self setIntroductionText];
}
-(void)setIntroductionText
{
	//获得当前cell高度
	CGRect frame = [self frame];
	CGFloat titHeight = [QGCommon rectForString:_contentLabel.text withFont:16 WithWidth:SCREEN_WIDTH-_iconImgView.right-15].size.height+1;
	_contentLabel.frame = CGRectMake(_iconImgView.right+10,_iconImgView.bottom+15, SCREEN_WIDTH-_iconImgView.right-15,titHeight);
	_lineView.frame = CGRectMake(14, _contentLabel.bottom+14.5, SCREEN_WIDTH-28, 0.5);
	frame.size.height = 15+40+15+titHeight+15;

	self.frame = frame;
}


@end
