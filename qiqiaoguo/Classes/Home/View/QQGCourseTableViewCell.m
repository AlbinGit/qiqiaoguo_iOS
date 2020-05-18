//
//  QQGCourseTableViewCell.m
//  qiqiaoguo
//
//  Created by 李艳彬 on 2020/5/17.
//

#import "QQGCourseTableViewCell.h"
#import "BLUCircleDetailMainViewController.h"
#import "QGCourseDetailViewController.h"

@interface QQGCourseTableViewitemCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *iconImgView;

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
    CGFloat itemHeight = itemWidth*9/16;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemHeight)];
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgView.maxY, self.width, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorFromHexString:@"666666"];
    [self.contentView addSubview:_titleLabel];
	
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-36, 0, 36, 36)];
    [self.contentView addSubview:_iconImgView];

}

@end

static NSString * const QGfooterViewCellIdentifier = @"footerViewCellIdentifier";

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
    CGFloat itemHeight = itemWidth*9/16;

    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flow.minimumInteritemSpacing = 10;
    flow.minimumLineSpacing      = 0;
    flow .itemSize = CGSizeMake( itemWidth, itemHeight +50);

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
    CGFloat itemHeight = itemWidth*9/16;
    int totalCol = 2;
    int row = (_dataSource.count-1) / totalCol;
    CGFloat y = (itemHeight + 50) * row;

    if (_firstRowCellCountArray.count>0 || _dataSource.count<3) {
        
        
        _collectionView.height = y +itemHeight+50 +44;
        
        
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_firstRowCellCountArray.count>0||_dataSource.count<4 ) {
      return _dataSource.count;
    }else
    return 4;
}



- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CollectionCellId";
    QQGCourseTableViewitemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    QGCourseInfoModel *model = _dataSource[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_path] placeholderImage:nil];
    cell.titleLabel.text = model.title;
	if (model.is_new) {
		cell.iconImgView.image = [UIImage imageNamed:@"标签_new"];
	}else
	{
		if (model.is_hot) {
			cell.iconImgView.image = [UIImage imageNamed:@"标签_hot"];
		}else
		{
			cell.iconImgView.image = [UIImage imageNamed:@""];
		}
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
        
        
        
        if (_dataSource.count<5) {
            [footerView.btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [footerView.btn setImage:[UIImage imageNamed:@"drown-icon"] forState:UIControlStateNormal];
      
            [footerView.btn addClick:^(UIButton *button) {
//                UIViewController *viewController = [SAUtils findViewControllerWithView:self];
                
//                BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:_videoCircleId.integerValue];
//                [viewController.navigationController pushViewController:vc animated:YES];
                
            }];
        }else {
            
           footerView.delegate = self;
            
        }
         reusableView = footerView;
    }


    return reusableView;

}
#pragma mark  QGCollectionVideoFooterView代理
- (void)collectionVideoFooterViewMoreBtnClicked:(QGCollectionVideoFooterView *)sender {
//         PL_CODE_WEAK(ws);
//        if (sender.isOpen) {
//            CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
//            CGFloat itemHeight = itemWidth*9/16;
//            int totalCol = 2;
//            int row = (_dataSource.count-1) / totalCol;
//            CGFloat y =  (itemHeight + 50) * row;
//        [UIView animateWithDuration:0.5f animations:^{
//         [ws.firstRowCellCountArray addObject:_dataSource];
//            ws.collectionView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, y +itemHeight+50+44);
//            [sender.btn setTitle:@"查看更多" forState:UIControlStateNormal];
//            [sender.btn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:UIControlStateNormal];
//            if (ws.dataSource.count>4) {
//                if ([ws.delegate respondsToSelector:@selector(QQGCourseTableViewCellMoreBtnClicked:)]) {
//                    [ws.delegate QQGCourseTableViewCellMoreBtnClicked:self];
//                }
//
//            }
//        }];
			
			
			 PL_CODE_WEAK(ws);
			if (sender.isOpen) {
				CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
				CGFloat itemHeight = itemWidth*9/16;
				int totalCol = 2;
				int row = (_dataSource.count-1) / totalCol;
				CGFloat y =  (itemHeight + 50) * row;
			[UIView animateWithDuration:0.5f animations:^{
			 [ws.firstRowCellCountArray addObject:_dataSource];
				ws.collectionView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, y +itemHeight+50+44);
				[sender.btn setTitle:@"收起" forState:UIControlStateNormal];
				[sender.btn setImage:[UIImage imageNamed:@"ic_dropup_light"] forState:UIControlStateNormal];
				[sender.btn setImageEdgeInsets:UIEdgeInsetsMake(0, (sender.btn.titleLabel.width+12), 0, 5)];

				if (ws.dataSource.count>4) {
					if ([ws.delegate respondsToSelector:@selector(QQGCourseTableViewCellMoreBtnClicked:)]) {
						[ws.delegate QQGCourseTableViewCellMoreBtnClicked:self];
					}
				 
				}
			}];
      }else {
//        sender.open = !sender.isOpen;
//        UIViewController *viewController = [SAUtils findViewControllerWithView:self];
//        BLUCircleDetailMainViewController *vc = [[BLUCircleDetailMainViewController alloc] initWithCircleID:_videoCircleId.integerValue];
//        [viewController.navigationController pushViewController:vc animated:YES];
      
			CGFloat itemWidth  = (MQScreenW-3*10)/2.0;
		    CGFloat itemHeight = itemWidth*9/16;
		  [UIView animateWithDuration:0.5f animations:^{
		   [ws.firstRowCellCountArray removeObject:_dataSource];
			  ws.collectionView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, (itemHeight +50)*2+44);
			  [sender.btn setTitle:@"查看更多" forState:UIControlStateNormal];
			  [sender.btn setImage:[UIImage imageNamed:@"drown-icon"] forState:UIControlStateNormal];
			  [sender.btn setImageEdgeInsets:UIEdgeInsetsMake(0, (sender.btn.titleLabel.width+35)*2, 0, 5)];
			  if ([ws.delegate respondsToSelector:@selector(QQGCourseTableViewCellMoreBtnClicked:)]) {
				  [ws.delegate QQGCourseTableViewCellFoldBtnClicked:self];
			  }						
		  }];
		  
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    QGCourseInfoModel *model = _dataSource[indexPath.row];
    QGCourseDetailViewController *vc =[[QGCourseDetailViewController alloc] init];
    vc.course_id =model.course_id;
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDelegateFlowLayout Method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MQScreenW, 44);
}

@end




