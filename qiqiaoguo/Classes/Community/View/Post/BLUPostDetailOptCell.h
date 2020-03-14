//
//  BLUPostDetailOptCell.h
//  Blue
//
//  Created by Bowen on 6/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUUserTransitionProtocal.h"
#import "BLUPostSimpleUserCell.h"
#import "BLUUserTransitionProtocal.h"
#import "BLUPostDetailActionProtocal.h"
#import "BLUShowImageProtocol.h"
#import "BLUViewControllerRedirectDelegate.h"

@interface BLUPostDetailOptCell : BLUPostSimpleUserCell

@property (nonatomic, weak) id <BLUPostDetailActionDelegate> delegate;
@property (nonatomic, weak) id <BLUShowImageProtocol> showImageDelegate;
@property (nonatomic, weak) id <BLUViewControllerRedirectDelegate> redirectDelegate;

@end
