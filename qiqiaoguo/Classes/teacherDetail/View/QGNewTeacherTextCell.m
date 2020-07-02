//
//  QGNewTeacherCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/28.
//

#import "QGNewTeacherTextCell.h"
#import "QGNewTeacherStateModel.h"

@interface QGNewTeacherTextCell()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * conmmentNum;
@end

@implementation QGNewTeacherTextCell
{
	BOOL	_delegateFlag;
}

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
			img1.image = [UIImage imageNamed:@"common-app-logo"];
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

	self.contentLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15,_iconImgView.bottom+15, SCREEN_WIDTH-30,44)];
		label.font = FONT_SYSTEM(16);
		label.text = @"发解放路健身房房间爱了看见fa就发了开发可垃圾分类科技风科技房间爱了看见山大路口附近房间爱了放假拉开的芳姐";
		label.textAlignment = NSTextAlignmentLeft;
		label.numberOfLines = 2;
		[self.contentView addSubview:label];
		label;
	});

	self.praiseBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, _contentLabel.bottom+10, 20, 20);
		[tabBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
		[tabBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:tabBtn];
		tabBtn;
	});

	self.priseNum = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_praiseBtn.right+5, _praiseBtn.y,50,20)];
		label.text = @"13.3万";
		label.font = FONT_SYSTEM(12.);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"666666"];
		[self.contentView addSubview:label];
		label;
	});

		self.commentBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = CGRectMake(_priseNum.right+5, _praiseBtn.y, 20, 20);
			[tabBtn setImage:[UIImage imageNamed:@"ic_留言"] forState:UIControlStateNormal];
			[tabBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:tabBtn];
			tabBtn;
		});

	
	self.conmmentNum = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_commentBtn.right+5, _praiseBtn.y,50,20)];
		label.text = @"126";
		label.font = FONT_SYSTEM(12.);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"666666"];
		[self.contentView addSubview:label];
		label;
	});

	
		self.shareBtn = ({
			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			tabBtn.frame = CGRectMake(SCREEN_WIDTH-20-15, _praiseBtn.y, 20, 20);
			[tabBtn setImage:[UIImage imageNamed:@"ic_分享"] forState:UIControlStateNormal];
			[tabBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:tabBtn];
			tabBtn;
		});

	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 156-8, SCREEN_WIDTH, 8)];
	[self.contentView addSubview:lineView];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	
}
- (void)setModel:(QGNewTeacherStateModel *)model
{
	_model = model;
	_titleLabel.text = model.name;
	_timeLabel.text = model.time_format;
	_contentLabel.text = model.content;
	if (model.is_liked) {
		[_praiseBtn setImage:[UIImage imageNamed:@"ic_点赞_pr"] forState:UIControlStateNormal];
	}else
	{
		[_praiseBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
	}
	_priseNum.text = model.likes_num;
	_conmmentNum.text = model.replies_num;
}



- (void)praiseClick:(UIButton *)btn
{
	if (_delegateFlag) {
		[_delegate textCell:self praiseBtnIndexPath:_myIndexpath];
	}
}
- (void)shareClick:(UIButton *)btn
{
	if (_delegateFlag) {
		[_delegate textCell:self shareBtnIndexPath:_myIndexpath];
	}
}
- (void)commentClick:(UIButton *)btn
{
	if (_delegateFlag) {
		[_delegate textCell:self commentBtnIndexPath:_myIndexpath];
	}
}

- (void)setDelegate:(id<QGNewTeacherTextCellDelegate>)delegate
{
	_delegate = delegate;
	_delegateFlag = [_delegate respondsToSelector:@selector(textCell:shareBtnIndexPath:)] ||[_delegate respondsToSelector:@selector(textCell:commentBtnIndexPath:)]||[_delegate respondsToSelector:@selector(textCell:shareBtnIndexPath:)];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
