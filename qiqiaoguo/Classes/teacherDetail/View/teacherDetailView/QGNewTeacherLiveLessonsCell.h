//
//  QGNewTeacherLiveLessonsCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/11.
//

//#import "QGNewteacherLessonsCell.h"
#import <UIKit/UIKit.h>

@class QGNewCatalogModel;

typedef void (^LiveVideoBlock)(QGNewCatalogModel * model);

NS_ASSUME_NONNULL_BEGIN

@interface QGNewTeacherLiveLessonsCell : UITableViewCell
@property (nonatomic,strong) QGNewCatalogModel *model;
@property (nonatomic,copy) LiveVideoBlock liveVideoBlock;
@property (nonatomic,strong) UIButton *lookVideoBtn;

@end

NS_ASSUME_NONNULL_END
