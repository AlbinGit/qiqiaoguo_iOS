//
//  BLUUserBalance.h
//  Blue
//
//  Created by Bowen on 20/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

UIKIT_EXTERN NSString *BLUUserBalanceCoinWarningNotification;

#import "BLUObject.h"

@interface BLUUserBalance : BLUObject

@property (nonatomic, assign, readonly) NSInteger coin;
@property (nonatomic, assign, readonly) NSInteger exp;
@property (nonatomic, assign, readonly) NSInteger level;
@property (nonatomic, assign, readonly) NSString *coinWarningMessage;

- (void)checkCoin;

@end
