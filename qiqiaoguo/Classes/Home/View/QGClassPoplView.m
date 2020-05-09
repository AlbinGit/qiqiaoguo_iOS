//
//  QGClassPoplView.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/8.
//

#import "QGClassPoplView.h"
#import "QGCollectionViewClassCell.h"
#import "QGSerachViewController.h"
#import "QGClassModel.h"
static NSString * cell_id = @"cell_id";
static const CGFloat kLineSpaceing = 15;  // 行间距 横向
static const CGFloat kItermSpaceing = 15;  // 列间距 纵向之间的间距

@interface QGClassPoplView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UIView *titleView;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *categoryButton;
//@property (nonatomic,strong) UIButton *localButton;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *sublistArray;

@end

@implementation QGClassPoplView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        _imageArray = [[NSMutableArray alloc]init];
        [self p_creatUI];
		[self p_configData];
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
		QGClassModel * model = _dataArray[indexPath.section];

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
			sectionTitle.text = model.category_name;
			[headSectionView addSubview:sectionTitle];
			return headSectionView;
		}
			
	return nil;
}
#pragma mark dataSource 数据源
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return _dataArray.count;
}
//Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	QGClassModel *model;
	if (_dataArray.count>0) {
		model= _dataArray[section];
	}

	return model.sublist.count;
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
	QGClassModel * model;
	QGClassListModel * subModel;
	if (_dataArray.count>0) {
		model = _dataArray[indexPath.section];
		subModel = model.sublist[indexPath.row];
	}
		
	QGCollectionViewClassCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
		dispatch_async(dispatch_get_main_queue(), ^{
			NSIndexPath * myIndexPath;
			NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULTS_IndexPath];
			NSArray * arr = [str componentsSeparatedByString:@"-"];
			if (arr.count>0) {
				myIndexPath = [NSIndexPath indexPathForRow:[arr[0] integerValue] inSection:[arr[1] integerValue]];
				if (indexPath == myIndexPath) {
					[self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
				}
			}			
		});
		cell.model = subModel;
		return cell;
}
//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NLog(@"点击了item %ld",indexPath.row)
	QGClassModel * model;
	QGClassListModel * subModel;
	if (_dataArray.count>0) {
		model = _dataArray[indexPath.section];
		subModel = model.sublist[indexPath.row];
	}
	if (_selectBlock) {
		_selectBlock(subModel,indexPath);
	}
//	[_categoryButton setTitle:subModel.title];
	[self updateCategoryBtnFrameWithTitle:subModel.title];
	[self removeFromSuperview];

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
	_categoryButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
	_categoryButton.titleColor = QGTitleColor;
	UIImage *image = [[UIImage imageNamed:@"search-drop-down-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[_categoryButton setImage:image forState:UIControlStateNormal];
	_categoryButton.titleLabel.font = FONT_CUSTOM(18);
	[_categoryButton setTitle:[SAUserDefaults getValueWithKey:USERDEFAULTS_Class]];
	[_categoryButton.imageView sizeToFit];
	[_categoryButton.titleLabel sizeToFit];
	_categoryButton.frame = CGRectMake(12, 10, edgeBtnWidth, 40);
	[_categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, _categoryButton.titleLabel.width+5, 0, -_categoryButton.titleLabel.width-5)];
	[_categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_categoryButton.imageView.width-5 , 0, _categoryButton.imageView.width)];
//	[self updateCategoryBtnFrameWithTitle:[SAUserDefaults getValueWithKey:@"USERDEFAULTS_Class"]];
	_categoryButton.backgroundColor = [UIColor whiteColor];
	[_titleView addSubview:_categoryButton];
		
	UIButton * localBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	localBtn.frame = CGRectMake(SCREEN_WIDTH-edgeBtnWidth-50-12 , 10, edgeBtnWidth+50, 40);
//	[localBtn setTitle:@"北京"];
	UIImage *image2 = [[UIImage imageNamed:@"search-drop-down-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[localBtn setImage:image2 forState:UIControlStateNormal];
	[localBtn setImageEdgeInsets:UIEdgeInsetsMake(0, localBtn.titleLabel.width+5, 0, -localBtn.titleLabel.width-5)];
	[localBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -localBtn.imageView.width-5 , 0, localBtn.imageView.width)];
	[localBtn setTitleColor:QGTitleColor];
	[_titleView addSubview:localBtn];
	_localButton = localBtn;

}

- (void)p_configData
{
	_dataArray = [NSMutableArray array];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"]
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getSystemCategory",QG_NEW_APIURLString] params:param success:^(id responseObj) {
		NLog(@"%@",responseObj);
		_dataArray = [QGClassModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];
		[_collectionView reloadData];
	} failure:^(NSError *error) {
		
	}];

}

- (void)updateCategoryBtnFrameWithTitle:(NSString *)title
{
    CGSize btntitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_categoryButton.titleFont, NSFontAttributeName, nil]];
    float citybtnW = 18 + btntitleSize.width;
    [_categoryButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:citybtnW]);
		make.left.mas_offset(12);
		make.top.mas_offset(10);
		make.height.mas_equalTo(40);
    }];
    [_categoryButton setTitle:title];
    [_categoryButton.titleLabel sizeToFit];
    [_categoryButton.imageView sizeToFit];
    [_categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, _categoryButton.titleLabel.width+5, 0, -_categoryButton.titleLabel.width-5)];
    [_categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_categoryButton.imageView.width-5 , 0, _categoryButton.imageView.width)];
}
- (void)cityBtnFrameWithTitle:(NSString *)title
{
    CGSize btntitleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_localButton.titleFont, NSFontAttributeName, nil]];
    float citybtnW = 18 + btntitleSize.width;
    [_localButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:citybtnW]);
		make.right.mas_offset(-12);
		make.top.mas_offset(10);
		make.height.mas_equalTo(40);
    }];
    [_localButton setTitle:title];
    [_localButton.titleLabel sizeToFit];
    [_localButton.imageView sizeToFit];
    [_localButton setImageEdgeInsets:UIEdgeInsetsMake(0, _localButton.titleLabel.width+5, 0, -_localButton.titleLabel.width-5)];
    [_localButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_localButton.imageView.width-5 , 0, _localButton.imageView.width)];
}

@end
