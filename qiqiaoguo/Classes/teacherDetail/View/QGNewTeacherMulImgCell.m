//
//  QGNewTeacherMulImgCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/28.
//

#import "QGNewTeacherMulImgCell.h"
#import "QGNewTeacherCollectionCell.h"
#import "QGNewTeacherStateModel.h"
#import "SZJPhotoBrowser.h"
@interface QGNewTeacherMulImgCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,SZJPhotoBrowserDelegate>

@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * conmmentNum;
@property (nonatomic,strong)UIImageView * imgView1;
@property (nonatomic,strong)UIImageView * imgView2;
@property (nonatomic,strong)UIImageView * imgView3;
@property (nonatomic,strong)UIView * lineView;

@property (nonatomic, strong)UICollectionView *collectionView;

@end
@implementation QGNewTeacherMulImgCell
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
//			img1.image = [UIImage imageNamed:@"ic_潜能开发_pr"];
			img1.layer.masksToBounds = YES;
			img1.layer.cornerRadius = 40/2;
			img1.userInteractionEnabled = YES;
			img1.contentMode = UIViewContentModeScaleAspectFill;
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

	[self.contentView addSubview:self.collectionView];
	
	self.praiseBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, _collectionView.bottom+10, 20, 20);
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

	
//		self.shareBtn = ({
//			UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//			tabBtn.frame = CGRectMake(SCREEN_WIDTH-20-15, _praiseBtn.y, 20, 20);
//			[tabBtn setImage:[UIImage imageNamed:@"ic_分享"] forState:UIControlStateNormal];
//			[tabBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
//			[self.contentView addSubview:tabBtn];
//			tabBtn;
//		});

	UIView * lineView = [[UIView alloc]init];
//	lineView.frame = CGRectMake(0, _praiseBtn.bottom+19, SCREEN_WIDTH, 8)];
	[self.contentView addSubview:lineView];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	_lineView = lineView;
	
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];        flowLayout.minimumLineSpacing = 6;
        flowLayout.minimumInteritemSpacing = 6;
		flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _contentLabel.bottom, SCREEN_WIDTH, 135+31) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.bounces = NO;
       [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册
       [_collectionView registerClass:[QGNewTeacherCollectionCell class] forCellWithReuseIdentifier:@"QGNewTeacherCollectionCell"];
    }
    return _collectionView;
}

- (void)praiseClick:(UIButton *)btn
{
	if (_delegateFlag) {
		[_delegate mulImgCell:self praiseBtnIndexPath:_myIndexpath];
	}
}
- (void)shareClick:(UIButton *)btn
{
	if (_delegateFlag) {
		[_delegate mulImgCell:self shareBtnIndexPath:_myIndexpath];
	}
}
- (void)commentClick:(UIButton *)btn
{
	if (_delegateFlag) {
		[_delegate mulImgCell:self commentBtnIndexPath:_myIndexpath];
	}
}

- (void)setDelegate:(id<QGNewTeacherMulImgCellDelegate>)delegate
{
	_delegate = delegate;
	_delegateFlag = [_delegate respondsToSelector:@selector(mulImgCell:shareBtnIndexPath:)] ||[_delegate respondsToSelector:@selector(mulImgCell:commentBtnIndexPath:)]||[_delegate respondsToSelector:@selector(mulImgCell:shareBtnIndexPath:)];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _model.resources.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-6*2-30)/3,111);

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	
    QGNewTeacherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QGNewTeacherCollectionCell" forIndexPath:indexPath];
//	CNFindDetailModel * model = _interestArr[indexPath.row];
	cell.imgUrl = _model.resources[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NLog(@"index:%@",@"222");
	
	SZJPhotoBrowser *browser = [[SZJPhotoBrowser alloc] init];
	browser.imageCount = _model.resources.count;
	browser.currentImageIndex = indexPath.row;
	browser.delegate = self;
	[browser show];
}
#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(SZJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    NSString *smallImageURL = _model.resources[index];
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageURL] == nil) {
        return [UIImage imageNamed:@"common-app-logo"];
    } else {
        return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageURL];
    }
}

- (NSURL *)photoBrowser:(SZJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *urlStr = _model.resources[index];
    return [NSURL URLWithString:urlStr];
}

- (void)setModel:(QGNewTeacherStateModel *)model
{
	_model = model;
	[_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:@"common-app-logo"]];
	
	_titleLabel.text = model.name;
	_timeLabel.text = model.time_format;
	_contentLabel.text = model.content;
	if ([model.is_liked isEqualToString:@"1"]) {
		[_praiseBtn setImage:[UIImage imageNamed:@"ic_点赞_pr"] forState:UIControlStateNormal];
	}else
	{
		[_praiseBtn setImage:[UIImage imageNamed:@"ic_点赞"] forState:UIControlStateNormal];
	}
	_priseNum.text = model.likes_num;
	_conmmentNum.text = model.replies_num;
	[_collectionView reloadData];
	_lineView.frame = CGRectMake(0, model.cellHeight-8, SCREEN_WIDTH, 8);

	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	_collectionView.frame = CGRectMake(0, _contentLabel.bottom, SCREEN_WIDTH, _model.collectionHeight);
	_praiseBtn.frame = CGRectMake(15, _collectionView.bottom+10, 20, 20);
	_priseNum.frame = CGRectMake(_praiseBtn.right+5, _praiseBtn.y,50,20);
	_commentBtn.frame = CGRectMake(_priseNum.right+5, _praiseBtn.y, 20, 20);
	_conmmentNum.frame = CGRectMake(_commentBtn.right+5, _praiseBtn.y,50,20);
//	_shareBtn.frame = CGRectMake(SCREEN_WIDTH-20-15, _praiseBtn.y, 20, 20);
//	_lineView.frame =CGRectMake(0, _shareBtn.bottom+14, SCREEN_WIDTH, 8);
	_lineView.frame =CGRectMake(0, _model.cellHeight-8, SCREEN_WIDTH, 8);

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
