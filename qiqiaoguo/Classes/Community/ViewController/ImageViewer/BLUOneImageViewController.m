//
//  BLUOneImageViewController.m
//  Blue
//
//  Created by Bowen on 18/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUOneImageViewController.h"

typedef NS_ENUM(NSInteger, ViewerState) {
    ViewerStateOperate = 0,
    ViewerStateClean,
};

@interface BLUOneImageViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIColor *tintBackgroundColor;
@property (nonatomic, strong) UIColor *deepBackgroundColor;
@property (nonatomic, assign) CGFloat animeDuration;
@property (nonatomic, assign) ViewerState viewerState;
@property (nonatomic, assign) CGPoint lastTransition;
@end

@implementation BLUOneImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
        _imageSize = image.size;
        _tintBackgroundColor = [UIColor whiteColor];
        _deepBackgroundColor = [UIColor blackColor];
        _animeDuration = 0.2;
        _lastTransition = CGPointZero;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewerState = ViewerStateOperate;

    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBackground:)];
    tapBackground.numberOfTapsRequired = 1;
    tapBackground.delegate = self;

    UITapGestureRecognizer *doubleTapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapBackground:)];
    doubleTapBackground.delegate = self;
    doubleTapBackground.numberOfTapsRequired = 2;
    [tapBackground requireGestureRecognizerToFail:doubleTapBackground];

    [self.view addGestureRecognizer:tapBackground];
    [self.view addGestureRecognizer:doubleTapBackground];

    _imageView = [UIImageView new];
    _imageView.image = self.image;
    _imageView.userInteractionEnabled = YES;

    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateScrollView:)];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchImage:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanImage:)];

    rotateGesture.delegate = self;
    pinchGesture.delegate = self;
    panGesture.delegate = self;

    [self.view addSubview:_imageView];

    [_imageView addGestureRecognizer:rotateGesture];
    [_imageView addGestureRecognizer:pinchGesture];
    [_imageView addGestureRecognizer:panGesture];

    [_imageView sizeToFit];
    CGFloat resizeRatio;

    if (_imageView.width >= _imageView.height) {
        resizeRatio = self.view.width / _imageView.width;
    } else {
        resizeRatio = self.view.height / _imageView.height;
    }

    _imageView.width *= resizeRatio;
    _imageView.height *= resizeRatio;
    _imageView.centerX = self.view.width / 2.0;
    _imageView.centerY = self.view.height / 2.0;
}

- (void)handleTapBackground:(UITapGestureRecognizer *)recognizer {
    BLULogDebug(@"tap background = %@", recognizer);

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self changeViewerState];
    }
}

- (void)handleDoubleTapBackground:(UITapGestureRecognizer *)recognizer {
    BLULogDebug(@"double tap background = %@", recognizer);

    CGPoint location = [recognizer locationInView:self.imageView];

    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        if ([self.imageView hitTest:location withEvent:nil]) {
            self.viewerState = ViewerStateClean;
        }
    }
}

- (void)changeViewerState {
    self.viewerState = _viewerState == ViewerStateOperate ? ViewerStateClean : ViewerStateOperate;
}

- (void)setViewerState:(ViewerState)viewerState {
    _viewerState = viewerState;
    [UIView animateWithDuration:_animeDuration animations:^{
        if (viewerState == ViewerStateClean) {
            self.view.backgroundColor = _deepBackgroundColor;
        } else {
            self.view.backgroundColor = _tintBackgroundColor;
        }
    }];
}

- (void)handlePinchImage:(UIPinchGestureRecognizer *)recognizer {
    BLULogDebug(@"pinch = %@", recognizer);

    [self adjustAnchorPointForGestureRecognizer:recognizer];

    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        [recognizer view].transform = CGAffineTransformScale([[recognizer view] transform], [recognizer scale], [recognizer scale]);
        [recognizer setScale:1];
    }

    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        [self relocateImageView];
    }
}

- (void)handlePanImage:(UIPanGestureRecognizer *)recognizer {
    BLULogDebug(@"pan = %@", recognizer);

    static CGPoint initialCenter;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        initialCenter = recognizer.view.center;
    }

    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    recognizer.view.center = CGPointMake(initialCenter.x + translation.x, initialCenter.y + translation.y);

    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        [self relocateImageView];
    }
}

- (void)relocateImageView {
    [UIView animateWithDuration:0.3 animations:^{
//        self.imageView.transform = CGAffineTransformMakeRotation(0);
//        if (_imageView.width >= _imageView.height) {
//
//            CGFloat anchorX = self.imageView.layer.anchorPoint.x;
//            CGFloat anchorY = self.imageView.layer.anchorPoint.y;
//            CGFloat anchorHorizenOffset = (anchorX - 0.5) * self.imageView.bounds.size.width;
//            CGFloat anchorVerticalOffset = (anchorY - 0.5) * self.imageView.bounds.size.height;
////            self.imageView.center = CGPointMake(self.view.width / 2 + anchorHorizenOffset, self.view.height / 2 + anchorVerticalOffset);
//
//            CGFloat imageCenterX = self.imageView.layer.position.x * (0.5 / anchorX);
//            CGFloat imageCenterY = self.imageView.layer.position.y * (0.5 / anchorY);
//
//
//
//            BLULogDebug(@"anchorHorizenOffset = %@, anchorVerticalOffset = %@", @(anchorHorizenOffset), @(anchorVerticalOffset));
//            BLULogDebug(@"imageSize = %@", NSStringFromCGSize(self.imageView.bounds.size));
//            BLULogDebug(@"imageCenterX = %@, imageCenterY = %@", @(imageCenterX), @(imageCenterY));
//            BLULogDebug(@"anchorX = %@, anchorY = %@", @(anchorX), @(anchorY));
//            BLULogDebug(@"current center = %@", NSStringFromCGPoint(self.imageView.center));
//            BLULogDebug(@"current layer contentsCenter center = %@", NSStringFromCGRect(self.imageView.layer.contentsCenter));
//            BLULogDebug(@"current layer position = %@", NSStringFromCGPoint(self.imageView.layer.position));
//            BLULogDebug(@"current layer bounds = %@", NSStringFromCGRect(self.imageView.layer.bounds));
//            BLULogDebug(@"current layer frame = %@", NSStringFromCGRect(self.imageView.layer.frame));
//            BLULogDebug(@"current layer content scale = %@", @(self.imageView.layer.contentsScale));
//        } else {
//            
//        }

        CGRect currentRect = self.imageView.layer.frame;

    }];
}

- (void)handleRotateScrollView:(UIRotationGestureRecognizer *)recognizer {
    BLULogDebug(@"rotate = %@", recognizer);
    [self adjustAnchorPointForGestureRecognizer:recognizer];

    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        [recognizer view].transform = CGAffineTransformRotate([[recognizer view] transform], [recognizer rotation]);
        [recognizer setRotation:0];
    }

    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        [self relocateImageView];
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];

        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

#pragma mark - UIGestrueRecognizer.

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;

    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;


    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }

    return YES;
}

@end
