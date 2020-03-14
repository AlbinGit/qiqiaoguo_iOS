//
//  BLUPostTagHotViewController.m
//  Blue
//
//  Created by Bowen on 3/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagHotViewController.h"
#import "BLUPostTagContainer.h"
#import "BLUPostTagHotViewModel.h"
#import "BLUPostTag.h"
#import "BLUPostTagTextAttachment.h"

@implementation BLUPostTagHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _hotToolbar = [UIToolbar new];
    _hotToolbar.backgroundColor = [UIColor darkGrayColor];
    _hotToolbar.clipsToBounds = YES;

    _hotLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    _hotLabel.textColor = [UIColor colorWithRed:0.62 green:0.63 blue:0.63 alpha:1];
    _hotLabel.text = NSLocalizedString(@"post-tag-hot-vc.hot-label.title", @"Hot topics");

    _tagContainer = [BLUPostTagContainer new];
    _tagContainer.selectAble = YES;
    _tagContainer.deleteAble = NO;
    _tagContainer.selectable = NO;
    _tagContainer.maxTagsCount = 1000;
    _tagContainer.maxSelectionCount = 5;
    _tagContainer.editable = NO;
    _tagContainer.postTagContainerDelegate = self;
    UIEdgeInsets textContainerInset = _tagContainer.textContainerInset;
    textContainerInset.left = BLUThemeMargin * 2;
    textContainerInset.right = BLUThemeMargin * 2;
    _tagContainer.textContainerInset = textContainerInset;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_hotToolbar];
    [_hotToolbar addSubview:_hotLabel];
    [self.view addSubview:_tagContainer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _hotToolbar.frame = CGRectMake(0, 0, self.view.width, 22);
    [_hotLabel sizeToFit];
    _hotLabel.x = _tagContainer.textContainerInset.left + BLUThemeMargin * 2 - 1;
    _hotLabel.centerY = _hotToolbar.height / 2.0;

    _tagContainer.frame = CGRectMake(0, _hotToolbar.bottom, self.view.width,
                                     self.view.height - _hotToolbar.bottom);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tagHotViewModel.tags.count <= 0) {
        @weakify(self);
        [[self.tagHotViewModel fetch] subscribeError:^(NSError *error) {
            @strongify(self);
            if ([self.delegate respondsToSelector:
                 @selector(tagHotViewControllerFetchFailed:tagHotViewController:)]) {
                [self.delegate tagHotViewControllerFetchFailed:error
                                          tagHotViewController:self];
            }
        } completed:^{
            @strongify(self);
            self.tagContainer.attributedText = nil;
            [self.tagContainer addTags:self.tagHotViewModel.tags];
            [self.delegate tagHotViewControllerDidFetchSuccess:self];
        }];
    }
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

- (BLUPostTagHotViewModel *)tagHotViewModel {
    if (_tagHotViewModel == nil) {
        _tagHotViewModel = [BLUPostTagHotViewModel new];
    }
    return _tagHotViewModel;
}

- (void)updateSelctionWithTags:(NSArray *)tags {
    NSArray *localTags = [_tagContainer allTags];
    [localTags enumerateObjectsUsingBlock:^(BLUPostTag *iTag, NSUInteger idx, BOOL * _Nonnull stop) {
        NSParameterAssert([iTag isKindOfClass:[BLUPostTag class]]);

        iTag.selected = NO;

        [tags enumerateObjectsUsingBlock:^(BLUPostTag *jTag, NSUInteger idx, BOOL * _Nonnull stop) {
            NSParameterAssert([jTag isKindOfClass:[BLUPostTag class]]);
            if ([jTag.title isEqualToString:iTag.title]) {
                iTag.selected = YES;
                *stop = YES;
            } else {
                iTag.selected = NO;
            }
        }];

        NSInteger index = [_tagContainer indexOfTag:iTag];
        [_tagContainer updateTagSelectionState:iTag.selected atIndex:index];
    }];
}

@end

@implementation BLUPostTagHotViewController (PostTagContainerDelegate)

- (void)containerDidSelectedTag:(BLUPostTag *)tag
                        atIndex:(NSInteger)index
                      container:(BLUPostTagContainer *)container {

    if ([self.delegate respondsToSelector:
         @selector(tagHotViewControllerDidSelectTag:tagHotViewController:)]) {
        [self.delegate
         tagHotViewControllerDidSelectTag:tag
         tagHotViewController:self];
    }
}

- (void)containerSelectNoneTag:(BLUPostTagContainer *)container {
    if ([self.delegate respondsToSelector:
         @selector(tagHotViewControllerDidSelectNoneTag:)]) {
        [self.delegate tagHotViewControllerDidSelectNoneTag:self];
    }
}

- (void)containerDidDeselectedTag:(BLUPostTag *)tag
                          atIndex:(NSInteger)index
                        container:(BLUPostTagContainer *)container {
    if ([self.delegate respondsToSelector:
         @selector(tagHotViewControllerDidDeselectTag:tagHotViewController:)]) {
        [self.delegate tagHotViewControllerDidDeselectTag:tag
                                     tagHotViewController:self];
    }
}

@end
