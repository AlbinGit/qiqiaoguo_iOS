//
//  QGVideoListCollectionViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import <UIKit/UIKit.h>



@interface QGVideoListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *videoTitle;

@property (weak, nonatomic) IBOutlet UILabel *videoCount;


@end
