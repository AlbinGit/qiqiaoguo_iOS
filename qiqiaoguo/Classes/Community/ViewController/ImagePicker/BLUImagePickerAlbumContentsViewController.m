//
//  BLUImagePickerAlbumContentsViewController.m
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUImagePickerAlbumContentsViewController.h"
#import "BLUImagePickerAlbumContentsViewModel.h"
#import "BLUImagePickerAlbumContentsCollectionViewCell.h"
#import "BLUImageViewerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BLUAssetPicker.h"

@interface BLUImagePickerAlbumContentsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) BLUImagePickerAlbumContentsViewModel *viewModel;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, assign) NSInteger selectOrder;

@end

@implementation BLUImagePickerAlbumContentsViewController

#pragma mark - Life Circle

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup assetPickers:(NSMutableArray *)assetPickers maxImageCount:(NSInteger)count{
    NSParameterAssert(assetsGroup);
    NSParameterAssert(assetPickers);
    if (self = [super init]) {
        _viewModel = [[BLUImagePickerAlbumContentsViewModel alloc] initWithAlAssetsGroup:assetsGroup assetPickers:assetPickers maxImageCount:count];
        self.title = _viewModel.assetsGroupName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Collection View
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    CGFloat width = (self.view.width - [BLUCurrentTheme leftMargin] / 2) / 4;
    _flowLayout.itemSize = CGSizeMake(width, width);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[BLUImagePickerAlbumContentsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BLUImagePickerAlbumContentsCollectionViewCell class])];
    [self.view addSubview:_collectionView];
   
    // ToolBar
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    // Preview
    _previewButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
    // TODO: Local
    _previewButton.title = NSLocalizedString(@"image-picker.preview-button.title", @"Preview");
    _previewButton.contentEdgeInsets = UIEdgeInsetsMake([BLUCurrentTheme topMargin], [BLUCurrentTheme leftMargin], [BLUCurrentTheme bottomMargin], [BLUCurrentTheme rightMargin]);
    _previewButton.rac_command = self.viewModel.previewSelction;
    @weakify(self);
    [_previewButton.rac_command.executionSignals subscribeNext:^(RACSignal *preview) {
        [preview subscribeNext:^(NSArray *imageSignals) {
            @strongify(self);
            BLUImageViewerViewController *vc = [[BLUImageViewerViewController alloc] initWithImageSignals:imageSignals];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    [_previewButton sizeToFit];
    
    UIBarButtonItem *previewBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_previewButton];
    _previewButton.tag = 0;
    
    // Prompt
    _promptLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
    RAC(self, promptLabel.text) = RACObserve(self, viewModel.prompt);
    [_promptLabel sizeToFit];
    
    UIBarButtonItem *promptBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_promptLabel];
    promptBarButtonItem.tag = 1;
    
    // Finish
    _finishButton = [UIButton makeThemeButtonWithType:BLUButtonTypeBorderedRoundRect];
    _finishButton.title = NSLocalizedString(@"image-picker.finish-button.title", @"Finish");
    _finishButton.rac_command = self.viewModel.finishSelection;
    _finishButton.contentEdgeInsets = UIEdgeInsetsMake(BLUThemeMargin, BLUThemeMargin, BLUThemeMargin, BLUThemeMargin);
    [_finishButton.rac_command.executionSignals subscribeNext:^(RACSignal *finish) {
        [finish subscribeNext:^(NSArray *images) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(albumContentsViewController:didFinishSelectingImages:)]) {
                [self.delegate albumContentsViewController:self didFinishSelectingImages:images];
            }
        
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }];
    [_finishButton sizeToFit];
    
    // Flexible button
    UIBarButtonItem *leftFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *finishBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_finishButton];
    finishBarButtonItem.tag = 2;
    
    self.toolbarItems = @[previewBarButtonItem, leftFlexibleSpace, promptBarButtonItem, rightFlexibleSpace, finishBarButtonItem];
    
    // Navigatoin bar cancel button
    if (self.navigationController) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
        [self.navigationItem setRightBarButtonItem:cancelButtonItem];
    }
    
    // Constrants
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"view": _collectionView};
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"H:|-(1)-[view]-(1)-|"
      options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
      options:0 metrics:nil views:viewsDictionary]];
}

- (void)backAction:(UIBarButtonItem *)barButtonItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectOrder = 1;
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadData {
    [self.collectionView reloadData];
    for (BLUAssetPicker *assetPicker in self.viewModel.assetPickers) {
        if (assetPicker.groupName == self.viewModel.assetsGroupName) {
            [_collectionView selectItemAtIndexPath:assetPicker.indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

#pragma mark - Collection View Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.reverseAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLUImagePickerAlbumContentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLUImagePickerAlbumContentsCollectionViewCell class]) forIndexPath:indexPath];
    cell.index = 0;
    for (BLUAssetPicker *assetPicker in self.viewModel.assetPickers) {
        if ([assetPicker.groupName isEqualToString:self.viewModel.assetsGroupName]) {
            if (assetPicker.indexPath.row == indexPath.row && assetPicker.indexPath.section == assetPicker.indexPath.section) {
                cell.index = assetPicker.order;
            }
        }
    }
    ALAsset *asset = self.viewModel.reverseAssets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    cell.imageView.image = thumbnail;
    return cell;
}

#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel deselectAtIndexPath:indexPath];
    [self reloadData];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel selectAtIndexPath:indexPath];
    [self reloadData];
}

@end
