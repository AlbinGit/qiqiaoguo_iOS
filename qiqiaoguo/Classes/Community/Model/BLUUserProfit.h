//
//  BLUUserProfit.h
//  Blue
//
//  Created by Bowen on 17/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUUserProfit : BLUObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger coin;
@property (nonatomic, assign, readonly) NSInteger exp;

- (NSString *)coinDesc;
- (NSString *)expDesc;

@end
