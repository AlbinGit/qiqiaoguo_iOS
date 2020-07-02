//
//  QGRecordVideoController.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import <UIKit/UIKit.h>
#import "QGNewCatalogModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QGRecordVideoController : UIViewController
@property (nonatomic,copy) NSString *teacherImgUrl;
@property (nonatomic,copy) NSString *teacherName;
@property (nonatomic,assign) NSInteger course_id;

@property (nonatomic,strong) QGNewCatalogModel *model;

@end

NS_ASSUME_NONNULL_END
