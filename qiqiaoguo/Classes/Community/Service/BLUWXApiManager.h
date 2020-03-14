//
//  BLUWXApiManager.h
//  Blue
//
//  Created by Bowen on 31/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXApiDelegate;
@protocol BLUWXApiManagerDelegate;

@interface BLUWXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, weak) id <BLUWXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end

@protocol BLUWXApiManagerDelegate <NSObject>

- (void)managerDidPaymentSuccess:(BLUWXApiManager *)manger;
- (void)manager:(BLUWXApiManager *)manager didPaymentFailed:(NSError *)error;

@end
