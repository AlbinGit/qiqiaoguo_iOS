//
//  QGEducationMainHttpDownload.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/9.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGEducationMainHttpDownload.h"

@implementation QGEducationMainHttpDownload

- (NSString *)path {
    return QGGetChannelIndexPath;
}

- (NSString *)method
{
    return @"POST";
}


@end
