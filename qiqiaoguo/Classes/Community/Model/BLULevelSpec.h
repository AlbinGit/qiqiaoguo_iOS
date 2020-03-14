//
//  BLUExpRule
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLULevelSpec : BLUObject

@property (nonatomic, assign, readonly) NSInteger minimumExp;
@property (nonatomic, assign, readonly) NSInteger maximumExp;
@property (nonatomic, assign, readonly) NSInteger rank;
@property (nonatomic, copy, readonly) NSString *title;

@end
