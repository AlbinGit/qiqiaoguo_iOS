//
//  SARequest.m
//  AFNetworkingTestDemo
//
//  Created by Albin on 14-9-17.
//  Copyright (c) 2014年 platomix. All rights reserved.
//


#import "QGRequest.h"
//#import "UIImageView+SACache.h"

#import "SACommon.h"
#import "SAUserDefaults.h"
#import "QGHttpDownloadConst.h"
#import "SAProgressHud.h"
#import "SAUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+Hashing.h"


@interface QGRequest ()
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong)AFHTTPRequestOperation *HTTPOperation;
@property (nonatomic,copy) NSString*url;
@end

@implementation QGRequest

static QGRequest *_shareInstance = nil;
+ (QGRequest *)sharedInstance
{
    @synchronized(self)
    {
        if (!_shareInstance){
            _shareInstance = [[QGRequest alloc]init];
        }
    }
    return _shareInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _manager = [AFHTTPRequestOperationManager manager];
        
        // user agent调整
        NSString *userAgent = _manager.requestSerializer.HTTPRequestHeaders[@"User-Agent"];
        NSArray *userAgentStrComponent = [userAgent componentsSeparatedByString:@"/"];
        __block NSString *fixedUserAgent = @"qiqiaoguo";
        [userAgentStrComponent enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            if (idx != 0) {
                fixedUserAgent = [NSString stringWithFormat:@"%@/%@", fixedUserAgent, str];
            }
        }];
        [_manager.requestSerializer setValue:fixedUserAgent forHTTPHeaderField:@"User-Agent"];
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = 30.0f;
    }
    return self;
}

// get post请求
- (void)startRequest:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{

    NSString *url = [NSString stringWithFormat:@"%@",hd.path];


    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }
    NSLog( @"shuju xmqparm = %@  url =%@ hd.method=%@",hd.params,hd.path,hd.method);
    if([@"GET" isEqualToString:hd.method.uppercaseString])
    {
        _HTTPOperation=[_manager GET:@"http://api.qqg.blue69.cn/Api/Phone/getSeckillingGoodsList" parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog( @"shuju xmqparm12345678 = %@  url123456 =%@ hd.method=%@ ",hd.params,hd.path,hd.method);
              [[SAProgressHud sharedInstance] removeHudFromSuperView];
            //            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
            //            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            // NSLog(@"responseObject----->%@",string);
            NSLog(@"\r\n\r\n-------getresponseObject111 %@\r\n\r\n-------",responseObject);
            NSDictionary *resultDict = [responseObject objectForKey:@"content"][@"status"];
            // 请求成功
            if([[resultDict objectForKey:@"ret"]intValue] == 0)
            {
                if(success)
                {
                    success(responseObject);
                }
            }
            // 请求失败
            else
            {
                if(fail)
                {
                    fail(responseObject);
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeHudFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }
    else
    {

        _HTTPOperation=[_manager POST:url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"\r\n\r\n-------postresponseObject %@\r\n\r\n-------",responseObject);
            NSDictionary *resultDict= [responseObject objectForKey:@"content"][@"status"];

          

            // 请求成功
            if([[resultDict objectForKey:@"ret"]intValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }
            }

            else
            {
                if(fail)
                {
                    fail([resultDict objectForKey:@"msg"]);
                }
            }
            NSLog(@"%@requesturl",operation.request.URL);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeHudFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }
}
//
- (void)startRequestOfTianJie:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{

    

    NSString *url = [NSString stringWithFormat:@"%@%@",QGTianJieBaseURLString,hd.path];

    NSLog(@"+++++++++http request url: %@",url);

    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }

    if([@"GET" isEqualToString:hd.method.uppercaseString])
    {

        NSLog(@"get parm = %@",hd.params );
        _HTTPOperation=[_manager GET:url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"xmq = xmq GETresponseObject %@",responseObject);

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            NSString *result = [responseObject objectForKey:@"content"][@"result"];
            // 请求成功
            if ([result integerValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }

            }

            else
            {
                if(fail)
                {
                    fail([responseObject objectForKey:@"content"][@"resultDesc"]);
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }
    else
    {
        _HTTPOperation=[_manager POST:url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject %@",responseObject);
            NSString *result = [responseObject objectForKey:@"content"][@"result"];

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            // 请求成功
            if ([result integerValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }

            }

            else
            {
                if(fail)
                {
                    fail([responseObject objectForKey:@"content"][@"resultDesc"]);
                }
            }
            NSLog(@"%@requesturl",operation.request.URL);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }


}
//访问田杰的接口(国民卡格式)
- (void)startRequestGMOfTianJie:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{


     QGHttpDownload *hh = [[QGHttpDownload alloc] init];

  

     self.url = [NSString stringWithFormat:@"%@%@",QGTianJieBaseURLString,hd.path];
    NSLog(@"******http request url: %@",self.url);

    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }

    if([@"GET" isEqualToString:hd.method.uppercaseString])
    { NSLog(@"get parm111 = %@",hd.params );
        [_manager GET:self.url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject %@",responseObject);

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            NSString *result = [QGCommon isNumber:[responseObject objectForKey:@"status"][@"ret"]];
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            // 请求成功
            if ([result integerValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }
            }

            else
            {
                if(fail)
                {
                    fail([responseObject objectForKey:@"status"][@"msg"]);
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }
    else
    { NSLog(@" parmxm = %@  url %@",hd.params ,self.url);
        [_manager POST:self.url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"responseObject %@",responseObject);
            NSString *result = [QGCommon isNumber:[responseObject objectForKey:@"status"][@"ret"]];;

            NSLog(@"xmq = xmq posresponseObjectxxxxx %@",responseObject);

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            // 请求成功
            if ([result integerValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }

            }

            else
            {
                if(fail)
                {
                    fail([responseObject objectForKey:@"status"][@"msg"]);
                }
            }
            NSLog(@"%@requesturl",operation.request.URL);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }

}
- (void)startRequestGMVerificationCode:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{

    NSString *url = [NSString stringWithFormat:@"%@%@",QGTianJieBaseURLString,hd.path];

    NSLog(@"http request url: %@",url);

    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }

    if([@"GET" isEqualToString:hd.method.uppercaseString])
    {
        [_manager GET:url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject %@",responseObject);

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            NSString *result = [responseObject objectForKey:@"ret"];
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            // 请求成功
            if ([result integerValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }

            }

            else
            {
                if(fail)
                {
                    fail([responseObject objectForKey:@"msg"]);
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }
    else
    {
        [_manager POST:url parameters:hd.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject %@",responseObject);
            NSString *result = [responseObject objectForKey:@"ret"];

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            // 请求成功
            if ([result integerValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }

            }

            else
            {
                if(fail)
                {
                    fail([responseObject objectForKey:@"msg"]);
                }
            }
            NSLog(@"%@requesturl",operation.request.URL);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

            if(fail)
            {
                fail([self getErrorInfoWithCode:error.code]);
            }

        }];
    }

}

//IM
- (void)startRequestOFIM:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{

    // 本项目IM请求网络头
    int noc = arc4random() % 99;
    NSString *nocStr = [NSString stringWithFormat:@"%d", noc];
    [_manager.requestSerializer setValue:nocStr forHTTPHeaderField:@"nonce"];
    NSInteger curTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", curTime];
    [_manager.requestSerializer setValue:timeStr forHTTPHeaderField:@"curTime"];
    NSString *checkSum = [NSString stringWithFormat:@"%@%@%@%@",NIMAppId, NIMAppSecret, nocStr, timeStr];
    NSLog(@"checkSum>>>>>%@", checkSum);
    [_manager.requestSerializer setValue:[checkSum MD5Hash] forHTTPHeaderField:@"checkSum"];


    NSString *url = [NSString stringWithFormat:@"%@",hd.path];
    NSLog(@"http request url: %@",url);

    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }

    if([@"GET" isEqualToString:hd.method.uppercaseString]){
        _HTTPOperation=[_manager GET:url parameters:hd.paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            NSLog(@"responseObject %@",responseObject);
            NSDictionary *resultDict = [responseObject objectForKey:@"content"][@"status"];
            if([[resultDict objectForKey:@"ret"]intValue] == 1){// 请求成功
                if(success){
                    success(responseObject);
                }
            }else{// 请求失败
                if(fail)
                {
                    fail([resultDict objectForKey:@"msg"]);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            if(fail){
                fail([self getErrorInfoWithCode:error.code]);
            }
        }];
    }else{//POST
        _HTTPOperation=[_manager POST:url parameters:hd.paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"paramsDic>>>>>%@", hd.paramsDic);
            NSLog(@"responseObject>>>>> %@",responseObject);
            NSDictionary *resultDict= [responseObject objectForKey:@"status"];
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            // 请求成功
            if([[resultDict objectForKey:@"ret"]intValue] == 1){
                if(success){
                    success(responseObject);
                }
            }else{
                if(fail){
                    fail([resultDict objectForKey:@"msg"]);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
            if(fail){
                fail([self getErrorInfoWithCode:error.code]);
            }
        }];
    }
}

//上传头像
- (void)uploadHeadFile:(NSString *)fileName hd:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{

    NSString *url = [NSString stringWithFormat:@"%@",hd.path];
    NSLog(@"http request url: %@",url);
    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }
    [_manager POST:url parameters:hd.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        if(fileName.length >0)
        {
            NSString *filePath=[[SACommon getHeaderImageCachePath]stringByAppendingPathComponent:fileName];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (data.length>0)
            {
                [formData appendPartWithFileData:data name:@"head" fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

         NSLog(@"responseObject %@",responseObject);
         NSDictionary *resultDict = [responseObject objectForKey:@"content"][@"status"];
         // 请求成功
         if([[resultDict objectForKey:@"ret"]intValue] == 1)
         {
             if(success)
             {
                 success(responseObject);
             }
         }
         // 时效超时,重新登录
         else if([[resultDict objectForKey:@"ret"]intValue] == 5)
         {
             //            // 移除等待框
             //            [[SAProgressHud sharedInstance]removeHudFromSuperView];
             //            // 提示并退回主界面
             //            [[SAProgressHud sharedInstance]showAlertWithWindowAndPopToRoot:@"时效超时,请重新登录"];
             //            [[SAUserManager sharedInstance]deleteUserInfo];
         }
         // 请求失败
         else
         {
             if(fail)
             {
                 // NSLog(@"时效超时,重新登录");
                 PLLogData(responseObject, @"responseObject结果")
                 fail([resultDict objectForKey:@"msg"]);
                 NSString *msg=[resultDict objectForKey:@"msg"];
                 [[SAProgressHud sharedInstance]showFailWithViewWindow:msg];
             }
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

         NSLog(@"error-->%@",error);
         NSLog(@"operation: %@" , operation. responseString );

         if(fail)
         {
             fail([self getErrorInfoWithCode:error.code]);
         }
     }];
}
//上传单个图片domain为文件域名

- (void)uploaddomain:(NSString *)domain FileName:(NSString *)fileName hd:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{
  
    NSString *url = [NSString stringWithFormat:@"%@",hd.path];
    NSLog(@"http request url: %@",url);
    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }
    [_manager POST:url parameters:hd.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        if(fileName.length >0)
        {
            NSString *filePath=[[SACommon getHeaderImageCachePath]stringByAppendingPathComponent:fileName];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (data.length>0)
            {
                [formData appendPartWithFileData:data name:domain fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    }
           success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

         NSLog(@"responseObject %@",responseObject);
         NSDictionary *resultDict = [responseObject objectForKey:@"content"][@"status"];
         // 请求成功
         if([[resultDict objectForKey:@"ret"]intValue] == 1)
         {
             if(success)
             {
                 success(responseObject);
             }
         }
         // 时效超时,重新登录
         else if([[resultDict objectForKey:@"ret"]intValue] == 5)
         {
             //            // 移除等待框
             //            [[SAProgressHud sharedInstance]removeHudFromSuperView];
             //            // 提示并退回主界面
             //            [[SAProgressHud sharedInstance]showAlertWithWindowAndPopToRoot:@"时效超时,请重新登录"];
             //            [[SAUserManager sharedInstance]deleteUserInfo];
         }
         // 请求失败
         else
         {
             if(fail)
             {
                 // NSLog(@"时效超时,重新登录");
                 PLLogData(responseObject, @"responseObject结果")
                 fail([resultDict objectForKey:@"msg"]);
                 NSString *msg=[resultDict objectForKey:@"msg"];
                 [[SAProgressHud sharedInstance]showFailWithViewWindow:msg];
             }
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {

         [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

         NSLog(@"error-->%@",error);
         NSLog(@"operation: %@" , operation. responseString );

         if(fail)
         {
             fail([self getErrorInfoWithCode:error.code]);
         }
     }];
}



// 一个请求上传多张图片
- (void)uploadBatchImages:(UIImage *)image hd:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail progress:(SAProgress)progress
{
 
    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:hd.path parameters:hd.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        int i = 0;
        NSData *data = UIImageJPEGRepresentation(image, 1.0);

        NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg",[SAUtils getTimeInterval],i + 1];

        [formData appendPartWithFileData:data name:@"head" fileName:fileName mimeType:@"image/jpeg"];

    } error:nil];

    AFHTTPRequestOperation *requestOperation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [[SAProgressHud sharedInstance]removeHudFromSuperView];
        NSDictionary *resultDict = [responseObject objectForKey:@"status"];
        // 请求成功
        if([[resultDict objectForKey:@"ret"]intValue] == 1)
        {
            if(success)
            {
                success(responseObject);
            }
        }
        // 时效超时,重新登录
        else if([[resultDict objectForKey:@"ret"]intValue] == 5)
        {

        }
        // 请求失败
        else
        {
            if(fail)
            {
                fail([resultDict objectForKey:@"msg"]);
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[SAProgressHud sharedInstance]removeHudFromSuperView];
        if(fail)
        {
            fail([self getErrorInfoWithCode:error.code]);
        }
    }];

    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"--->%lld",totalBytesWritten);
        NSLog(@"--->%lld",totalBytesExpectedToWrite);
        CGFloat tempProgress = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
        if(progress)
        {
            progress(tempProgress);
        }
    }];
    [requestOperation start];
}

- (void)cancelRequest
{
    [_manager.operationQueue cancelAllOperations];
}


- (NSString *)getErrorInfoWithCode:(NSInteger)errorCode
{
    if(errorCode == 3840)
    {
        // "The operation couldn’t be completed. (Cocoa error 3840.)"
        return @"请求失败";
    }
    else if(errorCode == -1004)
    {
        // Could not connect to the server
        return @"无法连接服务器";
    }
    else if(errorCode == -1001)
    {
        // The request timed out
        return @"请求超时";
    }

    return @"请求失败";
}

- (void)uploadBatchFileWithFileNames:(NSArray *)fileNamesArray
                             hdArray:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{
    for (UIImage *image in fileNamesArray)
    {
        NSString *url = [NSString stringWithFormat:@"%@%@",QGTianJieBaseURLString,hd.path];
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:hd.method URLString:url parameters:hd.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            NSString *name = [NSString stringWithFormat:@"%f.jpg", [[NSDate date] timeIntervalSince1970]];

            [formData appendPartWithFileData:data name:@"fileSource" fileName:name mimeType:@"image/jpeg"];
        } error:nil];

        AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[SAProgressHud sharedInstance]removeHudFromSuperView];
            NSDictionary *resultDict = [responseObject objectForKey:@"status"];
            // 请求成功
            if([[resultDict objectForKey:@"ret"]intValue] == 1)
            {
                if(success)
                {
                    success(responseObject);
                }
            }
            // 请求失败
            else
            {
                if(fail)
                {
                    fail([resultDict objectForKey:@"msg"]);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[SAProgressHud sharedInstance]removeHudFromSuperView];
            if (error.code != -999)//error.code = -999 是主动取消请求
            {
                if(fail)
                {
                    fail([self getErrorInfoWithCode:error.code]);
                }
            }
        }];
        [_manager.operationQueue addOperation:operation];
    }
}

//上传多张图片(登国)
- (void)uploadManyFileWithFileNames:(NSArray *)fileNamesArray
                                 hd:(QGHttpDownload *)hd success:(SAHttpDownloadSuccess)success fail:(SAHttpDownloadFail)fail
{

    NSData *cookiesdata = [SAUserDefaults getValueWithKey:USERDEFAULTS_COOKIE];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookie];
        }
    }
    NSLog(@"http request url: %@",hd.path);
    [_manager POST:hd.path parameters:hd.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileNamesArray.count>0)
        {
            [fileNamesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.1) name:[NSString stringWithFormat:@"picture%d", (int)idx] fileName:[NSString stringWithFormat:@"picture%d.jpeg", (int)idx] mimeType:@"image/jpeg"];
            }];
        }

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        NSLog(@"responseObject %@",responseObject);
        NSDictionary *resultDict = [responseObject objectForKey:@"content"][@"status"];
        // 请求成功
        if([[resultDict objectForKey:@"ret"]intValue] == 1)
        {
            if(success)
            {
                success(responseObject);
            }
        }
        // 请求失败
        else
        {
            if(fail)
            {
                fail([resultDict objectForKey:@"msg"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
        if(fail)
        {
            fail([self getErrorInfoWithCode:error.code]);
        }
    }];

}


// 登录成功后设置cookies
- (void)setCookiesWithUrl:(NSString *)url
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [SAUserDefaults saveValue:data forKey:USERDEFAULTS_COOKIE];
}

@end
