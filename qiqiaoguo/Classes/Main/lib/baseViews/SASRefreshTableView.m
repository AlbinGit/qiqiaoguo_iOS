//
//  SASRefreshTableView.m
//  SalesAssistant
//
//  Created by Albin on 15/5/14.
//  Copyright (c) 2015年 platomix. All rights reserved.
//

#import "SASRefreshTableView.h"
#import "BLURefreshFooter.h"

@interface SASRefreshTableView()
@property (nonatomic,strong)MJRefreshHeader *headerView;
@property (nonatomic,strong)MJRefreshFooter *footerView;
@property(nonatomic,strong)SAButton *gotoTopButton;
@end

@implementation SASRefreshTableView

#pragma mark Refresh Method
- (void)addRefreshHeader:(SASRefreshTableViewPullDownBlock)pullDown;
{
    //    if(!_headerView)
    //    {
    //        _headerView = [MJRefreshHeaderView header];
    //        _headerView.scrollView = self;
    //        __weak __typeof(self)weakSelf = self;
    //        _headerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    //        {
    //            if(pullDown)
    //            {
    //                pullDown(weakSelf);
    //            }
    //        };
    //    }
    __weak __typeof(self)weakSelf = self;
    MJRefreshNormalHeader *header = [BLURefreshHeader headerWithRefreshingBlock:^{
        if(pullDown)
        {
            pullDown(weakSelf);
        }
    }];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.mj_header = header;
}

- (void)addRefreshFooter:(SASRefreshTableViewPullUpBlock)pullUp
{
    __weak __typeof(self)weakSelf = self;
    self.mj_footer = [BLURefreshFooter footerWithRefreshingBlock:^{
        if(pullUp)
        {
            pullUp(weakSelf);
        }
    }];

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
    //    if(_headerView)
    //    {
    [self.mj_header endRefreshing];
    //    }
    //    if(_footerView)
    //    {
    [self.mj_footer endRefreshing];
    //    }
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
-(void)addGotoTopButton
{
    if (!_gotoTopButton)
    {
        _gotoTopButton = [[SAButton alloc] initWithFrame:CGRectMake(self.maxX - 60, self.maxY - 140, 40, 40)];
        _gotoTopButton.backgroundColor = [UIColor redColor];
        [_gotoTopButton setImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateNormal];
        PL_CODE_WEAK(weakSelf);
        [_gotoTopButton addClick:^(SAButton *button)
         {
             [weakSelf setContentOffset:CGPointZero animated:YES];
         }];
        [self addSubview:_gotoTopButton];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 200)
    {
        if (self.gotoTopButton.hidden) {
            self.gotoTopButton.hidden = NO;
            self.gotoTopButton.alpha = 0;
            [UIView animateWithDuration:0.5f animations:^{
                self.gotoTopButton.alpha = 1;
            }];
        }
    }
    else
    {
        if (!self.gotoTopButton.hidden) {
            [UIView animateWithDuration:0.5f animations:^{
                self.gotoTopButton.alpha = 0;
            } completion:^(BOOL finished) {
                self.gotoTopButton.hidden = YES;
            }];
        }
    }
}


@end
