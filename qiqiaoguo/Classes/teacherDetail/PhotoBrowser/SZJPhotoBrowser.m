//
//  SZJPhotoBrowser.m
//  ChinaNews
//
//  Created by 史志杰 on 2020/1/20.
//  Copyright © 2020 Liufangfang. All rights reserved.
//

#import "SZJPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SZJBrowserImageView.h"
//#import "CNPhotoBrowserConfig.h"

@interface SZJPhotoBrowser()
/** indicatorView */
@property (nonatomic ,strong) UIActivityIndicatorView *indicatorView;;
@end

@implementation SZJPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
//    UIButton *_saveButton;
    BOOL _willDisappear;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageCount = 0;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    [self setupToolbars];
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupToolbars
{
        // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
//    indexLabel.bounds = CGRectMake(20, CN_SCREEN_HEIGHT-50, 50, 30);
	indexLabel.frame = CGRectMake(20,SCREEN_HEIGHT-50, 50, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }else
	{
		indexLabel.hidden = YES;
	}
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];

        // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//	[saveButton setImage:[UIImage imageNamed:@"下载2020"] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    saveButton.layer.cornerRadius = 5;
//    saveButton.clipsToBounds = YES;
	saveButton.center = CGPointMake(SCREEN_WIDTH-20-60/2, _indexLabel.center.y);
	saveButton.bounds = CGRectMake(0, 0, 60, 40);
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];

    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //
    self.indicatorView.center = self.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self.indicatorView];
    if(self.indicatorView.isAnimating){
        [self.indicatorView stopAnimating];
        [self.indicatorView startAnimating];
    }else{
        [self.indicatorView startAnimating];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"";
    }   else {
		label.text = @"成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];

    for (int i = 0; i < self.imageCount; i++) {
        SZJBrowserImageView *imageView = [[SZJBrowserImageView alloc] init];
        imageView.tag = i;

            // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];

            // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;

        [singleTap requireGestureRecognizerToFail:doubleTap];

        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }

    [self setupImageOfImageViewForIndex:self.currentImageIndex];

}

- (void)setImageCount:(NSInteger)imageCount{
    _imageCount = imageCount;
}
    // 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SZJBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    _willDisappear = YES;

    SZJBrowserImageView *currentImageView = (SZJBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    UIView *sourceView = nil;
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    }

    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];

    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = currentImageView.image;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;

    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }

    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;

    [self addSubview:tempView];

    _saveButton.hidden = YES;

    [UIView animateWithDuration:0.4 animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        [_indicatorView removeFromSuperview];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self removeFromSuperview];
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SZJBrowserImageView *imageView = (SZJBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }

    SZJBrowserImageView *view = (SZJBrowserImageView *)recognizer.view;

    [view doubleTapToZommWithScale:scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect rect = self.bounds;
    rect.size.width += 10 * 2;

    _scrollView.bounds = rect;
    _scrollView.center = self.center;

    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - 10 * 2;
    CGFloat h = _scrollView.frame.size.height;



    [_scrollView.subviews enumerateObjectsUsingBlock:^(SZJBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = 10 + idx * (10 * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];

    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);


    if (!_hasShowedFistView) {
        [self showFirstImage];
    }

//    _indexLabel.center  = CGPointMake(self.bounds.size.width * 0.5, 35);
//    _saveButton.frame   = CGRectMake(30, CN_SCREEN_HEIGHT - 55 - kBottomHeight, 70, 35);
//    _indexLabel.frame   = CGRectMake((CN_SCREEN_WIDTH - 100)/2, CN_SCREEN_HEIGHT - 55 -kBottomHeight, 100, 35);
//    _indexLabel.backgroundColor = [UIColor clearColor];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SZJBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SZJBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    UIView *sourceView = nil;

    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    }
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];

    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self addSubview:tempView];

    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];

    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;


//    [UIView animateWithDuration:CNPhotoBrowserShowImageAnimationDuration animations:^{
//        tempView.center = self.center;
//        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
//    } completion:^(BOOL finished) {
//        _hasShowedFistView = YES;
//        [tempView removeFromSuperview];
//        _scrollView.hidden = NO;
//    }];
	
	        _hasShowedFistView = YES;
	        [tempView removeFromSuperview];
	        _scrollView.hidden = NO;

}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;

        // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        SZJBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }


    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
}

- (UIActivityIndicatorView *)indicatorView{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorView.center = self.center;
    }
    return _indicatorView;
}

@end
