//
//  QGNewTeacherInteligenceCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/2.
//

#import "QGNewTeacherInteligenceCell.h"
#import "QGNewteacherInfoModel.h"

@interface QGNewTeacherInteligenceCell()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong) UIImageView *IntelegenceimgV;
@end

@implementation QGNewTeacherInteligenceCell

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
			img1.image = [UIImage imageNamed:@"common-app-logo"];
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
	
	self.IntelegenceimgV = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(18, _imgView.bottom+10, 120, 80)];
//		img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
		img1.userInteractionEnabled = YES;
		img1.contentMode = UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:img1];
		img1;
	});

//	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(14, 122-1, SCREEN_WIDTH-14, 1)];
//	lineView.backgroundColor = [UIColor colorFromHexString:@"EDEDED"];
//	[self.contentView addSubview:lineView];
		
}

- (void)setModel:(QGNewteacherInfoModel *)model
{
	_imgView.image = [UIImage imageNamed:model.iconImgName];
	_titleLabel.text = model.title;
	
	[_IntelegenceimgV sd_setImageWithURL:[NSURL URLWithString:model.intelegencyImg] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
	
}
@end
