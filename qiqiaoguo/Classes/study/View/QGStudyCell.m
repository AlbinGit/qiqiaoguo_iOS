//
//  QGStudyCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/15.
//

#import "QGStudyCell.h"
#import "QGNewTeacherLessonModel.h"
@interface QGStudyCell()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong)UILabel * browseLabel;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * tagLabel;
@property (nonatomic,strong)UILabel * lessonsLabel;
@property (nonatomic,strong)UILabel * evaluateLabel;
@property (nonatomic,strong)UILabel * priceNum;
@property (nonatomic, strong) UIProgressView  *progressView;

@property (nonatomic,strong) UIImageView *hotImgView;
@property (nonatomic,strong)UILabel * studyPersonLabel;

@end
@implementation QGStudyCell

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
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 128, 128)];
		img1.userInteractionEnabled = YES;
		img1.contentMode = UIViewContentModeScaleToFill;
		img1.image = [UIImage imageNamed:@"common-app-logo"];
		[self.contentView addSubview:img1];
		img1;
	});
	
	self.hotImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(128-24, 0, 24, 16)];
		img1.userInteractionEnabled = YES;
		[self.imgView addSubview:img1];
		img1;
	});
	
	UIView * blackView = [[UIView alloc]initWithFrame:CGRectMake(_imgView.width-5-83, _imgView.height-5-18, 83, 18)];
	blackView.backgroundColor = [UIColor blackColor];
	blackView.alpha = 0.5;
	blackView.layer.cornerRadius = 9;
	[self.imgView addSubview:blackView];
	
	UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 7, 8)];
	img.userInteractionEnabled = YES;
	img.image = [UIImage imageNamed:@"ic_视频学习"];
	[blackView addSubview:img];
	
	self.studyPersonLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(img.right+3,0, 63,18)];
		label.font = FONT_SYSTEM(11);
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentLeft;
		[blackView addSubview:label];
		label;
	});
	
	
	self.titleLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right+7,10, SCREEN_WIDTH-30-_imgView.right,36)];
		label.font = FONT_SYSTEM(14);
		//label.text = @"发解放路健身房房间爱了看见发暗示法大丰收发打发打发是";
		label.numberOfLines = 2;
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});
	self.iconImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(_imgView.right+7, _titleLabel.bottom+5, 18, 18)];
		img1.image = [UIImage imageNamed:@"common-app-logo"];
		img1.layer.masksToBounds = YES;
		img1.layer.cornerRadius = 18/2;
		img1.userInteractionEnabled = YES;
		[self.contentView addSubview:img1];
		img1;
	});
	
	self.nameLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImgView.right+7, _titleLabel.bottom+5,45,16)];
		label.text = @"张扬杨";
		label.font = FONT_SYSTEM(11.);
		label.textAlignment = NSTextAlignmentLeft;
		label.textColor = [UIColor colorFromHexString:@"888888"];
		[self.contentView addSubview:label];
		label;
	});
	
	self.tagLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right+5,_titleLabel.bottom+5, SCREEN_WIDTH-30,16)];
		label.font = FONT_SYSTEM(11);
		label.text = @"学霸小杨";
		label.textColor = [UIColor colorFromHexString:@"C5904C"];
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});
	
	self.progressView = ({
     UIProgressView *  progressView = [[UIProgressView alloc] init];
		progressView.frame = CGRectMake(_imgView.right+7, _iconImgView.bottom+10, _titleLabel.width, 2);
		progressView.progressViewStyle = UIProgressViewStyleDefault;
        progressView.progressTintColor = [UIColor colorFromHexString:@"FF7373"];
		progressView.trackTintColor    = [UIColor colorFromHexString:@"D8D8D8"];
        progressView.progressTintColor = [UIColor redColor];
		[self.contentView addSubview:progressView];
		progressView;
	});
	
	self.lessonsLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right+7,_progressView.bottom+5, 100,17)];
		label.font = FONT_SYSTEM(12);
		label.text = @"126节";
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});
	self.evaluateLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100-20,_progressView.bottom+5, 100,17)];
		label.font = FONT_SYSTEM(12);
		label.text = @"100%好评";
		label.textColor = [UIColor colorFromHexString:@"888888"];
		label.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:label];
		label;
	});
	
	
}

- (void)setModel:(QGNewTeacherLessonModel *)model
{
	_model = model;
	[_imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_path] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
	[_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.teacher_head_img] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
	_titleLabel.text = model.title;
	_nameLabel.text = model.teacher_name;
	if (model.tagList.count>0) {
		_tagLabel.text = model.tagList[0][@"tag_name"];
	}
	_lessonsLabel.text = [NSString stringWithFormat:@"%@节",model.section_count];
	_evaluateLabel.text = [NSString stringWithFormat:@"已学习%@",model.already_study_rate];

	_studyPersonLabel.text = [NSString stringWithFormat:@"%@观看",model.sign_count];
	if ([model.ico_name isEqualToString:@"new"]) {
		_imgView.image = [UIImage imageNamed:@"角标_new"];
	}
	else if ([model.ico_name isEqualToString:@"hot"])
	{
		_imgView.image = [UIImage imageNamed:@"角标_hot"];
	}
//	_progressView.progress = 0.7;
	
	CGFloat studyProgress = [model.already_study_rate floatValue]/100;
	//动画
	[UIView animateWithDuration:1 animations:^{
		[_progressView setProgress:studyProgress animated:YES];
	} completion:^(BOOL finished){
		//NULL
	}];
	
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
