//
//  QGCategroyFoodCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//


#import <UIKit/UIKit.h>
#import "QGGetGoodsListByCategoryIdHttpDownload.h"

@interface QGCategroyFoodCell : UICollectionViewCell
PropertyStrong(UIImageView,foodImv);
PropertyStrong(UILabel, foodName);
PropertyStrong(QGSublistModel, model);
PropertyStrong(QGBrandGoodsListModel, brandModel);
@end
