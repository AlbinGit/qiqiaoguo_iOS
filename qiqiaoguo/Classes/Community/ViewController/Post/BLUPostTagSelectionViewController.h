//
//  BLUPostTagSelectionViewController.h
//  Blue
//
//  Created by Bowen on 3/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPostTagContainer.h"
#import "BLUPostTagHotViewController.h"
#import "BLUPostTagSearchResultViewController.h"
#import "BLUPostTagSelectionViewControllerDelegate.h"

@class BLUPostTagHotViewController, BLUPostTagSearchResultViewController;

@interface BLUPostTagSelectionViewController : BLUViewController

@property (nonatomic, strong) BLUPostTagContainer *tagContainer;
@property (nonatomic, strong) BLUPostTagHotViewController *hotViewController;
@property (nonatomic, strong) BLUPostTagSearchResultViewController *searchResultViewController;
@property (nonatomic, strong) id <BLUPostTagSelectionViewControllerDelegate> delegate;

- (instancetype)initWithTags:(NSArray *)tags;

- (void)layoutTagContainer:(BOOL)animated;

@end

@interface BLUPostTagSelectionViewController (PostTagContainerDelegate)
<BLUPostTagContainerDelegate>

- (void)reloadDataWithTags:(NSArray *)tags container:(BLUPostTagContainer *)container;

@end

@interface BLUPostTagSelectionViewController (TagHotViewController)
<BLUPostTagHotViewControllerDelegate>

@end

@interface BLUPostTagSelectionViewController (TagSearchResultsViewController)
<BLUPostTagSearchResultViewControllerDelegate>

@end
