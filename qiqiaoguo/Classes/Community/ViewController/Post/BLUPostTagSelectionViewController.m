//
//  BLUPostTagSelectionViewController.m
//  Blue
//
//  Created by Bowen on 3/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagSelectionViewController.h"
#import "BLUPostTagContainer.h"
#import "BLUPostTagHotViewController.h"
#import "BLUPostTagSearchResultViewController.h"

static const CGFloat kTagContainerMinSize = 36.0;

@interface BLUPostTagSelectionViewController ()

@property (nonatomic, strong) NSArray *tags;

@end

@implementation BLUPostTagSelectionViewController

- (instancetype)initWithTags:(NSArray *)tags {
    if (self = [super init]) {
        _tags = tags;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"post-tag-selection.title", @"Add topic");

    _tagContainer = [BLUPostTagContainer new];
    _tagContainer.selectAble = NO;
    _tagContainer.deleteAble = YES;
    _tagContainer.postTagContainerDelegate = self;
    _tagContainer.returnKeyType = UIReturnKeyDone;
    UIEdgeInsets textContainerInset = _tagContainer.textContainerInset;
    textContainerInset.left = BLUThemeMargin * 2;
    textContainerInset.right = BLUThemeMargin * 2;
    textContainerInset.top = BLUThemeMargin * 4;
    textContainerInset.bottom = BLUThemeMargin * 4;
    _tagContainer.textContainerInset = textContainerInset;
    _tagContainer.placeholder = NSLocalizedString(@"post-tag-selection-vc.tag-container.placeholder", @"Add topic");

    _hotViewController = [BLUPostTagHotViewController new];
    _hotViewController.delegate = self;

    _searchResultViewController = [BLUPostTagSearchResultViewController new];
    _searchResultViewController.view.alpha = 0.0;
    _searchResultViewController.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tagContainer];

    [self addChildViewController:_hotViewController];
    [self.view addSubview:_hotViewController.view];
    [_hotViewController didMoveToParentViewController:self];

    [self.view addSubview:_searchResultViewController.view];

    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(tapDoneAndFinishTask:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];

    if (_tags.count > 0) {
        [_tagContainer addTags:_tags];
        [self reloadDataWithTags:_tags container:_tagContainer];
    }
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutTagContainer:NO];
}

- (void)layoutTagContainer:(BOOL)animated{
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat tagContainerHeight =
        _tagContainer.contentSize.height < kTagContainerMinSize ?
        kTagContainerMinSize : _tagContainer.contentSize.height;
        _tagContainer.frame =
        CGRectMake(0, self.topLayoutGuide.length, self.view.width, tagContainerHeight);

        CGRect childViewControllerFrame =
        CGRectMake(0, _tagContainer.bottom,
                   self.view.width, self.view.height - _tagContainer.bottom);

        _hotViewController.view.frame = childViewControllerFrame;
        _searchResultViewController.view.frame = childViewControllerFrame;
    }];
}

#pragma mark - Action

- (void)tapDoneAndFinishTask:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self sendTagsToDelegate:[_tagContainer allTags]];
}

- (void)sendTagsToDelegate:(NSArray *)tags {
    if ([self.delegate
         respondsToSelector:
         @selector(postTagSelectionViewControllerDidSelectTags:postTagSelectionViewController:)]) {
        [self.delegate
         postTagSelectionViewControllerDidSelectTags:tags
         postTagSelectionViewController:self];
    }
}

@end

@implementation BLUPostTagSelectionViewController (PostTagContainerDelegate)

- (void)containerDidRemoveTag:(BLUPostTag *)tag
                      atIndex:(NSInteger)index
                    container:(BLUPostTagContainer *)container {
    NSArray *tags = [_tagContainer allTags];
    [self reloadDataWithTags:tags container:container];
}

- (void)containerDidAddTag:(BLUPostTag *)tag container:(BLUPostTagContainer *)container {
    NSArray *tags = [_tagContainer allTags];
    [self reloadDataWithTags:tags container:container];
}

- (void)containerDidReceiveDulicateTag:(BLUPostTag *)tag
                             container:(BLUPostTagContainer *)container {
    [self showTopIndicatorWithErrorMessage:
     NSLocalizedString(@"post-tag-selection-vc.tag-container.did-receive-dulicate-tag",
                       @"Can not add dulicate tag!")];
    [_hotViewController updateSelctionWithTags:[_tagContainer allTags]];
    [self cycleChildeVCIfNeed:container];
}

- (void)containerCannotAddTagAnymore:(BLUPostTag *)tag
                           container:(BLUPostTagContainer *)container {
    [self showTopIndicatorWithErrorMessage:
     NSLocalizedString(@"post-tag-selection-vc.tag-container.cannot-add-tag-anymore",
                       @"Can not add tag anymore.")];
    [_hotViewController updateSelctionWithTags:[container allTags]];
    [self cycleChildeVCIfNeed:container];
}

- (void)containerDidChanged:(BLUPostTagContainer *)container {
    [_hotViewController updateSelctionWithTags:[_tagContainer allTags]];
    [self cycleChildeVCIfNeed:container];
}

- (void)cycleChildeVCIfNeed:(BLUPostTagContainer *)container {
    NSString *keyword = container.attributedText.allStrings.lastObject;
    printf("\nkeyword  = %s\n", keyword.UTF8String);
    if (keyword.length > 0) {
        [_searchResultViewController searchKeyword:keyword];
        if (![self.childViewControllers containsObject:_searchResultViewController]) {
            [self cycleFromViewController:_hotViewController
                         toViewController:_searchResultViewController];
        }
    } else {
        if (![self.childViewControllers containsObject:_hotViewController]) {
            [self cycleFromViewController:_searchResultViewController
                         toViewController:_hotViewController];
        }
    }
}

- (void)cycleFromViewController:(UIViewController *)fromVC
               toViewController:(UIViewController *)toVC {
    [fromVC willMoveToParentViewController:nil];
    [self addChildViewController:toVC];

    fromVC.view.alpha = 1.0;
    toVC.view.alpha = 0.0;

    [self transitionFromViewController:fromVC
                      toViewController:toVC
                              duration:0.2
                               options:0
                            animations:^{
                                fromVC.view.alpha = 0.0;
                                toVC.view.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                [fromVC removeFromParentViewController];
                                [toVC didMoveToParentViewController:self];
                            }];

}

- (void)containerNeedResize:(BLUPostTagContainer *)container {
    [self layoutTagContainer:YES];
}

- (void)reloadDataWithTags:(NSArray *)tags container:(BLUPostTagContainer *)container {
    [_hotViewController updateSelctionWithTags:tags];
    [self cycleChildeVCIfNeed:container];
}

@end

@implementation BLUPostTagSelectionViewController (TagHotViewController)

- (void)tagHotViewControllerFetchFailed:(NSError *)error
                   tagHotViewController:(BLUPostTagHotViewController *)tagHotViewController {
    [self showTopIndicatorWithError:error];
}

- (void)tagHotViewControllerDidFetchSuccess:(BLUPostTagHotViewController *)tagHotViewController {
    [tagHotViewController updateSelctionWithTags:self.tagContainer.allTags];
}

- (void)tagHotViewControllerDidSelectTag:(BLUPostTag *)tag
                    tagHotViewController:(BLUPostTagHotViewController *)tagHotViewController {
    [_tagContainer addTag:tag];
    [_hotViewController updateSelctionWithTags:[_tagContainer allTags]];
    [_tagContainer resignFirstResponder];
}

- (void)tagHotViewControllerDidDeselectTag:(BLUPostTag *)tag
                      tagHotViewController:(BLUPostTagHotViewController *)tagHotViewController {
    [_tagContainer removeTag:tag];
    [_tagContainer resignFirstResponder];
}

- (void)tagHotViewControllerDidSelectNoneTag:(BLUPostTagContainer *)container {
    [_tagContainer resignFirstResponder];
}

@end

@implementation BLUPostTagSelectionViewController (TagSearchResultsViewController)

- (void)searchResultsViewControllerDidSelectTag:(BLUPostTag *)tag
                    searchResultsViewControlelr:(BLUPostTagSearchResultViewController *)tagSearchResultViewController {
    [_tagContainer addTag:tag];
}

- (void)searchResultsViewController:(BLUPostTagSearchResultViewController *)searchResultController
                    didSearchFailed:(NSError *)error {
    [self showTopIndicatorWithError:error];
}

@end
