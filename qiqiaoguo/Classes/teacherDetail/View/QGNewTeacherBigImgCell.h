//
//  QGNewTeacherBigImgCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QGNewTeacherBigImgCell,QGNewTeacherStateModel;
typedef void(^PlayOriginalVideoBlock)(NSIndexPath * myIndexpath);

@protocol QGNewTeacherBigImgCellDelegate <NSObject>
- (void)bigImgCell:(QGNewTeacherBigImgCell *)bigImgCell shareBtnIndexPath:(NSIndexPath *)indexPath;
- (void)bigImgCell:(QGNewTeacherBigImgCell *)bigImgCell praiseBtnIndexPath:(NSIndexPath *)indexPath;
- (void)bigImgCell:(QGNewTeacherBigImgCell *)bigImgCell commentBtnIndexPath:(NSIndexPath *)indexPath;
@end

@interface QGNewTeacherBigImgCell : UITableViewCell
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong)UILabel * priseNum;
@property (nonatomic,strong) NSIndexPath *myIndexpath;
@property (nonatomic,weak) id<QGNewTeacherBigImgCellDelegate> delegate;
@property (nonatomic,strong) QGNewTeacherStateModel *model;
@property (nonatomic,copy) PlayOriginalVideoBlock playOriginalVideoBlock;

@end

NS_ASSUME_NONNULL_END
