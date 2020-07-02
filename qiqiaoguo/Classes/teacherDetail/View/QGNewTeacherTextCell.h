//
//  QGNewTeacherCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QGNewTeacherTextCell,QGNewTeacherStateModel;

@protocol QGNewTeacherTextCellDelegate <NSObject>
- (void)textCell:(QGNewTeacherTextCell *)textCell shareBtnIndexPath:(NSIndexPath *)indexPath;
- (void)textCell:(QGNewTeacherTextCell *)textCell praiseBtnIndexPath:(NSIndexPath *)indexPath;
- (void)textCell:(QGNewTeacherTextCell *)textCell commentBtnIndexPath:(NSIndexPath *)indexPath;
@end

@interface QGNewTeacherTextCell : UITableViewCell
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong)UILabel * priseNum;

@property (nonatomic,strong) NSIndexPath *myIndexpath;
@property (nonatomic,weak) id<QGNewTeacherTextCellDelegate> delegate;
@property (nonatomic,strong) QGNewTeacherStateModel *model;

@end

NS_ASSUME_NONNULL_END
