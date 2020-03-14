//
//  BLUImagePickerViewController.m
//  Blue
//
//  Created by Bowen on 9/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUImagePickerViewController.h"
#import "BLUImagePickerViewModel.h"
#import "BLUImagePickerAlbumContentsViewController.h"

@interface BLUImagePickerViewController () <BLUImagePickerViewModelDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLUImagePickerViewModel *viewModel;
@property (nonatomic, strong) BLUTableView *tableView;

@end

@implementation BLUImagePickerViewController

#pragma mark - Life Circle

- (instancetype)init {
    if (self = [super init]) {
        [self configWithMaxImageCount:9];
    }
    return self;
}

- (instancetype)initWithMaxImageCount:(NSInteger)count {
    if (self = [super init]) {
        [self configWithMaxImageCount:count];
    }
    return self;
}

- (void)configWithMaxImageCount:(NSInteger)maxImageCount {
    self.title = NSLocalizedString(@"image-picker.title", @"Photo albums");
    _maxImageCount = maxImageCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // View model
    [self viewModel];
    
    // TableView
    _tableView = [BLUTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:_tableView];
    
    // Constrants
    [self addTiledLayoutConstrantForView:_tableView];
    
    // Navigatoin bar cancel button
    if (self.navigationController) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
        [self.navigationItem setRightBarButtonItem:cancelButtonItem];
    }
}

- (void)backAction:(UIBarButtonItem *)barButtonItem {
    [self dismissViewControllerAnimated:YES completion:^{
        BLULogDebug(@"Image picker view controlelr dismissed");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Model

- (BLUImagePickerViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [BLUImagePickerViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

#pragma mark - View Model Delegate

- (void)imagePickerViewModelAccessAssetsSuccess:(BLUImagePickerViewModel *)imagePickerViewModel {
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)imagePickerViewModel:(BLUImagePickerViewModel *)imagePickerViewModel AccessAssetsFailureWithErrorMessage:(NSString *)errorMessage {
    BLULogError(@"ErroMessage = %@", errorMessage);
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    ALAssetsGroup *groupForCell = self.viewModel.groups[indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.imageView.image = posterImage;
    cell.imageView.cornerRadius = BLUThemeLowActivityCornerRadius;
    cell.textLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [@(groupForCell.numberOfAssets) stringValue];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *group = self.viewModel.groups[indexPath.row];
    BLUImagePickerAlbumContentsViewController *vc = [[BLUImagePickerAlbumContentsViewController alloc] initWithAssetsGroup:group assetPickers:self.viewModel.assetPickers maxImageCount:self.maxImageCount];
    vc.delegate = self.albumContentsViewControllerDelegate;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
