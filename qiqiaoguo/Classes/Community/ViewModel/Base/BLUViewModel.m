//
//  BLUViewModel.m
//  Blue
//
//  Created by Bowen on 1/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@implementation BLUViewModel

@synthesize didBecomeActiveSignal = _didBecomeActiveSignal;
@synthesize didBecomeInactiveSignal = _didBecomeInactiveSignal;


- (void)setActive:(BOOL)active {
    if (active == _active) return;
    
    [self willChangeValueForKey:@keypath(self.active)];
    _active = active;
    [self didChangeValueForKey:@keypath(self.active)];
}

- (RACSignal *)didBecomeActiveSignal {
    if (_didBecomeActiveSignal == nil) {
        @weakify(self);
        
        _didBecomeActiveSignal = [[[RACObserve(self, active)
                                    filter:^(NSNumber *active) {
                                        return active.boolValue;
                                    }]
                                   map:^(id _) {
                                       @strongify(self);
                                       return self;
                                   }]
                                  setNameWithFormat:@"%@ -didBecomeActiveSignal", self];
    }
    
    return _didBecomeActiveSignal;
}

- (RACSignal *)didBecomeInactiveSignal {
    if (_didBecomeInactiveSignal == nil) {
        @weakify(self);
        
        _didBecomeInactiveSignal = [[[RACObserve(self, active)
                                      filter:^ BOOL (NSNumber *active) {
                                          return !active.boolValue;
                                      }]
                                     map:^(id _) {
                                         @strongify(self);
                                         return self;
                                     }]
                                    setNameWithFormat:@"%@ -didBecomeInactiveSignal", self];
    }
    
    return _didBecomeInactiveSignal;
}
- (RACSignal *)sendRACError{
    
  return  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendError:[NSError new]];
        return nil;
    }];
}

@end

@implementation BLUViewModel (Fetch)
@end
