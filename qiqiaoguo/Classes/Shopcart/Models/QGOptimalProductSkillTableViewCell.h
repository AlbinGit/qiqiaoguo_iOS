//
//  QGSkillTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import <UIKit/UIKit.h>

@interface QGOptimalProductSkillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *stuatsLab;

@property (weak, nonatomic) IBOutlet UILabel *timelab1;
@property (weak, nonatomic) IBOutlet UILabel *timelabe2;

@property (nonatomic,strong) QGOptimalProductResultModel *result;
@property (nonatomic,strong) QGFirstPageDataModel *dataModel;
@end
