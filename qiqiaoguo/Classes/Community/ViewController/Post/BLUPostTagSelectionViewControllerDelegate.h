//
//  BLUPostTagSelectionViewControllerDelegate.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUPostTagSelectionViewController;

@protocol BLUPostTagSelectionViewControllerDelegate <NSObject>

- (void)postTagSelectionViewControllerDidSelectTags:(NSArray *)tags
                     postTagSelectionViewController:(BLUPostTagSelectionViewController *)postTagSelectionViewController;

@end
