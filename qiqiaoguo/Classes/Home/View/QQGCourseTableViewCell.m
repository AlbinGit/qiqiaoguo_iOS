//
//  QQGCourseTableViewCell.m
//  qiqiaoguo
//
//  Created by 李艳彬 on 2020/5/17.
//

#import "QQGCourseTableViewCell.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGCourseDetailViewController.h"
#import "QGHomeCourseModel.h"
#import "QGNewCourseDetailController.h"
#import "QGNewteacherBuyController.h"

@interface QQGCourseTableViewitemCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) UILabel *lessonsLabel;
@property (nonatomic,strong) UILabel *studyPersonLabel;

@end

@implementation QQGCourseTableViewitemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
    CGFloat itemHeight = itemWidth;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemHeight)];
	_imgView.userInteractionEnabled = YES;
	_imgView.layer.masksToBounds = YES;
	_imgView.layer.cornerRadius = 5;
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgView.maxY, self.width, 42)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
	_titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor colorFromHexString:@"333333"];
    [self.contentView addSubview:_titleLabel];
	
	self.lessonsLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, _titleLabel.bottom+3, itemWidth-20, 18)];
		label.font = [UIFont systemFontOfSize:13];
		label.textColor = [UIColor colorFromHexString:@"888888"];
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
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
	
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-37, 0, 37, 18)];
    [self.contentView addSubview:_iconImgView];

}

@end

static NSString * const QGfooterViewCellIdentifier = @"footerCellIdentifier";

@interface QQGCourseTableViewCell ()
@property (nonatomic, strong) NSMutableArray   *firstRowCellCountArray;

@end


@implementation QQGCourseTableViewCell

#define collectionViewCellId @"categoryCollectionCellId"
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
    CGFloat itemHeight = itemWidth;

    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flow.minimumInteritemSpacing = 10;
    flow.minimumLineSpacing      = 0;
    flow .itemSize = CGSizeMake( itemWidth, itemHeight +73);

    CGFloat H = 0;
     H = (itemHeight +50)*2+44;
      _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, H) collectionViewLayout:flow];

    [self.collectionView registerClass:[QQGCourseTableViewitemCell class] forCellWithReuseIdentifier:@"CollectionCellId"];
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
    CGFloat itemHeight = itemWidth;
    int totalCol = 2;
    int row = (_dataSource.count-1) / totalCol;
    CGFloat y = (itemHeight + 73) * row;

//    if (_firstRowCellCountArray.count>0 || _dataSource.count<3) {
//        _collectionView.height = y +itemHeight+50 +44;
//    }
	
//	_collectionView.height = y +itemHeight+73 +44;
	if (_dataSource.count>3) {
		_collectionView.height = y +itemHeight+73 +44;
	}else if (_dataSource.count>0)
	{
		_collectionView.height = y +itemHeight+73 ;
	}
	else
	{
		_collectionView.height = 0;
	}

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (_firstRowCellCountArray.count>0||_dataSource.count<4 ) {
//      return _dataSource.count;
//    }else
//    return 4;
	
	return _dataSource.count;

}



- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CollectionCellId";
    QQGCourseTableViewitemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   
//	QGCourseInfoModel *model = _dataSource[indexPath.row];
	QGHomeCourseModel * model = _dataSource[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_path] placeholderImage:nil];
    cell.titleLabel.text = model.title;
	cell.studyPersonLabel.text = [NSString stringWithFormat:@"%@人已学习",model.sign_count];
	cell.lessonsLabel.text = [NSString stringWithFormat:@"%@节",model.section_count];
	if ([model.ico_name isEqualToString:@"hot"]) {
		cell.iconImgView.image = [UIImage imageNamed:@"角标_hot"];
	}
	else if ([model.ico_name isEqualToString:@"new"])
	{
		cell.iconImgView.image = [UIImage imageNamed:@"角标_new"];

	}else
	{
		cell.iconImgView.image = [UIImage imageNamed:@""];
	}
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
		   viewForSupplementaryElementOfKind:(NSString *)kind
								 atIndexPath:(NSIndexPath *)indexPath {
	UICollectionReusableView *reusableView = nil;
	if ([kind isEqual:UICollectionElementKindSectionFooter]) {
		
		QGCollectionVideoFooterView *footerView =
		[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
										   withReuseIdentifier: QGfooterViewCellIdentifier
												  forIndexPath:indexPath];

		if (_dataSource.count>3) {
			footerView.delegate = self;
			footerView.hidden = NO;
			footerView.alpha = 1;
			[footerView.btn setTitle:@"查看更多" forState:UIControlStateNormal];
			[footerView.btn setImage:[UIImage imageNamed:@"drown-icon"] forState:UIControlStateNormal];
		}else
		{
			footerView.hidden = YES;
			footerView.alpha = 0;
		}
		reusableView = footerView;

	}
	
	
	return reusableView;
	
}
#pragma mark  QGCollectionVideoFooterView代理
- (void)collectionVideoFooterViewMoreBtnClicked:(QGCollectionVideoFooterView *)sender {
	PL_CODE_WEAK(ws);
	if ([ws.delegate respondsToSelector:@selector(QQGCourseTableViewCellMoreBtnClicked:)]) {
		[ws.delegate QQGCourseTableViewCellMoreBtnClicked:self];
	}				
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

	QGHomeCourseModel * model = _dataSource[indexPath.row];
	if ([model.is_buy intValue]==1) {
		QGNewteacherBuyController*vc =[[QGNewteacherBuyController alloc] init];
		vc.course_id =model.course_id;
		UIViewController *viewController = [SAUtils findViewControllerWithView:self];
		[viewController.navigationController pushViewController:vc animated:YES];
	}else
	{
		QGNewCourseDetailController*vc =[[QGNewCourseDetailController alloc] init];
		vc.course_id =model.course_id;
		UIViewController *viewController = [SAUtils findViewControllerWithView:self];
		[viewController.navigationController pushViewController:vc animated:YES];
	}
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




