//
//  BLUImageViewerViewController.h
//  Blue
//
//  Created by Bowen on 10/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController.h"

@class BLUImageViewerViewController;

@protocol BLUImageViewerViewControllerDelegate <NSObject>

- (void)imageViewerViewController:(BLUImageViewerViewController *)viewController didEditImages:(NSArray *)images;

@end

@interface BLUImageViewerViewController : BLUViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageSignals;

@property (nonatomic, assign, getter=isEditAble) BOOL editAble;
@property (nonatomic, assign, getter=isPresented) BOOL presented;
@property (nonatomic, weak) id <BLUImageViewerViewControllerDelegate> delegate;

- (instancetype)initWithImages:(NSArray *)images;
- (instancetype)initWithImageSignals:(NSArray *)imageSignals;
- (instancetype)initWithImageURLs:(NSArray *)imageURLs;

@end
