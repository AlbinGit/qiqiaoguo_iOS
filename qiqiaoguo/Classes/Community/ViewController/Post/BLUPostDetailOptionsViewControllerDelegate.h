//
//  BLUPostDetailOptionsViewControllerDelegate.h
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPostDetailOptionsViewController;
@class BLUPost;

@protocol BLUPostDetailOptionsViewControllerDelegate <NSObject>

- (void)shouldChangeCollectionStateForPost:(BLUPost *)post
                        fromViewController:(BLUPostDetailOptionsViewController *)viewController
                                    sender:(id)sender;

- (void)shouldReportPost:(BLUPost *)post
      fromViewController:(BLUPostDetailOptionsViewController *)viewController
                  sender:(id)sender;

- (void)shouldReverseCommentFromViewController:(BLUPostDetailOptionsViewController *)viewController
                                        sender:(id)sender;

@end
