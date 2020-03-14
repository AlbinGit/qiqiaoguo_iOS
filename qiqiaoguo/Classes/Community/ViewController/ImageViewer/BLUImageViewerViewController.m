//
//  BLUImageViewerViewController.m
//  Blue
//
//  Created by Bowen on 10/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUImageViewerViewController.h"

typedef NS_ENUM(NSInteger, SourceType) {
    SourceTypeImage = 0,
    SourceTypeSignal,
    SourceTypeURL,
};

@interface BLUImageViewerViewController ()

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) SourceType sourceType;

@end

@implementation BLUImageViewerViewController

- (instancetype)initWithImages:(NSArray *)imageArray {
    if (self = [super init]) {
        _images = [NSMutableArray arrayWithArray:imageArray];
        _sourceType = SourceTypeImage;
    }
    return self;
}

- (instancetype)initWithImageSignals:(NSArray *)imageSignalArray {
    if (self = [super init]) {
        _imageSignals = [NSMutableArray arrayWithArray:imageSignalArray];
        _sourceType = SourceTypeSignal;
    }
    return self;
}

- (instancetype)initWithImageURLs:(NSArray *)imageURLs {
    if (self = [super init]) {
        _sourceType = SourceTypeURL;
        // TODO: change url to signal
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Super view
    UIView *superview = self.view;
    superview.backgroundColor = [UIColor blackColor];
    
    // Scroll view
    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [superview addSubview:_scrollView];
    
    // Button
    [self _addImageButtons];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    RACSignal *unbindSignal = [self rac_signalForSelector:@selector(viewWillDisappear:)];
    
    @weakify(self);
    RAC(self, title) = [[RACObserve(self, currentPage) map:^id(NSNumber *pageNumber) {
        @strongify(self);
        NSInteger page = pageNumber.integerValue;
        page += 1;
        NSString *title = nil;
        NSInteger count = self.images ? self.images.count : self.imageSignals.count;
        title = [NSString stringWithFormat:@"%@ / %@", @(page), @(count)];
        return title;
    }] takeUntil:unbindSignal];
    
    RAC(self, currentPage) = [[[RACObserve(self, scrollView.contentOffset) distinctUntilChanged] map:^id(NSValue *pointValue) {
        @strongify(self);
        CGPoint point = [pointValue CGPointValue];
        NSInteger page = point.x / self.scrollView.width;
        return @(page);
    }] takeUntil:unbindSignal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
    _scrollView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.width, self.view.height - self.topLayoutGuide.length);
    
    [self _updateContentLayout];
}

- (void)_hideAction:(UIButton *)button {
    static BOOL hide = NO;
    hide = !hide;
    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:hide animated:YES];
}

- (void)_deleteAction:(UIBarButtonItem *)barButton {
    if (self.sourceType == SourceTypeImage) {
        [self.images removeObjectAtIndex:self.currentPage];
        @weakify(self);
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            if (idx == self.currentPage) {
                [button removeFromSuperview];
            }
        }];
        if (self.images.count <= 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        if ([self.delegate respondsToSelector:@selector(imageViewerViewController:didEditImages:)]) {
            [self.delegate imageViewerViewController:self didEditImages:self.images];
        }
   
        self.title = [NSString stringWithFormat:@"%@ / %@", @(self.currentPage + 1), @(self.images.count)];
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)backAction:(UIBarButtonItem *)barButton {
    BLULogDebug(@"self.presentingViewController = %@", self.presentingViewController);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_addImageButtons {

    if (_scrollView.subviews.count > 0) {
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    void (^makeButton)(UIImage *) = ^(UIImage *image) {
        UIButton *button = [UIButton new];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.image = image;
        
        [button addTarget:self action:@selector(_hideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:button];
    };
    
    switch (self.sourceType) {
        case SourceTypeImage: {
            [_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
                makeButton(image);
            }];
        } break;
        case SourceTypeURL: {
            // TODO:
        } break;
        case SourceTypeSignal: {
            [_imageSignals enumerateObjectsUsingBlock:^(RACSignal *imageSignal, NSUInteger idx, BOOL *stop) {
                makeButton(nil);
            }];
            
            RACSignal *imagesSignal = [RACSignal empty];
            
            for (RACSignal *imageSignal in _imageSignals) {
                imagesSignal = [imagesSignal concat:imageSignal];
            }
            
            __block NSInteger i = 0;
            
            @weakify(self);
            [[imagesSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *image) {
                @strongify(self);
                UIButton *button = self.scrollView.subviews[i];
                button.image = image;
                i++;
            }];
        } break;
    }
}

- (void)_updateContentLayout {

    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        CGRect buttonRect = CGRectZero;
        buttonRect.size = _scrollView.size;

        if (_scrollView.subviews.count > 0) {
            buttonRect.origin.x = _scrollView.width * idx;
            buttonRect.origin.y = 0;
        } else {
            buttonRect.origin = CGPointMake(0, 0);
        }
        
        button.frame = buttonRect;
        
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * _scrollView.subviews.count, _scrollView.height);
}

- (void)setEditAble:(BOOL)editAble {
    _editAble = editAble;
    if (editAble) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BLUCurrentTheme postDeleteIcon] style:UIBarButtonItemStylePlain target:self action:@selector(_deleteAction:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setPresented:(BOOL)presented {
    _presented = presented;
    if (presented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
    }
}

@end
