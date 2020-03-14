//
//  SATableView.m
//  SaleAssistant
//
//  Created by PLATOMIX  on 14-8-25.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SATableView.h"

@interface SATableView()

@property (nonatomic,strong)MJRefreshHeader *headerView;
@property (nonatomic,strong)MJRefreshFooter *footerView;
@property (nonatomic,copy)SABeginPullDown pullDown;
@property (nonatomic,copy)SABeginPullDown pullUp;
@property (nonatomic,copy)TableViewDidClick click;

@end

@implementation SATableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBaseTableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self initBaseTableView];
    }
    return self;
}

- (void)initBaseTableView {
    self.backgroundColor = CLEARCOLOR;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    self.separatorColor = PL_UTILS_COLORRGB(200, 200, 200);
}

- (void)tableViewDidClick:(TableViewDidClick)click
{
    _click = click;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_click)
    {
        _click(indexPath);
    }
}

#pragma mark Refresh Method
- (void)addRefreshHeader
{
    __weak __typeof(self)weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if(weakSelf.pullDown)
            {
                weakSelf.pullDown(weakSelf);
            }
        }];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.mj_header = header;

    //    if(!_headerView)
    //    {
    //        _headerView = [MJRefreshHeaderView header];
    //        _headerView.scrollView = self;
    //        __weak __typeof(self)weakSelf = self;
    //        _headerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    //        {
    //            if(weakSelf.pullDown)
    //            {
    //                weakSelf.pullDown(weakSelf);
    //            }
    //        };
    //    }
}

- (void)addRefreshFooter
{
    __weak __typeof(self)weakSelf = self;
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if(weakSelf.pullUp)
        {
            weakSelf.pullUp(weakSelf);
        }
    }];
    //    if(!_footerView)
    //    {
    //        _footerView = [MJRefreshFooterView footer];
    //        _footerView.scrollView = self;
    //        __weak __typeof(self)weakSelf = self;
    //        _footerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    //        {
    //            if(weakSelf.pullUp)
    //            {
    //                weakSelf.pullUp(weakSelf);
    //            }
    //        };
    //    }
}

- (void)beginPullDown:(SABeginPullDown)pullDown
{
    _pullDown = pullDown;
}

- (void)beginPullUp:(SABeginPullUp)pullUp
{
    _pullUp = pullUp;
}

// 数据到达底部
- (void)hiddenFooterView
{
    self.mj_footer.hidden = YES;
    self.contentInset = UIEdgeInsetsZero;
}

- (void)showFooterView
{
    self.mj_footer.hidden = NO;
}

// 结束刷新
- (void)endRrefresh
{
    
    [self.mj_header endRefreshing];
    
    [self.mj_footer endRefreshing];
    
}

- (void)refreshFree
{
    //    if(_headerView)
    //    {
    //        [_headerView free];
    //    }
    //    if(_footerView)
    //    {
    //        [_footerView free];
    //    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
