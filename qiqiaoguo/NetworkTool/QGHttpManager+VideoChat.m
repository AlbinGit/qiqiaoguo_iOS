//
//  QGHttpManager+VideoChat.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/7.
//

#import "QGHttpManager+VideoChat.h"



@implementation QGHttpManager (VideoChat)

+ (void)putWithURLString:(NSString *)URLString
			  parameters:(id)parameters
			     success:(void (^)(id result))success
			     failure:(void (^)(NSError * error))failure
{
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	   
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.requestSerializer = [AFHTTPRequestSerializer serializer];
	
	manager.securityPolicy.allowInvalidCertificates = YES;
	manager.securityPolicy.validatesDomainName = NO;

	   [manager PUT:[NSString stringWithFormat:@"https://t.live.qiqiaoguo.com/%@",URLString] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		   
		   if (success) {
			   success(responseObject);
		   }
	   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

		   if (failure) {
			   failure(error);
		   }
	   }];
	
	
	
}


@end
