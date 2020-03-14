//
//  QGOrgViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/2.
//
//

#import "QGViewController.h"

@interface QGOrgViewController : QGViewController<UITableViewDataSource,UITableViewDelegate>

/**机构ID*/
@property (nonatomic,copy)NSString *org_id;

@end
