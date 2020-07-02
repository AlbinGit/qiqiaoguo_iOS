//
//  CVDownloadProgressView.h
//  ChinaVoice
//
//  Created by 史志杰 on 2018/4/18.
//  Copyright © 2018年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressViewDelegate <NSObject>

- (void)progressViewLoadingState;//进度条加载状态（暂停 开始）

- (void)progressViewLoadingFinish;//进度条加载完毕

@end

@interface QGstudyProgressView : UIView

@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,assign)id<ProgressViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
