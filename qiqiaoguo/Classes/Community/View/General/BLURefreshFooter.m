//
//  BLURefreshFooter.m
//  Blue
//
//  Created by Bowen on 23/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLURefreshFooter.h"

@implementation BLURefreshFooter

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    BLURefreshFooter *footer = [super footerWithRefreshingBlock:refreshingBlock];
    footer.refreshingTitleHidden = YES;
    footer.automaticallyChangeAlpha = YES;
    footer.automaticallyHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"refresh-footer.no-more-date.title", @"No more date") forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = BLUThemeSubTintContentForegroundColor;
    return footer;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    BLURefreshFooter *footer = [super footerWithRefreshingTarget:target refreshingAction:action];
    footer.refreshingTitleHidden = YES;
    footer.automaticallyChangeAlpha = YES;
    footer.automaticallyHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"refresh-footer.no-more-date.title", @"No more date") forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = BLUThemeSubTintContentForegroundColor;
    return footer;
}

@end
