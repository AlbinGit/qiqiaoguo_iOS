//
//  QGNearActSignCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import <UIKit/UIKit.h>
#import "QGNearActSignModel.h"

@interface QGActSignCell : UITableViewCell

@property (nonatomic, strong)UILabel *titLabel;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)QGNearActSignModel *signModel;
@property (nonatomic,strong) QGActlistQuantityModel *vc;
@property (nonatomic, strong)NSMutableDictionary *infoDic;
@property (nonatomic,strong) UILabel *line;
@property (nonatomic,strong) NSMutableArray *applyArr;
@end
