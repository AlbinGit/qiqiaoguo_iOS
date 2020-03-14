//
//  BLUSendPostViewModel.h
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewModel.h"

@interface BLUSendPostViewModel : BLUViewModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSInteger circleID;
@property (nonatomic, assign) BOOL anonymousEnable;

- (RACCommand *)send;

@end
