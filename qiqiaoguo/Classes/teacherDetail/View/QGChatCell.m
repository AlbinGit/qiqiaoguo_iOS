//
//  QGChatCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import "QGChatCell.h"
#import "QGChatModel.h"

@interface QGChatCell()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * conmmentNum;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation QGChatCell
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


	
	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, SCREEN_WIDTH, 1)];
	[self.contentView addSubview:lineView];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	_lineView = lineView;

	
}
- (void)setModel:(QGChatModel *)model
{
	_model = model;
	_titleLabel.text = model.nickName;
	_timeLabel.text = model.logTime;
	_contentLabel.text = model.content;
	[_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
	
	[self setIntroductionText];
}


-(void)setIntroductionText
{
	//获得当前cell高度
	CGRect frame = [self frame];
	CGFloat titHeight = [QGCommon rectForString:_contentLabel.text withFont:16 WithWidth:SCREEN_WIDTH-15*2].size.height+1;
	_contentLabel.frame = CGRectMake(15,_iconImgView.bottom+15, SCREEN_WIDTH-30,titHeight);
	frame.size.height = 80+titHeight;
	self.lineView.frame = CGRectMake(0, _contentLabel.bottom+9, SCREEN_WIDTH, 1);
	self.frame = frame;
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
