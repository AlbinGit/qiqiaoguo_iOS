//
//  BLUViewModelDelegate.h
//  Blue
//
//  Created by Bowen on 22/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLUViewModel;

@protocol BLUViewModelDelegate <NSObject>

- (void)viewModel:(BLUViewModel *)viewModel didMeetError:(NSError *)error;

- (void)viewModel:(BLUViewModel *)viewModel didSuccessWithMessage:(NSString *)message;

@end
