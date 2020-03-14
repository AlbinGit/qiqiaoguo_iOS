//
//  QGHttpManager+Message.m
//  qiqiaoguo
//
//  Created by cws on 16/6/30.
//
//

#import "QGHttpManager+Message.h"
#import "QGMessageListModel.h"


#define QGCardMessage        (BLUApiString(@"/Phone/Message/getCouponMsgList"))
#define QGOrderMessage       (BLUApiString(@"/Phone/Message/getOrderMsgList"))
#define QGActivMessage       (BLUApiString(@"/Phone/Message/getActivityMsgList"))
#define QGEduOrderMessage         (BLUApiString(@"/Phone/Message/getEduOrderMsgList"))

@implementation QGHttpManager (Message)

+ (void)getCardMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSDictionary *parameters = @{@"page":page, @"platform_id":PLATFORMID};
    [self POST:QGCardMessage params:parameters resultClass:[QGMessageListModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

+ (void)getOrderMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSDictionary *parameters = @{@"page":page, @"platform_id":PLATFORMID};
    [self POST:QGOrderMessage params:parameters resultClass:[QGMessageListModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

+ (void)getActivMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSDictionary *parameters = @{@"page":page, @"platform_id":PLATFORMID};
    [self POST:QGActivMessage params:parameters resultClass:[QGMessageListModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

+ (void)getEduMessageWithPage:(NSNumber *)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure
{
    NSDictionary *parameters = @{@"page":page, @"platform_id":PLATFORMID};
    [self POST:QGEduOrderMessage params:parameters resultClass:[QGMessageListModel class] objectKeyPath:QGApiObjectKeyItems success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

@end
