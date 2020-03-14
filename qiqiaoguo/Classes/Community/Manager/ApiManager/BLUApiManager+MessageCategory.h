//
//  BLUApiManager+MessageCategory.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager.h"

@interface BLUApiManager (MessageCategory)

- (RACSignal *)fetchMessageCategories;

@end
