//
//  BLUSendPost2CircleSelectorDelegate.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUSendPost2CircleSelector;

@protocol BLUSendPost2CircleSelectorDelegate <NSObject>

- (void)selectorDidTapIndicator:(id)indicator
                       selector:(BLUSendPost2CircleSelector *)selector;

@end
