//
//  QGNewteacherLessonsCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QGNewCatalogModel;
typedef void (^FreeVideoBlock)(QGNewCatalogModel * model);

@interface QGNewteacherLessonsCell : UITableViewCell

@property (nonatomic,strong)UILabel * tagLabel;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,strong) UIImageView *iconImgView;
@property (nonatomic,strong) QGNewCatalogModel *model;
@property (nonatomic,copy) FreeVideoBlock freeVideoBlock;

- (void)p_creatUI;
//- (void)layoutViews;
@end

NS_ASSUME_NONNULL_END
