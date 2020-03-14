//
//  BLUApSettingViewModel.h
//  Blue
//
//  Created by Bowen on 12/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"



@class BLUAPSetting;

@interface BLUApSettingViewModel : BLUViewModel

@property (nonatomic, strong) BLUAPSetting *setting;

@property (nonatomic, strong, readonly) NSArray *titleSections;
@property (nonatomic, strong, readonly) NSArray *stateSections;

@property (nonatomic, strong) RACDisposable *fetchDisposable;
@property (nonatomic, strong) RACDisposable *deleteDisposable;

- (RACSignal *)fetch;
- (RACSignal *)sendSetting:(BLUAPSetting *)setting;

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
- (NSNumber *)stateAtIndexPath:(NSIndexPath *)indexPath;

- (RACSignal *)switchAtIndexPath:(NSIndexPath *)indexPath;

@end
