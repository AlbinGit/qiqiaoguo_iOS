//
//  QGHomePostListCellTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/19.
//
//

#import <UIKit/UIKit.h>
#import "QGPostListFrameModel.h"
#import "QGCell.h"

typedef void(^ClickBlock)();

@interface QGHomePostListCell : QGCell
@property (nonatomic,strong) QGPostListFrameModel *postframe;

@property (nonatomic,strong)UICollectionView *collectionView;



@property (nonatomic,copy) ClickBlock block;
@end
