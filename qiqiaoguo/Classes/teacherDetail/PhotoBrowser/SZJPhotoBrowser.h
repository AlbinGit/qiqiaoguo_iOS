//
//  SZJPhotoBrowser.h
//  ChinaNews
//
//  Created by 史志杰 on 2020/1/20.
//  Copyright © 2020 Liufangfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SZJPhotoBrowser;

@protocol SZJPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SZJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SZJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface SZJPhotoBrowser : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic,strong) UIButton * saveButton;


@property (nonatomic, weak) id<SZJPhotoBrowserDelegate> delegate;

- (void)show;
@end
