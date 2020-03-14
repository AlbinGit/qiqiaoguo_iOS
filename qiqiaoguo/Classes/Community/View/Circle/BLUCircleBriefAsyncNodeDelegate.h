//
//  BLUCircleBriefAsyncNodeDelegate.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUCircle;
@class BLUCircleBriefAsyncNode;

@protocol BLUCircleBriefAsyncNodeDelegate <NSObject>

- (void)shouldChangeFollowStateForCircle:(BLUCircle *)circle
                                    from:(BLUCircleBriefAsyncNode *)node
                                  sender:(id)sender;

@end
