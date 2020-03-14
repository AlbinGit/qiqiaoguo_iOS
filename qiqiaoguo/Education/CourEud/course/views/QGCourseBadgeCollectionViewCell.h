//
//  QGCourseBadgeCollectionViewCell.h
//  LongForTianjie
//
//  Created by Albin on 15/11/13.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGCourseBadgeCollectionViewCell : UICollectionViewCell

/**班课标签图片*/
@property(nonatomic,strong)UIImageView *imageView;
/**标签名称*/
@property(nonatomic,strong)SALabel *titleLabel;
/**标签宽度*/
@property(nonatomic,assign)NSInteger cellWidth;


@end
