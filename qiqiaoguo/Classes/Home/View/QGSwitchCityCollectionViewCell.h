//
//  QGSwitchCityCollectionViewCell.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/22.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGSwitchCityCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UILabel *cityName;
@end
@interface QGSwitchCityHeaderView : UICollectionReusableView
@property (nonatomic,strong)UILabel *headerName;
@end