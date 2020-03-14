//
//  BLUPostDetailAllCommentsHeaderDelegate.h
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPostDetailAllCommentsHeader;

@protocol BLUPostDetailAllCommentsHeaderDelegate <NSObject>

- (void)shouldChangeCommentsReverse:(BOOL)reverse
                               from:(BLUPostDetailAllCommentsHeader *)header
                             sender:(id)sender;

@end
