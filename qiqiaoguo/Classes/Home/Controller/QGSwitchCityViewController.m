//
//  QGSwitchCityViewController.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/22.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGSwitchCityViewController.h"
#import "QGSwitchCityCollectionViewCell.h"
@interface QGSwitchCityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong) NSMutableArray *arrHeadname;

/**传值block*/
@property (nonatomic,copy)QGSwitchCityViewControllerBlock cityBlock;
@end

@implementation QGSwitchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createNavTitle:@"切换城市"];
    [self createNavLeftImageBtn:@"choose-city-icon"];
    PL_CODE_WEAK(ws)
    [self.leftBtn addClick:^(SAButton *button) {
         [ws.navigationController popViewControllerAnimated:YES];
    }];
    _arrHeadname = [NSMutableArray arrayWithObjects:@"已选择的城市",@"已开通城市" ,nil];
    [self createReturnButton];
    [self createUI];
}
/**
 *  初始化创建UI
 */
- (void)createUI
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    float width = (SCREEN_WIDTH - 35)/4;
    layout.itemSize=CGSizeMake(width, 29);
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing=10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10,10,10);
    _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.height) collectionViewLayout:layout];
    _collection.backgroundColor=PL_COLOR_240;
    _collection.delegate=self;
    _collection.dataSource=self;
    [_collection registerClass:[QGSwitchCityCollectionViewCell class] forCellWithReuseIdentifier:@"cityCell"];
    [_collection registerClass:[QGSwitchCityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QGSwitchCityHeaderView"];
    [self.view addSubview:_collection];
}
#pragma  mark collectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _arrHeadname.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else
    
    return _cityNames.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        QGSwitchCityCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cityCell" forIndexPath:indexPath];


        cell.cityName.text = _cityTitle;
          return cell;
    }else{
    QGSwitchCityCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cityCell" forIndexPath:indexPath];
    QGShopCityModel *shopCityModel = _cityNames[indexPath.row];
    cell.cityName.text = shopCityModel.name;
        return cell;}
}
#pragma  mark collectionDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        QGSwitchCityHeaderView *headView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QGSwitchCityHeaderView" forIndexPath:indexPath];
        headView.headerName.text=_arrHeadname[indexPath.section];
        headView.backgroundColor=PL_COLOR_240;
        reusableView=headView;
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(SCREEN_WIDTH, 50);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section == 0) {
     
    
            [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        [self getCurrentSelectCity:_cityNames[indexPath.row ]];
      [self.navigationController popViewControllerAnimated:YES];
    }
    
      
}

- (void)setCityBlock:(QGSwitchCityViewControllerBlock)cityBlock
{
    _cityBlock=cityBlock;
}
- (void)getCurrentSelectCity:(QGShopCityModel *)shopCityModel;
{
    if (_cityBlock)
    {
        _cityBlock(shopCityModel);
    }
}
@end
