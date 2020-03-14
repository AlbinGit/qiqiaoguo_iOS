//
//  BLUCoinLog.h
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUCoinLog : BLUObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, assign, readonly) NSInteger profit;

- (NSString *)profitDesc;

@end
