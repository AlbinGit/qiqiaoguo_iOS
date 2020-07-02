//
//  QGNewTeacherIntroCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import "QGNewTeacherIntroCell.h"
#import "QGNewTeacherDetailController.h"
@interface QGNewTeacherIntroCell()
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,copy) NSString *teacher_id;

@end

@implementation QGNewTeacherIntroCell

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
			UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
			img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
			img1.layer.masksToBounds = YES;
			img1.layer.cornerRadius = 40/2;
			img1.userInteractionEnabled = YES;
			[self.contentView addSubview:img1];
			img1;
		});

	self.nameLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgView.right+10,10, SCREEN_WIDTH-20-_iconImgView.right,22)];
		label.font = FONT_SYSTEM(16);
		label.text = @"发解放路健身房房间爱了看见";
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});

	self.contentLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgView.right+10,_nameLabel.bottom+3, SCREEN_WIDTH-30-72,14)];
		label.font = FONT_SYSTEM(12);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"666666"];
		[self.contentView addSubview:label];
		label;
	});

	self.detailBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(SCREEN_WIDTH-72-15, (60-24)/2, 72, 24);
		[tabBtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitle:@"查看详情" forState:UIControlStateNormal];
		[tabBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
		[tabBtn setTitleFont:FONT_CUSTOM(12)];
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 12;
		tabBtn.layer.borderWidth = 0.5;
		tabBtn.layer.borderColor = [UIColor colorFromHexString:@"888888"].CGColor;
		[self.contentView addSubview:tabBtn];
		tabBtn;
	});
}
- (void)detailClick:(UIButton *)btn
{
	QGNewTeacherDetailController *vc =[[QGNewTeacherDetailController alloc] init];
	vc.teacher_id =_teacher_id;
	UIViewController *viewController = [SAUtils findViewControllerWithView:self];
	[viewController.navigationController pushViewController:vc animated:YES];
}

- (void)loadDict:(NSDictionary *)dict
{
	[_iconImgView sd_setImageWithURL:[NSURL URLWithString:dict[@"teacher_head_img"]] placeholderImage:[UIImage imageNamed:@""]];
	_nameLabel.text = dict[@"teacher_name"];
	_contentLabel.text = [NSString stringWithFormat:@"粉丝：%@  教龄：%@",dict[@"teacher_fans_num"],dict[@"teacher_experience"]];
	
	_teacher_id = dict[@"teacher_id"];
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
