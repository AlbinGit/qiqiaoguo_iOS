//
//  QGHomePostListV2Cell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/8.
//
//

#import <UIKit/UIKit.h>

#import "QGPostListModel.h"
@interface QGHomePostListV2Cell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *postContent;

@property (nonatomic,strong)  QGPostListModel *po;
@end
