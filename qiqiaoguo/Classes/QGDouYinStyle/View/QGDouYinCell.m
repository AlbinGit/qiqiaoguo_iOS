//
//  QGDouYinCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import "QGDouYinCell.h"

#import <ZFPlayer/UIImageView+ZFCache.h>
#import <ZFPlayer/UIView+ZFFrame.h>
#import <ZFPlayer/UIImageView+ZFCache.h>
#import <ZFPlayer/ZFUtilities.h>
#import "ZFLoadingView.h"
#import "QGNewTeacherDetailController.h"
@interface QGDouYinCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;

@property (nonatomic, strong) UIImageView *portraitImgView;

@property (nonatomic, strong) UILabel *priseNumLabel;

@end

@implementation QGDouYinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
		[self.contentView addSubview:self.portraitImgView];
        [self.contentView addSubview:self.likeBtn];

        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.shareBtn];
		[self.contentView addSubview:self.priseNumLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
    self.bgImgView.frame = self.contentView.bounds;
    self.effectView.frame = self.bgImgView.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    CGFloat margin = 30;
    
    min_w = 40;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
    min_y = min_view_h - min_h - 80;
    self.shareBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.shareBtn.frame);
    min_y = CGRectGetMinY(self.shareBtn.frame) - min_h - margin;
    self.commentBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
	
    min_x = CGRectGetMinX(self.commentBtn.frame);
    min_y = CGRectGetMaxY(self.commentBtn.frame);
    min_h = 20;
    min_w = CGRectGetWidth(self.commentBtn.frame);
    self.priseNumLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);

	
	
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.commentBtn.frame);
    min_y = CGRectGetMinY(self.commentBtn.frame) - min_h - margin;
    self.likeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
	
	
	self.portraitImgView.frame = CGRectMake(min_x, min_y, min_w, min_h);
	self.portraitImgView.layer.masksToBounds = YES;
	self.portraitImgView.layer.cornerRadius = min_h/2;
	
    min_x = 20;
    min_h = 20;
    min_y = min_view_h - min_h - 50;
    min_w = self.likeBtn.zf_left - margin;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UILabel *)priseNumLabel {
    if (!_priseNumLabel) {
        _priseNumLabel = [UILabel new];
        _priseNumLabel.textColor = [UIColor whiteColor];
        _priseNumLabel.font = [UIFont systemFontOfSize:15];
		_priseNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priseNumLabel;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
		[_likeBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}


- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
		[_commentBtn addTarget:self action:@selector(favoriteClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _commentBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}
- (UIImageView *)portraitImgView {
    if (!_portraitImgView) {
		_portraitImgView = [[UIImageView alloc]init];
		_portraitImgView.backgroundColor = [UIColor redColor];
		_portraitImgView.userInteractionEnabled = YES;
    }
    return _portraitImgView;
}

- (void)setModel:(QGNewTeacherStateModel *)model
{
	_model = model;
	[self.coverImageView setImageWithURLString:model.resources[0] placeholder:[UIImage imageNamed:@"loading_bgView"]];
	[self.bgImgView setImageWithURLString:model.cover_img placeholder:[UIImage imageNamed:@"loading_bgView"]];
	self.titleLabel.text = model.title;
	self.priseNumLabel.text = model.likes_num;
	[_portraitImgView setImageWithURLString:model.head_img placeholder:[UIImage imageNamed:@"common-app-logo"]];
	
	if ([model.is_liked intValue]==1) {
		[_commentBtn setImage:[UIImage imageNamed:@"ic_videoPraiseSel"] forState:UIControlStateNormal];
	}else
	{
		[_commentBtn setImage:[UIImage imageNamed:@"ic_videoPraise"] forState:UIControlStateNormal];
	}
}
- (void)onClick:(UIButton *)btn
{
	QGNewTeacherDetailController *vc =[[QGNewTeacherDetailController alloc] init];
	vc.teacher_id = _model.teacher_id;
	UIViewController *viewController = [SAUtils findViewControllerWithView:self];
	[viewController.navigationController pushViewController:vc animated:YES];
}
- (void)favoriteClick:(UIButton *)btn
{
	[self requestLikeDataWithTeacher:_model];
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
//        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}


- (void)requestLikeDataWithTeacher:(QGNewTeacherStateModel *)model
{
	NSInteger like = 0;
	if ([model.is_liked isEqualToString:@"1"]) {
		like = 0;
	}else
	{
		like = 1;
	}
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"moment_id":@([model.myID intValue]),
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"is_like":@(like),
	};
	[QGHttpManager post: [NSString stringWithFormat:@"%@/Phone/Edu/setMomentLike",QQG_BASE_APIURLString]params:param success:^(id responseObj) {
		NLog(@"%@",responseObj);
		if ([model.is_liked isEqualToString:@"0"]) {
			[_commentBtn setImage:[UIImage imageNamed:@"ic_videoPraiseSel"] forState:UIControlStateNormal];

		}else
		{
			[_commentBtn setImage:[UIImage imageNamed:@"ic_videoPraise"] forState:UIControlStateNormal];

		}
		
		
	} failure:^(NSError *error) {
		NLog(@"%@",error);

	}];
}

@end
