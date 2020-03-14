//
//  BLUUserPostsViewController.h
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@class BLUPostViewModel;

@interface BLUUserPostsViewController : BLUViewController

@property (nonatomic, strong) BLUPostViewModel *postViewModel;
@property (nonatomic, assign, getter=isEditAble) BOOL editAble;

- (instancetype)initWithPostViewModel:(BLUPostViewModel *)postViewModel;

@end
