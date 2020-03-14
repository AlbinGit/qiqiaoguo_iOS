//
//  QGPayResultViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/3.
//
//

#import "QGViewController.h"

typedef NS_ENUM(NSUInteger, QGPayResultType) {
    QGPayResultTypeActiv=0,
    QGPayResultTypeMall,
    QGPayResultTypeEdu,
};

@interface QGPayResultViewController : QGViewController

@property (nonatomic,copy)NSString *activity_id;
@property (nonatomic, assign) QGPayResultType type;
@property (nonatomic, assign) NSInteger orderID;
@property (nonatomic,copy)NSString *edu_id;
@end
