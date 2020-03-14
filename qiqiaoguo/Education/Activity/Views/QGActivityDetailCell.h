//
//  QGActivityDetailCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/6.
//
//

#import <UIKit/UIKit.h>
#import "QGActlistDetailModel.h"
@interface QGActivityDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *actadress;
@property (nonatomic,strong) QGActlistDetailModel*item;
@property (weak, nonatomic) IBOutlet UIButton *actTime;

@property (weak, nonatomic) IBOutlet UILabel *enddate;

@property (weak, nonatomic) IBOutlet UIButton *user_rang;




@end
