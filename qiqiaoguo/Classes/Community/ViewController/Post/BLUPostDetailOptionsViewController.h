//
//  BLUPostDetailOptionsViewController.h
//  Blue
//
//  Created by Bowen on 30/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPostDetailOptionsViewControllerDelegate.h"

@class BLUPost;
@class BLUBottomTransitioningController;

@interface BLUPostDetailOptionsViewController : BLUViewController

@property (nonatomic, strong) UIToolbar *optionContainer;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *reverseButton;

@property (nonatomic, strong) UILabel *collectLabel;
@property (nonatomic, strong) UILabel *reportLabel;
@property (nonatomic, strong) UILabel *reverseLabel;

@property (nonatomic, strong) BLUBottomTransitioningController *transitioningController;

@property (nonatomic, weak) id <BLUPostDetailOptionsViewControllerDelegate> delegate;

@property (nonatomic, strong) BLUPost *post;
@property (nonatomic, assign) BOOL commentReverse;

@property (nonatomic, assign, readonly) CGFloat contentVerticalMargin;
@property (nonatomic, assign, readonly) CGFloat cancelButtonHeight;

- (instancetype)initWithPost:(BLUPost *)post;

@end
