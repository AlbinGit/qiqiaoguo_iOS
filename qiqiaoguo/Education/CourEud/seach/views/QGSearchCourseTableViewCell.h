//
//  QGSearchCourseTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import <UIKit/UIKit.h>
#import "QGCourseInfoModel.h"
#import "QGEduHomeResult.h"
#import "QGOrgAllCourseModel.h"
typedef void(^QGSearchCourseTableViewCellBlock)(QGCourseInfoModel * model);
@interface QGSearchCourseTableViewCell : UITableViewCell
/**课程模型*/ 
@property (nonatomic, strong) QGCourseInfoModel * model;

@property (nonatomic, strong)  QGCourseTagModel *taglistModel;
@property (nonatomic, strong)  NSArray *taglist;
@property (nonatomic,strong) QGTypeView* view;
// 报名按钮点击回调
- (void)signUpBtnClicked:(QGSearchCourseTableViewCellBlock)block;
@property (nonatomic,assign) CGFloat cellH;
@end
