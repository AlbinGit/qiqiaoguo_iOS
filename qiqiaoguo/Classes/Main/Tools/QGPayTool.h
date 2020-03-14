//
//  QGPayTool.h
//  LongForTianjie
//
//  Created by xiaoliang on 15/11/18.
//  Copyright © 2015年 platomix. All rights reserved.
//
typedef void(^QGPayToolBlock)(BOOL isSuccess);
#import <Foundation/Foundation.h>
#import "WXApi.h"
@class QGOrderPayModel;
@class WXApiObject;
@interface QGPayTool : NSObject
+ (instancetype)shareInstance;
- (void)commitWeiXinRequest:(PayReq *)req paySuccess:(QGPayToolBlock)success payFail:(QGPayToolBlock)fail;
- (void)commitPaiPayRequest:(QGOrderPayModel *)order withSign:(NSString *)sign paySuccess:(QGPayToolBlock)success payFail:(QGPayToolBlock)fail;
@end
