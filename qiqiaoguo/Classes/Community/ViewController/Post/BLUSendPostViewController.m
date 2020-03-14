//
//  BLUPostViewController.m
//  Blue
//
//  Created by Bowen on 11/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSendPostViewController.h"
#import "BLUImagePickerViewController.h"
#import "BLUImagePickerAlbumContentsViewController.h"
#import "BLUSendPostViewModel.h"
#import "BLUImageViewerViewController.h"
#import "BLUUserProfit.h"

#define kTextViewPlaceholder NSLocalizedString(@"send-post.content-text-view.placeholder", @"Content")

static const CGFloat kTextViewHeight = 120;
static const NSInteger kMaxImagesCount = 9;
static const NSInteger kGridViewColumn = 4;

@interface BLUSendPostViewController () <UITextViewDelegate, UITextFieldDelegate, BLUImagePickerAlbumContentsViewControllerDelegate, BLUImageViewerViewControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) BLUTextFieldContainer *titleTextFieldContainer;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) BLUGridView *imageGridView;
@property (nonatomic, strong) BLUSolidLine *solidLine;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) BLUSendPostViewModel *sendPostViewModel;
@property (nonatomic, strong) UIToolbar *anonymousToolbar;

@end

@implementation BLUSendPostViewController

#pragma mark - Life circle

- (instancetype)initWithCircle:(NSInteger)circleID {
    if (self = [super init]) {
        _circleID = circleID;
        // Keyboard notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIView *superview = self.view;
    superview.backgroundColor = BLUThemeMainTintBackgroundColor;
    
    // TODO: Local
    // Right bar item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"send-post.right-bar-button.title", @"Send") style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Title text field
    _titleTextFieldContainer = [[BLUTextFieldContainer alloc] initWithTitle:nil accessoryType:BLUTextFieldContainerAccessoryTypeNone];
    _titleTextFieldContainer.textField.placeholder = NSLocalizedString(@"send-post.title-text-field.placeholder", @"Title");
    _titleTextFieldContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _titleTextFieldContainer.textField.returnKeyType = UIReturnKeyDone;
    _titleTextFieldContainer.textField.delegate = self;
    _titleTextFieldContainer.textField.secureTextEntry = NO;
    _titleTextFieldContainer.backgroundColor = BLUThemeMainTintBackgroundColor;
    if ([_titleTextFieldContainer.textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _titleTextFieldContainer.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"send-post.title-text-field.placeholder", @"Title") attributes:@{NSForegroundColorAttributeName: BLUThemeSubTintContentForegroundColor}];
    } else {
        BLULogDebug(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }

    [superview addSubview:_titleTextFieldContainer];
    
    // Content text view
    _contentTextView = [UITextView new];
    _contentTextView.text = kTextViewPlaceholder;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    _contentTextView.delegate = self;
    _contentTextView.font = _titleTextFieldContainer.textField.font;
    _contentTextView.returnKeyType = UIReturnKeyDefault;
    _contentTextView.textColor = BLUThemeSubTintContentForegroundColor;
    _contentTextView.textContainerInset = UIEdgeInsetsMake([BLUCurrentTheme topMargin] * 2 + 3, [BLUCurrentTheme leftMargin] * 2 + 3, 0, [BLUCurrentTheme rightMargin] * 2 + 3);
    [superview addSubview:_contentTextView];
    
    // Solid line
    _solidLine = [BLUSolidLine new];
    _solidLine.backgroundColor = BLUThemeSubTintBackgroundColor;
    [superview addSubview:_solidLine];
    
    // Grid view
    _imageGridView = [[BLUGridView alloc] initWithColumn:kGridViewColumn margin:[BLUCurrentTheme leftMargin]];;
    [superview addSubview:_imageGridView];
    [self _updateGridViewContent];

    // Tool bar
    UIButton *anonymousButton = [UIButton new];
    anonymousButton.selected = NO;
    [anonymousButton setImage:[BLUCurrentTheme postSelectedImageIcon] forState:UIControlStateSelected];
    [anonymousButton setImage:[BLUCurrentTheme postDeselectedCircle] forState:UIControlStateNormal];
    [anonymousButton setTitleColor:BLUThemeSubDeepContentForegroundColor forState:UIControlStateNormal];
    anonymousButton.imageView.tintColor = BLUThemeMainColor;
    [anonymousButton addTarget:self action:@selector(anonymousAction:) forControlEvents:UIControlEventTouchUpInside];
    anonymousButton.tintColor = BLUThemeMainColor;
    anonymousButton.imageView.tintColor = BLUThemeMainColor;
    anonymousButton.title = NSLocalizedString(@"send-post.toolbar.button.title", @"Anonymous");

    _anonymousToolbar = [UIToolbar new];
    [_anonymousToolbar addSubview:anonymousButton];
    [anonymousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.anonymousToolbar);
        make.right.equalTo(self.anonymousToolbar).offset(-BLUThemeMargin * 2);
    }];
    [superview addSubview:_anonymousToolbar];

    // Bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"send-post.right-bar-button.title", @"Send") style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
    
    // Constrants
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_titleTextFieldContainer, topLayoutGuide);
    NSDictionary *metricsDictionary = @{@"margin": @([BLUCurrentTheme leftMargin] * 4)};

    [superview addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:
      @"V:[topLayoutGuide]-(0)-[_titleTextFieldContainer]"
      options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [_titleTextFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
    }];
    
    [_solidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superview);
        make.top.equalTo(_titleTextFieldContainer.mas_bottom);
        make.height.equalTo(@(BLUThemeOnePixelHeight));
    }];
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_solidLine.mas_bottom);
        make.left.right.equalTo(superview);
        make.height.equalTo(@(kTextViewHeight));
    }];

    [_anonymousToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview);
        make.right.equalTo(superview);
        make.bottom.equalTo(superview);
    }];
    
    // Model
    RAC(self, sendPostViewModel.title) = self.titleTextFieldContainer.textField.rac_textSignal;
    RAC(self, sendPostViewModel.content) = [self.contentTextView.rac_textSignal filter:^BOOL(NSString *content) {
        if ([content isEqualToString:kTextViewPlaceholder]) {
            return NO;
        } else {
            return YES;
        }
    }];
    
    self.navigationItem.rightBarButtonItem.rac_command = self.sendPostViewModel.send;
    @weakify(self);
    [[self.navigationItem.rightBarButtonItem.rac_command executionSignals] subscribeNext:^(RACSignal *send) {
        [send subscribeNext:^(id x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(didSendPost:fromSendPostViewController:)]) {
                [self.delegate didSendPost:nil fromSendPostViewController:self];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];

    [[self.navigationItem.rightBarButtonItem.rac_command errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertForError:error];
    }];

    RAC(self, sendPostViewModel.anonymousEnable) = [RACObserve(anonymousButton, selected) distinctUntilChanged];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self _updateGridViewLayout];
}

- (void)handleUserProfit:(NSNotification *)userInfo {
    BLUUserProfit *profit = userInfo.object;
    if ([profit isKindOfClass:[BLUUserProfit class]]) {
        if ([self.delegate respondsToSelector:@selector(shouldShowUserProfit:fromSendPostViewController:)]) {
            [self.delegate shouldShowUserProfit:profit fromSendPostViewController:self];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Model

- (BLUSendPostViewModel *)sendPostViewModel {
    if (_sendPostViewModel == nil) {
        _sendPostViewModel = [BLUSendPostViewModel new];
        _sendPostViewModel.circleID = self.circleID;
    }
    return _sendPostViewModel;
}

- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray new];
    }
    return _images;
}

- (void)backAction:(UIBarButtonItem *)barButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Grid view

- (void)_updateGridViewContent {
    
    [_imageGridView removeAllViews];
    
    void (^makeImageButton)() = ^() {
        [_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            if (idx >= kMaxImagesCount) {
                *stop = YES;
                return ;
            }
            
            UIButton *button = [UIButton new];
            
            button.image = image;
            button.tag = idx;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [button addTarget:self action:@selector(viewImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [_imageGridView addView:button];
        }];
    };
    
    if (_images.count < kMaxImagesCount) {
        makeImageButton();
        UIButton *addButton = [self _makeAddButton];
        [_imageGridView addView:addButton];
    } else {
        makeImageButton();
    }
}

- (void)_updateGridViewLayout {
    CGRect gridViewFrame = CGRectMake(_contentTextView.x + BLUThemeMargin * 3, _contentTextView.bottom, _contentTextView.width - BLUThemeMargin * 6, 0);
    _imageGridView.frame = gridViewFrame;
    _imageGridView.preferedMaxLayoutWidth = _imageGridView.width;
}

- (UIButton *)_makeAddButton {
    UIButton *addButton = [UIButton new];
    // TODO: image
    addButton.cornerRadius = [BLUCurrentTheme lowActivityCornerRadius];
    addButton.tintColor = BLUThemeMainColor;
    addButton.backgroundImage = [BLUCurrentTheme postAddImageIcon];
    [addButton addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    return addButton;
}

- (void)addImageAction:(UIButton *)button {

    if (objc_getClass("UIAlertController") != nil) {
        //make and use a UIAlertController
        UIAlertController *alertController = [UIAlertController new];
        alertController.title = nil;
        
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.take-photo", @"Take photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.get-from-photo-library", @"Get from photo library") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            BLUImagePickerViewController *imagePickerViewController = [[BLUImagePickerViewController alloc] initWithMaxImageCount:kMaxImagesCount - self.images.count];
            imagePickerViewController.albumContentsViewControllerDelegate = self;
            BLUNavigationController *imagePickerNavVC = [[BLUNavigationController alloc] initWithRootViewController:imagePickerViewController];
            [self presentViewController:imagePickerNavVC animated:YES completion:^{
                BLULogDebug(@"Image picker view controller presented");
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"select-and-pick-image-view-model.cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:takePhotoAction];
        [alertController addAction:photoLibraryAction];
        [alertController addAction:cancelAction];
        alertController.popoverPresentationController.sourceView = button;
        alertController.popoverPresentationController.sourceRect = button.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"select-and-pick-image-view-model.cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"select-and-pick-image-view-model.take-photo", @"Take photo"), NSLocalizedString(@"select-and-pick-image-view-model.get-from-photo-library", @"Get from photo library"), nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
}

- (void)viewImageAction:(UIButton *)button {
    BLUImageViewerViewController *vc = [[BLUImageViewerViewController new] initWithImages:self.images];
    vc.editAble = YES;
    vc.delegate = self;
    vc.presented = YES;
    BLUNavigationController *nav = [[BLUNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)anonymousAction:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kTextViewPlaceholder]) {
        textView.text = @"";
        textView.textColor = _titleTextFieldContainer.textField.textColor;
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = kTextViewPlaceholder;
        textView.textColor = BLUThemeSubTintContentForegroundColor;
    }
    [textView resignFirstResponder];
}

#pragma mark - BLU image picker album contents view controller delegate

- (void)albumContentsViewController:(BLUImagePickerAlbumContentsViewController *)viewController didFinishSelectingImages:(NSArray *)images {
    [self.images addObjectsFromArray:images];
    self.sendPostViewModel.photos = self.images;
    [self _updateGridViewContent];
    [self _updateGridViewLayout];
}

#pragma mark - Image viewer delegate

- (void)imageViewerViewController:(BLUImageViewerViewController *)viewController didEditImages:(NSArray *)images {
    [self.images removeAllObjects];
    [self.images addObjectsFromArray:images];
    [self _updateGridViewContent];
    [self _updateGridViewLayout];
}

#pragma mark UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * originalHeaderImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData * compressedHeaderImageData = UIImageJPEGRepresentation(originalHeaderImage, 0.3);
    UIImage * compressedImage = [UIImage imageWithData:compressedHeaderImageData];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.images addObject:compressedImage];
    self.sendPostViewModel.photos = self.images;
    [self _updateGridViewContent];
    [self _updateGridViewLayout];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // TODO: iOS 7
}

#pragma mark - Keyboard.

- (void)keyboardChanged:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    CGRect keyboardBeginFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    [self.anonymousToolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if (notification.name == UIKeyboardWillShowNotification) {
            make.bottom.equalTo(self.view).offset(-keyboardEndFrame.size.height);
        } else if (notification.name == UIKeyboardWillHideNotification) {
            make.bottom.equalTo(self.view);
        }
    }];

    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

@end
