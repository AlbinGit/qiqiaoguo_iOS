//
//  QGActivityDetailViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/6.
//
//

#import "QGViewController.h"

@interface QGActivityDetailViewController : QGViewController
/**活动id*/
@property (nonatomic,copy)NSString *activity_id;
@property (nonatomic,strong) NSArray *ticketList;
@property (nonatomic,copy)NSString *sign_tips;//已有报名
@end
