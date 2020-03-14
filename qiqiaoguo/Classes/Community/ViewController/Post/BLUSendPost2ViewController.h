//
//  BLUSendPost2ViewController.h
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUSendPost2ViewControllerDelegate.h"

UIKIT_EXTERN const NSInteger BLUSendPost2MaxImageCount;

@class BLUSendPost2Toolbar;
@class BLUSendPost2CircleSelector;
@class BLUSendPost2ViewModel;
@class BLUPostTagContainer;
@class BLUTextView;
@class BLUCircle;

@interface BLUSendPost2ViewController : BLUViewController

@property (nonatomic, strong) BLUSendPost2CircleSelector *circleSelector;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIView *divider;
@property (nonatomic, strong) BLUTextView *contentTextView;
@property (nonatomic, strong) BLUSendPost2Toolbar *toolbar;
@property (nonatomic, strong) BLUSendPost2ViewModel *viewModel;
@property (nonatomic, strong) BLUPostTagContainer *tagContainer;
@property (nonatomic, strong) BLUCircle *circle;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) NSInteger reminingImagesCount;
@property (nonatomic, weak) id <BLUSendPost2ViewControllerDelegate> delegate;

- (UIScrollView *)scrollView;

- (void)layoutTagContainer;
- (void)layoutContentTextView;

@end
