//
//  QGNewFeatureCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/26.
//
//

#import <UIKit/UIKit.h>

@interface QGNewFeatureCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) UIImageView *imageView;
// 告诉cell是不是最后一个cell
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
