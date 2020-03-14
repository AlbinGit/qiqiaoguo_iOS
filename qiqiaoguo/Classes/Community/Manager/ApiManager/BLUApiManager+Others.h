//
//  BLUApiManager+Others.h
//  Blue
//
//  Created by Bowen on 17/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUApiManager.h"

@class BLUAPSetting;

@interface BLUApiManager (Others)

- (RACSignal *)checkoutVersion;

- (RACSignal *)fetchWechatUserInfoWithAccessToken:(NSString *)accessToken openID:(NSString *)openID;

- (RACSignal *)postRegistrationID:(NSString *)registrationID;

- (RACSignal *)fetchAPSetting;

- (RACSignal *)postAPSetting:(BLUAPSetting *)setting;

- (RACSignal *)fetchRecommended;

- (RACSignal *)fetchRecommendedWithPagination:(BLUPagination *)pagination;

- (RACSignal *)fetchServerNoticationWithPagination:(BLUPagination *)pagination;

- (RACSignal *)reportForObjectID:(NSInteger)objectID
                      sourceType:(NSInteger)sourceType
                      reasonType:(NSInteger)reasonType
                          reason:(NSString *)reason;

- (RACSignal *)uploadImageReses:(NSArray *)imageReses;

- (RACSignal *)fetchCustomerService;

@end
