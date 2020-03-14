//
//  QGOrgTeacherTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import <UIKit/UIKit.h>
#import "QGTeacherListModel.h"
#import "QGEduTeacherModel.h"
@interface QGTeacherListTableViewCell : UITableViewCell

@property (nonatomic,strong) QGTeacherListModel *teacherModel;
@property (weak, nonatomic) IBOutlet UIView *linelab;

@property (nonatomic,strong) QGEduTeacherModel *model;
@property (weak, nonatomic) IBOutlet UILabel *teachername;
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *teacherdeil;
@end
