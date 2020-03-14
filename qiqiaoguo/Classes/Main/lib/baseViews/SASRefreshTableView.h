//
//  SASRefreshTableView.h
//  SalesAssistant
//
//  Created by Albin on 15/5/14.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGTableView.h"

@class SASRefreshTableView;

typedef void(^SASRefreshTableViewPullDownBlock)(SASRefreshTableView *refreshTableView);
typedef void(^SASRefreshTableViewPullUpBlock)(SASRefreshTableView *refreshTableView);

@interface SASRefreshTableView : QGTableView

/*
 下拉刷新相关
 */
// 增加下拉刷新头标
- (void)addRefreshHeader:(SASRefreshTableViewPullDownBlock)pullDown;
// 增加上拉加载脚标
- (void)addRefreshFooter:(SASRefreshTableViewPullUpBlock)pullUp;
// 数据到达底部
- (void)hiddenFooterView;
- (void)showFooterView;
// 结束刷新
- (void)endRrefresh;
// 释放MJRefresh的kvo
- (void)refreshFree;
//添加回滚到顶部
-(void)addGotoTopButton;

@end
