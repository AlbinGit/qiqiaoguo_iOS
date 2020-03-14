//
//  QGEduGroupCollectionViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/30.
//
//

#import <UIKit/UIKit.h>
#import "QGEduHomeResult.h"

@interface QGEduGroupCollectionViewCell : UICollectionViewCell

- (void)setImageForCellWithIndexpath:(NSIndexPath*)indexpath;

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;

@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (nonatomic,strong) QGEduHomeResult *model;

@end
