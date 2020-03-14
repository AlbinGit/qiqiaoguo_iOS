//
//  QGSubjectView.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/5/23.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGEduHomeResult.h"

typedef void(^QGSubjectViewBlock)(QGEducateListtModel * model);

@interface QGSubjectView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (void)addDataToImageArray:(NSArray *)array;
- (void)tapModel:(QGSubjectViewBlock)block;

@end
