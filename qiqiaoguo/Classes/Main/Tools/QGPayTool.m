//
//  QGPayTool.m
//  LongForTianjie
//
//  Created by xiaoliang on 15/11/18.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGPayTool.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "QGOrderPayModel.h"
#import "WXApiObject.h"
@implementation QGPayTool
static QGPayTool *_payTool=nil;
+ (instancetype)shareInstance
{
    
    @synchronized(self)
    {
        if (!_payTool)
        {
            _payTool=[[QGPayTool alloc]init];
        }
    }
    return _payTool;
}
//微信
- (void)commitWeiXinRequest:(PayReq *)req paySuccess:(QGPayToolBlock)success payFail:(QGPayToolBlock)fail
{
    [WXApi sendReq:req];
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.weiXin_Pay_SuccessedBlock=^(){
        if (success)
        {
            success(1);
        }
    };
    appDelegate.weiXin_Pay_FailBlock=^(){
        if (fail)
        {
            fail(0);
        }
    };

}
- (void)commitPaiPayRequest:(QGOrderPayModel *)order withSign:(NSString *)sign paySuccess:(QGPayToolBlock)success payFail:(QGPayToolBlock)fail
{


    NSString *appScheme = @"qiqiaoguopaypai";
   
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (sign!= nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",order.order_info,sign, @"RSA"];
    }
    if ([[[UIApplication sharedApplication]windows] objectAtIndex:0].hidden)
    {
        [[[UIApplication sharedApplication]windows] objectAtIndex:0].hidden=NO;
    }
  
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
         NSLog(@"resultDic===%@",resultDic);
        if (![[[UIApplication sharedApplication]windows] objectAtIndex:0].hidden)
        {
            [[[UIApplication sharedApplication]windows] objectAtIndex:0].hidden=YES;
        }
//
        NSInteger status=[resultDic[@"resultStatus"] integerValue];
        switch (status) {
            case 6001:
                    fail(0);
                break;
            case 9000:
                    success(1);
                break;
            case 6002:
                
                    fail(0);
                break;
            case 4000:
               
                    fail(0);
            case 8000:
               
                    fail(0);
            default:
                break;
        }
    }];

    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.weiXin_Pay_SuccessedBlock=^(){
        if (success)
        {
            success(1);
        }
    };

    appDelegate.weiXin_Pay_FailBlock=^(){
        if (fail)
        {
            fail(0);
        }
    };

}
@end
