//
//  BLUPostDetailViewController.h
//  Blue
//
//  Created by Bowen on 11/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@interface BLUPostDetailViewController : BLUViewController

@property (nonatomic, assign, readonly) NSInteger postID;

- (instancetype)initWithPostID:(NSInteger)postID;

@end
