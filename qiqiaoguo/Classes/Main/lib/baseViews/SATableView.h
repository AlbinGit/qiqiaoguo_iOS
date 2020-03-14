//
//  SATableView.h
//  SaleAssistant
//
//  Created by PLATOMIX  on 14-8-25.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "SASRefreshTableView.h"

@class SATableView;
typedef void(^TableViewDidClick)(NSIndexPath *indexPath);
// 初始化用
typedef void(^SABeginPullDown)(SATableView *refreshTableView);
typedef void(^SABeginPullUp)(SATableView *refreshTableView);

@interface SATableView :SASRefreshTableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataArray;
/*
 下拉刷新相关
 */
// 增加下拉刷新头标
- (void)addRefreshHeader;
// 增加上拉加载脚标
- (void)addRefreshFooter;
// 下拉
- (void)beginPullDown:(SABeginPullDown)pullDown;
// 上拉
- (void)beginPullUp:(SABeginPullUp)pullUp;
// 数据到达底部
- (void)hiddenFooterView;
- (void)showFooterView;
// 结束刷新
- (void)endRrefresh;
// 释放MJRefresh的kvo
- (void)refreshFree;

- (void)tableViewDidClick:(TableViewDidClick)click;

@end
