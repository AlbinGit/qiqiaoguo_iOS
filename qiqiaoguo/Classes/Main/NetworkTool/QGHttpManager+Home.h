//
//  QGHttpManager+Home.h
//  qiqiaoguo
//
//  Created by cws on 16/6/3.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import "QGHttpManager.h"


@interface QGHttpManager (Home)
+ (void)fetchHomeDataSuccess:(QGResponseSuccess)success failure:(QGResponseFail)failure;
@end
