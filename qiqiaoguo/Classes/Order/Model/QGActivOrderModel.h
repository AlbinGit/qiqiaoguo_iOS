//
//  QGActivOrderModel.h
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGModel.h"
#import "QGMallOrderModel.h"

@interface QGActivOrderModel : QGModel

@property (nonatomic, strong) QGMallOrderModel *mallOrder;
@property (nonatomic, assign) NSInteger activID;
@property (nonatomic, copy) NSString *activTitle;
@property (nonatomic, copy) NSString *coverPicOrgImage;
@property (nonatomic, copy) NSString *typeName;

@end
