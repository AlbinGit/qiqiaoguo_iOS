//
//  BLUPostDetailToolbarDelegate.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPostDetailToolbar;

@protocol BLUPostDetailToolbarDelegate <NSObject>

- (void)shouldReplyFrom:(BLUPostDetailToolbar *)toolbar
                 sender:(id)sender;

- (void)shouldShowCommentsFrom:(BLUPostDetailToolbar *)toolbar
                        sender:(id)sender;

- (void)shouldShareFrom:(BLUPostDetailToolbar *)toolbar
                 sender:(id)sender;

- (void)shouldShowOtherOptionsFrom:(BLUPostDetailToolbar *)toolbar
                            sender:(id)sender;

@end
