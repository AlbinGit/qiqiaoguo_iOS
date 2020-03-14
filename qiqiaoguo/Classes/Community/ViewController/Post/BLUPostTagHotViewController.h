//
//  BLUPostTagHotViewController.h
//  Blue
//
//  Created by Bowen on 3/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPostTagContainer.h"

@class BLUPostTagHotViewController, BLUPostTagHotViewModel;

@protocol BLUPostTagHotViewControllerDelegate <NSObject>

- (void)tagHotViewControllerDidSelectTag:(BLUPostTag *)tag
                    tagHotViewController:
(BLUPostTagHotViewController *)tagHotViewController;

- (void)tagHotViewControllerDidDeselectTag:(BLUPostTag *)tag
                    tagHotViewController:
(BLUPostTagHotViewController *)tagHotViewController;

- (void)tagHotViewControllerFetchFailed:(NSError *)error
                   tagHotViewController:
(BLUPostTagHotViewController *)tagHotViewController;

- (void)tagHotViewControllerDidFetchSuccess:(BLUPostTagHotViewController *)tagHotViewController;

- (void)tagHotViewControllerDidSelectNoneTag:(BLUPostTagContainer *)container;

@end

@interface BLUPostTagHotViewController : BLUViewController

@property (nonatomic, strong) UIToolbar *hotToolbar;
@property (nonatomic, strong) UILabel *hotLabel;

@property (nonatomic, strong) BLUPostTagHotViewModel *tagHotViewModel;

@property (nonatomic, strong) BLUPostTagContainer *tagContainer;
@property (nonatomic, weak) id <BLUPostTagHotViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger lastSelectedIndex;

- (void)updateSelctionWithTags:(NSArray *)tags;

@end

@interface BLUPostTagHotViewController (PostTagContainerDelegate) <BLUPostTagContainerDelegate>

@end
