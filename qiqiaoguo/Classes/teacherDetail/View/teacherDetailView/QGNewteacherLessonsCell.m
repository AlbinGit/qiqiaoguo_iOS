//
//  QGNewteacherLessonsCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import "QGNewteacherLessonsCell.h"
#import "QGNewCatalogModel.h"
@interface QGNewteacherLessonsCell()


//@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation QGNewteacherLessonsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
		
	}
	return self;
}
- (void)p_creatUI
{
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
		label.textColor = [UIColor colorFromHexString:@"666666"];
		label.numberOfLines = 0;
		[self.contentView addSubview:label];
		label;
	});

	self.detailBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+12, 76, 24);
		[tabBtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setBackgroundImage:[UIImage imageNamed:@"bt_试听"]];
		[self.contentView addSubview:tabBtn];
		tabBtn;
	});
}
- (void)detailClick:(UIButton *)btn
{
	NSLog(@"t_试听");
//	QGNewTeacherDetailController *vc =[[QGNewTeacherDetailController alloc] init];
//	vc.teacher_id =_teacher_id;
//	UIViewController *viewController = [SAUtils findViewControllerWithView:self];
//	[viewController.navigationController pushViewController:vc animated:YES];
	
	if (_freeVideoBlock) {
		_freeVideoBlock(_model);
	}

}

- (void)setModel:(QGNewCatalogModel *)model
{
	_model = model;
	_titleLabel.text = model.title;
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

	if ([model.is_free intValue]==0) {
		_detailBtn.hidden = YES;
	}else
	{
		_detailBtn.hidden = NO;
	}
	[self setIntroductionText];
}

-(void)setIntroductionText
{
	//获得当前cell高度
	CGRect frame = [self frame];
	CGFloat titHeight = [QGCommon rectForString:_titleLabel.text withFont:12 WithWidth:SCREEN_WIDTH-30-35].size.height+1;
	_titleLabel.frame = CGRectMake(_tagLabel.right+10,4.5, SCREEN_WIDTH-30-35,titHeight);
	_detailBtn.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+12, 76, 24);
	frame.size.height = titHeight+12+24+5+10;
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
