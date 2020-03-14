//
//  BLULevelRules.h
//  Blue
//
//  Created by Bowen on 16/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLULevelRule : BLUObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger exp;

- (NSString *)expDesc;

@end
