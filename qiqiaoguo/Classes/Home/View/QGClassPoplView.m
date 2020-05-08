//
//  QGClassPoplView.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/8.
//

#import "QGClassPoplView.h"
#import "QGCollectionViewClassCell.h"
#import "QGSerachViewController.h"
static NSString * cell_id = @"cell_id";
static const CGFloat kLineSpaceing = 15;  // 行间距 横向
static const CGFloat kItermSpaceing = 15;  // 列间距 纵向之间的间距

@interface QGClassPoplView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIView *titleView;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *categoryButton;
@property (nonatomic,strong) UILabel *localLabel;

@end

@implementation QGClassPoplView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        _imageArray = [[NSMutableArray alloc]init];
        [self p_creatUI];
    }
    return self;
}
- (void)p_creatUI
{
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.cancleBtn];
	[self addSubview:self.titleView];
	[self p_creatCollectionView];
	[self p_creatTitleSubView];
}
- (void)p_creatCollectionView
{
	UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
	flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;//垂直
	[flowLayout setMinimumLineSpacing:kLineSpaceing];//行
	[flowLayout setMinimumInteritemSpacing:kItermSpaceing];//列
	[flowLayout setSectionInset:UIEdgeInsetsMake(0, kLineSpaceing, 0, kLineSpaceing)];
	
	self.collectionView = ({
		UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _titleView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_titleView.height-_cancleBtn.height-Height_TapBar) collectionViewLayout:flowLayout];
		collectionView.backgroundColor = [UIColor whiteColor];
		//注册cell
		[collectionView registerClass:[QGCollectionViewClassCell class] forCellWithReuseIdentifier:cell_id];

		//注册头尾视图
		[collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		[self addSubview:collectionView];
		collectionView;
	});
	
}
#pragma collection
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	NSArray * arr = @[@"幼儿园",@"一年级",@"高中"];
		if (kind == UICollectionElementKindSectionHeader) {
			static NSString * colID = @"Header";
			UICollectionReusableView * headSectionView = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
			headSectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:colID forIndexPath:indexPath];
			headSectionView.backgroundColor = [UIColor whiteColor];

			for (UIView * view in headSectionView.subviews) {
				[view removeFromSuperview];
			}

			UILabel * sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,SCREEN_WIDTH-30, 50)];
			sectionTitle.textAlignment = NSTextAlignmentLeft;
			sectionTitle.textColor = [UIColor blackColor];
			sectionTitle.font = FONT_SYSTEM(18);
			sectionTitle.text = arr[indexPath.section];
			[headSectionView addSubview:sectionTitle];
			return headSectionView;
		}
			
	return nil;
}
#pragma mark dataSource 数据源
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 3;
}
//Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	if (section == 0) {
		return 3;
	}
	else if(section == 1)
	{
		return 5;
	}else
	{
		return 6;
	}
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake((SCREEN_WIDTH-kLineSpaceing*4)/3, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
	return CGSizeMake(SCREEN_WIDTH-30, 50);

}
//Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
		QGCollectionViewClassCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (indexPath.section ==0&&indexPath.row == 1) {
				[self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
			}
		});
		return cell;
}
//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"点击了item %ld",indexPath.row)
	if (_selectBlock) {
		_selectBlock(@"选择的年级");
	}
}


#pragma lazy
- (UIButton *)cancleBtn
{
	if (!_cancleBtn) {
		PL_CODE_WEAK(weakSelf);
		_cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_cancleBtn.backgroundColor = [UIColor blackColor];
		_cancleBtn.alpha = 0.3;
		_cancleBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 280);
		[_cancleBtn addClick:^(UIButton *button) {
			NSLog(@"取消");
			[weakSelf removeFromSuperview];
		}];
	}
	return _cancleBtn;
}
-(UIView *)titleView
{
	if (!_titleView) {
		_titleView = [[UIView alloc]initWithFrame:CGRectMake(0, _cancleBtn.bottom, SCREEN_WIDTH, 60)];
		_titleView.backgroundColor = [UIColor whiteColor];
	}
	return _titleView;
}

- (void)p_creatTitleSubView
{
	CGFloat edgeBtnWidth = 50;
	CGFloat marginX = 20;
	_categoryButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
	_categoryButton.titleColor = QGTitleColor;
	UIImage *image = [[UIImage imageNamed:@"search-drop-down-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[_categoryButton setImage:image forState:UIControlStateNormal];
	[_categoryButton.imageView sizeToFit];
	[_categoryButton setTitle:@"小班"];
	_categoryButton.titleLabel.font = FONT_CUSTOM(18);
	[_categoryButton.titleLabel sizeToFit];
	_categoryButton.frame = CGRectMake(10, 10, edgeBtnWidth, 40);
	[_categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, _categoryButton.titleLabel.width+5, 0, -_categoryButton.titleLabel.width-5)];
	[_categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_categoryButton.imageView.width-5 , 0, _categoryButton.imageView.width)];
	_categoryButton.backgroundColor = [UIColor whiteColor];
	[_titleView addSubview:_categoryButton];
	
	UIButton * bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	bgBtn.frame = CGRectMake(_categoryButton.right+marginX , 10, SCREEN_WIDTH-(edgeBtnWidth+marginX)*2, 40);
	bgBtn.layer.masksToBounds = YES;
	bgBtn.layer.cornerRadius = 15;
	[bgBtn addClick:^(UIButton *button) {		
		UIViewController *viewController =[SAUtils findViewControllerWithView:self];
		QGSerachViewController * vc = [[QGSerachViewController alloc]init];
		[viewController.navigationController pushViewController:vc animated:YES];
	}];
	bgBtn.backgroundColor = PL_COLOR_230;
	[_titleView addSubview:bgBtn];
	
    //搜索图片
    UIImageView *serchImv = [[UIImageView alloc]initWithFrame:CGRectMake(7, 25/2, 15, 15)];
    serchImv.image = [UIImage imageNamed:@"icon_classification_search"];
    [bgBtn addSubview:serchImv];//search-drop-down-icon

	UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(serchImv.right+5, 0, bgBtn.width-7-serchImv.width, bgBtn.height)];
	label.text = @"输入商家、分类或商圈";
	label.font = FONT_SYSTEM(14);
	label.textColor = PL_COLOR_gray;
	[bgBtn addSubview:label];
	
	_localLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgBtn.right+5, _categoryButton.y, edgeBtnWidth, 40)];
	_localLabel.text = @"北京";
	_localLabel.backgroundColor = [UIColor whiteColor];
	_localLabel.textAlignment = NSTextAlignmentCenter;
	_localLabel.textColor = [UIColor blackColor];
	[_titleView addSubview:_localLabel];
	
}




@end
