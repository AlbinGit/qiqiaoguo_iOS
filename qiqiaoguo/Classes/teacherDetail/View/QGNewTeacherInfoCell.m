//
//  QGNewTeacherInfoCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/1.
//

#import "QGNewTeacherInfoCell.h"
#import "QGNewteacherInfoModel.h"
@interface QGNewTeacherInfoCell()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@end

@implementation QGNewTeacherInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
	}
	return self;
}
- (void)p_creatUI
{
	
		self.imgView = ({
			UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(19, 12, 18, 18)];
			img1.userInteractionEnabled = YES;
			[self.contentView addSubview:img1];
			img1;
		});
	self.titleLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right+11,10, SCREEN_WIDTH-36-_imgView.right,22)];
		label.font = [UIFont boldSystemFontOfSize:16];
//		label.text = @"发解放";
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});
	self.contentLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(19, _titleLabel.bottom+5,35,22)];
		label.text = @"暂无内容~";
		label.font = FONT_SYSTEM(16);
		label.textAlignment = NSTextAlignmentLeft;
		label.numberOfLines = 0;
		label.textColor = [UIColor colorFromHexString:@"333333"];
		[self.contentView addSubview:label];
		label;
	});
	
//	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(14, 159-1, SCREEN_WIDTH-14, 1)];
//	lineView.backgroundColor = [UIColor colorFromHexString:@"EDEDED"];
//	[self.contentView addSubview:lineView];
		
}

- (void)setModel:(QGNewteacherInfoModel *)model
{
	_imgView.image = [UIImage imageNamed:model.iconImgName];
	_titleLabel.text = model.title;
	
	if (model.content.length>0) {
		_contentLabel.text = model.content;
	}
	[self setIntroductionText];
}

-(void)setIntroductionText
{
	//获得当前cell高度
	CGRect frame = [self frame];
	
	CGFloat titHeight = [QGCommon rectForString:_contentLabel.text withFont:16 WithWidth:SCREEN_WIDTH-19*2].size.height+1;
	_contentLabel.frame = CGRectMake(19, _titleLabel.bottom+5,SCREEN_WIDTH-19*2,titHeight);
	frame.size.height = 22+10+10+titHeight;
	
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
