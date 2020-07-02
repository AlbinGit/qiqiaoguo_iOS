//
//  QGNewTeacherOrganizationCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/2.
//

#import "QGNewTeacherOrganizationCell.h"
#import "QGNewteacherInfoModel.h"

@interface QGNewTeacherOrganizationCell()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong) UIImageView *orgimgView;
@property (nonatomic,strong)UILabel * localLabel;
@property (nonatomic,strong)UILabel * tagLabel;

@end

@implementation QGNewTeacherOrganizationCell

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
//			img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
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
	self.orgimgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(18, _imgView.bottom+10, 64, 64)];
//		img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
		img1.userInteractionEnabled = YES;
		[self.contentView addSubview:img1];
		img1;
	});

	
	self.contentLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_orgimgView.right+10, _titleLabel.bottom+5,135,22)];
		label.text = @"";
		label.font = FONT_SYSTEM(16);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"333333"];
		[self.contentView addSubview:label];
		label;
	});
	
			UIImageView * localImg = [[UIImageView alloc]initWithFrame:CGRectMake(_orgimgView.right+10, _contentLabel.bottom+5, 18, 18)];
			localImg.image = [UIImage imageNamed:@"ic_定位"];
			[self.contentView addSubview:localImg];
	
	self.localLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(localImg.right+2, _contentLabel.bottom+5,135,18)];
		label.font = FONT_SYSTEM(12);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"666666"];
		[self.contentView addSubview:label];
		label;
	});

		self.tagLabel = ({
			UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_orgimgView.right+10, _localLabel.bottom+5,135,18)];
			label.font = FONT_SYSTEM(10);
			label.layer.masksToBounds = YES;
			label.layer.cornerRadius = 9;
			label.layer.borderColor = [UIColor colorFromHexString:@"B7B7B7"].CGColor;
			label.layer.borderWidth = 0.5;
			label.textAlignment = NSTextAlignmentCenter;
			label.textColor = [UIColor colorFromHexString:@"888888"];
			[self.contentView addSubview:label];
			label;
		});

}
- (void)setModel:(QGNewteacherInfoModel *)model
{
	_imgView.image = [UIImage imageNamed:model.iconImgName];
	_titleLabel.text = model.title;
	_contentLabel.text = model.orgName;
	_localLabel.text = model.orgLocation;
//	_tagLabel.text = @"英语，法语，德语";
	if (model.orgLangauage.length>0) {
		_tagLabel.text = model.orgLangauage;
		CGFloat tagW = [QGCommon rectWithString:_tagLabel.text withFont:10]+30;
		_tagLabel.frame = CGRectMake(_orgimgView.right+10, _localLabel.bottom+5,tagW,18);
	}else
	{
		_tagLabel.hidden = YES;
	}
	[_orgimgView sd_setImageWithURL:[NSURL URLWithString:model.orgImg] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
	
}

@end
