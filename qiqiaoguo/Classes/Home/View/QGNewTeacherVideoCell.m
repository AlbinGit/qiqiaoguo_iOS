//
//  QGNewTeacherVideoCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/4.
//

#import "QGNewTeacherVideoCell.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGHomeTeacherModel.h"
#import "QGNewTeacherDetailController.h"
#import "QGDouYinController.h"
@interface QGTeacherTableViewitemCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *playImgView;
@property (nonatomic,strong) UIImageView *portraitImgView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *tagLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation QGTeacherTableViewitemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*4/3;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemHeight)];
	_imgView.layer.masksToBounds = YES;
	_imgView.layer.cornerRadius = 5;
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imgView.maxY, self.width-20, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorFromHexString:@"666666"];
    [self.contentView addSubview:_titleLabel];
	
	_playImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-30, 10, 20, 20)];
	_playImgView.image = [UIImage imageNamed:@"ic_播放"];
	[_imgView addSubview:_playImgView];

	self.portraitImgView = ({
		UIImageView * img = [[UIImageView alloc]init];
		img.frame = CGRectMake(10, _titleLabel.bottom+3, 18, 18);
		img.layer.masksToBounds = YES;
		img.layer.cornerRadius = 9;
		[self.contentView addSubview:img];
		img;
	});
	
	self.nameLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_portraitImgView.right, _titleLabel.bottom+3, itemWidth-_portraitImgView.right-55, 18)];
		label.font = [UIFont systemFontOfSize:11];
		label.textColor = [UIColor colorFromHexString:@"888888"];
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
//		label.backgroundColor = [UIColor yellowColor];
		label;
	});
	
//	self.tagLabel = ({
//		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right, _titleLabel.bottom+3, itemWidth-_nameLabel.right-55, 18)];
//		label.font = [UIFont systemFontOfSize:11];
//		label.textColor = [UIColor colorFromHexString:@"C5904C"];
//		label.textAlignment = NSTextAlignmentCenter;
//		label.adjustsFontSizeToFitWidth = YES;
//		label.text = @"学霸小样";
//		[self.contentView addSubview:label];
//		label;
//	});

	self.timeLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(self.width-55, _titleLabel.bottom+3, 55, 18)];
		label.font = [UIFont systemFontOfSize:11];
		label.textColor = [UIColor colorFromHexString:@"999999"];
		label.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:label];
//		label.backgroundColor = [UIColor greenColor];
		label;
	});

//    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-36, 0, 36, 36)];
//    [self.contentView addSubview:_iconImgView];
}

@end

static NSString * const QGfooterViewCellIdentifier = @"footerViewCellIdentifier2";

@interface QGNewTeacherVideoCell ()
@property (nonatomic, strong) NSMutableArray   *firstRowCellCountArray;

@end


@implementation QGNewTeacherVideoCell

#define collectionViewCellId @"categoryCollectionCellId2"
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _firstRowCellCountArray = [NSMutableArray array];
         [self p_createUI];
    }
    return self;
}
- (void)p_createUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
  
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*4/3;

    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flow.minimumInteritemSpacing = 10;
    flow.minimumLineSpacing      = 0;
    flow .itemSize = CGSizeMake( itemWidth, itemHeight +50);

    CGFloat H = 0;
     H = (itemHeight +50)*2+44;
      _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, H) collectionViewLayout:flow];

    [self.collectionView registerClass:[QGTeacherTableViewitemCell class] forCellWithReuseIdentifier:@"CollectionCellId2"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.allowsMultipleSelection = YES;
    [self.contentView addSubview:_collectionView];
    [self.collectionView registerClass:[QGCollectionVideoFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QGfooterViewCellIdentifier];
    
}


- (void)setDataSource:(NSArray *)dataSource{
    _dataSource =dataSource;

    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth*4/3;
    int totalCol = 2;
    int row = (_dataSource.count-1) / totalCol;
    CGFloat y = (itemHeight + 50) * row;
//	_collectionView.height = y +itemHeight+50 +44;
	if (_dataSource.count>3) {
		_collectionView.height = y +itemHeight+50 +44;
	}else if (_dataSource.count>0)
	{
		_collectionView.height = y +itemHeight+50 ;
	}
	else
	{
		_collectionView.height = 0;
	}

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	return _dataSource.count;

}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CollectionCellId2";
    QGTeacherTableViewitemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	QGHomeTeacherModel * model = _dataSource[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:nil];
    cell.titleLabel.text = model.title;
	[cell.portraitImgView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:nil];
	cell.nameLabel.text = model.name;
	cell.tagLabel.text = model.content;
	cell.timeLabel.text = model.time_format;
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
     UICollectionReusableView *reusableView = nil;
    if ([kind isEqual:UICollectionElementKindSectionFooter]) {
        
      
		if (_dataSource.count>3) {
			QGCollectionVideoFooterView *footerView =
			[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
											   withReuseIdentifier: QGfooterViewCellIdentifier
													  forIndexPath:indexPath];
			footerView.delegate = self;
			[footerView.btn setTitle:@"查看更多" forState:UIControlStateNormal];
			[footerView.btn setImage:[UIImage imageNamed:@"drown-icon"] forState:UIControlStateNormal];
			reusableView = footerView;
		}else
		{
			UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:QGfooterViewCellIdentifier forIndexPath:indexPath];
			view.frame = CGRectMake(0, 0, 0, 0);
			reusableView = view;
			
		}
    }
    return reusableView;

}
#pragma mark  QGCollectionVideoFooterView代理
- (void)collectionVideoFooterViewMoreBtnClicked:(QGCollectionVideoFooterView *)sender {
	PL_CODE_WEAK(ws);
	if ([ws.delegate respondsToSelector:@selector(QGNewTeacherVideoCellMoreBtnClicked:)]) {
		[ws.delegate QGNewTeacherVideoCellMoreBtnClicked:self];
	}
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

//    QGCourseInfoModel *model = _dataSource[indexPath.row];
	QGHomeTeacherModel * model = _dataSource[indexPath.row];
//    QGNewTeacherDetailController *vc =[[QGNewTeacherDetailController alloc] init];
//	vc.teacher_id = model.teacher_id;
//    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
//    [viewController.navigationController pushViewController:vc animated:YES];
	
    QGDouYinController *vc =[[QGDouYinController alloc] init];
	vc.moment_id = model.myID;
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];

	
}
#pragma mark - UICollectionViewDelegateFlowLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (_dataSource.count>=4) {
		return CGSizeMake(MQScreenW, 44);

	}else
	{
		return CGSizeMake(MQScreenW, 0.0001);
	}
	
}

@end
