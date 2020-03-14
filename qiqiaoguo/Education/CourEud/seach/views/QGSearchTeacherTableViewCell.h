//
//  QGSearchTeacherTableViewCell.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/17.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGEduTeacherModel.h"
#import <CoreLocation/CoreLocation.h>//封装了系统自带的GPS定位功能
#import <MapKit/MapKit.h>

@interface QGSearchTeacherTableViewCell : UITableViewCell
/**老师模型*/ 
@property (nonatomic, strong) QGEduTeacherModel * model;

@end
