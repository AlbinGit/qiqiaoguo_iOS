//
//  QGHttpManager+VideoChat.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/7.
//


#import "QGHttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGHttpManager (VideoChat)
+ (void)putWithURLString:(NSString *)URLString
			  parameters:(id)parameters
				 success:(void (^)(id result))success
				 failure:(void (^)(NSError * error))failure ;


@end

NS_ASSUME_NONNULL_END
