//
//  QGProductDetailsViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import "QGViewController.h"

#import "BLUShareManagerDelegate.h"

@interface QGProductDetailsViewController : QGViewController <BLUShareManagerDelegate>
@property (nonatomic,copy) NSString *goods_id;
@end
