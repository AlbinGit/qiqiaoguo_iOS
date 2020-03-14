//
//  BLURefreshHeader.m
//  Blue
//
//  Created by Bowen on 23/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLURefreshHeader.h"

@implementation BLURefreshHeader


+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    BLURefreshHeader *header = [super headerWithRefreshingBlock:refreshingBlock];
    [BLURefreshHeader _configHeader:header];
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    BLURefreshHeader *header = [super headerWithRefreshingTarget:target refreshingAction:action];
    [BLURefreshHeader _configHeader:header];
    return header;
}

+ (void)_configHeader:(BLURefreshHeader *)header {
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = QGTitleColor;
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    header.automaticallyChangeAlpha = YES;
}

@end
