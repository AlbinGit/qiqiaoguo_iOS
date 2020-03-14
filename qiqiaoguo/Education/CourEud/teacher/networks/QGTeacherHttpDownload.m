//
//  QGTeacherHttpDownload.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGTeacherHttpDownload.h"

@implementation QGTeacherHttpDownload

- (NSString *)path {
    return QGGetTeacherIndexPath;
}

- (NSString *)method
{
    return @"POST";
}

@end
