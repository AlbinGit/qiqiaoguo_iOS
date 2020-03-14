//
//  BLUPostTagSearchViewModel.h
//  Blue
//
//  Created by Bowen on 4/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUPostTagSearchViewModel : BLUViewModel

@property (nonatomic, strong, readonly) NSArray *tags;

- (RACSignal *)searchKeyword:(NSString *)keyword;

@end
