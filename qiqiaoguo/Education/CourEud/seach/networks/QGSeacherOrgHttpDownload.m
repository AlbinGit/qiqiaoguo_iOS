//
//  QGSeacherOrgHttpDownload.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/17.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGSeacherOrgHttpDownload.h"

@implementation QGSeacherOrgHttpDownload

- (NSString *)path {
    return QGGetSeacherOrgPath;
}

- (NSString *)method
{
    return @"POST";
}

@end
