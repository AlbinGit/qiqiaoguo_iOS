//
//  QGNewTeacherMulImgCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QGNewTeacherMulImgCell,QGNewTeacherStateModel;

@protocol QGNewTeacherMulImgCellDelegate <NSObject>
- (void)mulImgCell:(QGNewTeacherMulImgCell *)bigImgCell shareBtnIndexPath:(NSIndexPath *)indexPath;
- (void)mulImgCell:(QGNewTeacherMulImgCell *)bigImgCell praiseBtnIndexPath:(NSIndexPath *)indexPath;
- (void)mulImgCell:(QGNewTeacherMulImgCell *)bigImgCell commentBtnIndexPath:(NSIndexPath *)indexPath;
@end
@interface QGNewTeacherMulImgCell : UITableViewCell

@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) NSIndexPath *myIndexpath;
@property (nonatomic,strong)UILabel * priseNum;
@property (nonatomic,weak) id<QGNewTeacherMulImgCellDelegate> delegate;
@property (nonatomic,strong) QGNewTeacherStateModel *model;

@end

NS_ASSUME_NONNULL_END
