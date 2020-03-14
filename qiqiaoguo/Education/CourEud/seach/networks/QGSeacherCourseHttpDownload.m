//
//  QGSeacherCourseHttpDownload.m
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/16.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGSeacherCourseHttpDownload.h"

@implementation QGSeacherCourseHttpDownload

- (NSString *)path {
    return QGGetSeacherCoursePath;
}

- (NSString *)method
{
    return @"GET";
}

@end
