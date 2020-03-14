//
//  BLUExpRule
//  Blue
//
//  Created by Bowen on 13/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLULevelSpec.h"

@implementation BLULevelSpec

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"minimumExp":      @"min_quantity",
             @"maximumExp":   @"max_quantity",
             @"rank":       @"rank",
             @"title":   @"title",
             };
}

@end
