//
//  QGNewTeacherLiveLessonsCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/11.
//

#import "QGNewTeacherLiveLessonsCell.h"
#import "QGNewCatalogModel.h"
@interface QGNewTeacherLiveLessonsCell ()
//@property (nonatomic,strong) UIButton *lookVideoBtn;
@property (nonatomic,strong)UILabel * timeLabel;
//@property (nonatomic,strong) QGNewCatalogModel *classModel;
@property (nonatomic,strong)UILabel * tagLabel;
@property (nonatomic,strong)UILabel * titleLabel;
@end

@implementation QGNewTeacherLiveLessonsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
		
	}
	return self;
}
- (void)p_creatUI
{
//	[self.contentView addSubview:self.tagLabel];
//	[self.contentView addSubview:self.titleLabel];
	
	self.tagLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15,4.5, 25,13)];
		label.font = FONT_SYSTEM(9);
		label.text = @"视频";
		label.textColor = [UIColor colorFromHexString:@"333333"];
		label.layer.borderColor = [UIColor colorFromHexString:@"333333"].CGColor;
		label.layer.borderWidth = 0.5;
		label.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:label];
		label;
	});

	self.titleLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_tagLabel.right+10,4.5, SCREEN_WIDTH-30-35,22)];
		label.font = FONT_SYSTEM(12);
		label.textAlignment = NSTextAlignmentLeft;
		label.numberOfLines = 0;
		label.textColor = [UIColor colorFromHexString:@"666666"];
		[self.contentView addSubview:label];
		label;
	});
	self.timeLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15,self.titleLabel.bottom+12, SCREEN_WIDTH-30-72,24)];
		label.font = FONT_SYSTEM(12);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"666666"];
		[self.contentView addSubview:label];
		label;
	});
	
	self.lookVideoBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(SCREEN_WIDTH-64-15, self.titleLabel.bottom+12, 64, 24);
		[tabBtn addTarget:self action:@selector(lookVideoClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitle:@"去听课" forState:UIControlStateNormal];
		[tabBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
		tabBtn.titleLabel.font = FONT_CUSTOM(12);
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 12;
		tabBtn.layer.borderWidth = 1;
		tabBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;
		[self.contentView addSubview:tabBtn];
		tabBtn;
	});

	
}
- (void)lookVideoClick:(UIButton *)btn
{
	if (_liveVideoBlock) {
		_liveVideoBlock(_model);
	}
}
- (void)setModel:(QGNewCatalogModel *)model
{
	_model = model;
	_titleLabel.text = model.title;
	if ([model.video_type intValue]==0) {
		_timeLabel.text = [NSString stringWithFormat:@"时长：%@",model.video_time];
	}else
	{
		_timeLabel.text = [NSString stringWithFormat:@"[直播] %@-%@",model.start_time,model.end_time];

	}
	if ([model.section_type intValue]==0) {
		self.tagLabel.text = @"线下";

	}else if ([model.section_type intValue] == 1)
	{
		self.tagLabel.text = @"视频";
	}else if ([model.section_type intValue] == 2)
	{
		self.tagLabel.text = @"图文";

	}
	else if ([model.section_type intValue] == 3)
	{
		self.tagLabel.text = @"音频";
	}
	
	if ([model.video_type intValue] == 0) {//录播
		
	}
	else if ([model.video_type intValue] == 1)//直播
	{

		if ([model.live_status integerValue] == 0) {
			[self.lookVideoBtn setTitle:@"未开始" forState:UIControlStateNormal];
			[self.lookVideoBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
			self.lookVideoBtn.layer.borderWidth = 1;
			self.lookVideoBtn.layer.borderColor = [UIColor colorFromHexString:@"888888"].CGColor;
		}
		else if ([model.live_status integerValue] == 1)
		{
			[self.lookVideoBtn setTitle:@"去听课" forState:UIControlStateNormal];
			[self.lookVideoBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
			self.lookVideoBtn.layer.borderWidth = 1;
			self.lookVideoBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;
		}
		else{
			[self.lookVideoBtn setTitle:@"已结束" forState:UIControlStateNormal];
			[self.lookVideoBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
			self.lookVideoBtn.layer.borderWidth = 1;
			self.lookVideoBtn.layer.borderColor = [UIColor colorFromHexString:@"888888"].CGColor;
		}

	}else//回放
	{
		if ([model.live_status integerValue] == 2)
		{
			[self.lookVideoBtn setTitle:@"回放" forState:UIControlStateNormal];
			[self.lookVideoBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
			self.lookVideoBtn.layer.borderWidth = 1;
			self.lookVideoBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;
		}else{
			
			[self.lookVideoBtn setTitle:@"去听课" forState:UIControlStateNormal];
			[self.lookVideoBtn setTitleColor:[UIColor colorFromHexString:@"E62C2A"] forState:UIControlStateNormal];
			self.lookVideoBtn.layer.borderWidth = 1;
			self.lookVideoBtn.layer.borderColor = [UIColor colorFromHexString:@"E62C2A"].CGColor;

		}

	}
	[self setIntroductionText];
}

-(void)setIntroductionText
{
	//获得当前cell高度
	CGRect frame = [self frame];
	CGFloat titHeight = [QGCommon rectForString:_titleLabel.text withFont:12 WithWidth:SCREEN_WIDTH-30-35].size.height+1;
	_titleLabel.frame = CGRectMake(_tagLabel.right+10,4.5, SCREEN_WIDTH-30-35,titHeight);
	self.timeLabel.frame = CGRectMake(15,self.titleLabel.bottom+12, SCREEN_WIDTH-30-72,24);
	self.lookVideoBtn.frame = CGRectMake(SCREEN_WIDTH-64-15, self.titleLabel.bottom+12, 64, 24);
	if (titHeight<13.) {
		titHeight = 13.;
	}
	frame.size.height = 5+titHeight+12+24+10;
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
