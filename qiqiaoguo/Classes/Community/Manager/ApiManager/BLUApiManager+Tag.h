//
//  BLUApiManager+Tag.h
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApiManager.h"

@class BLUPostTag;

@interface BLUApiManager (Tag)

- (RACSignal *)fetchTagWithTagID:(NSInteger)tagID;

@end
