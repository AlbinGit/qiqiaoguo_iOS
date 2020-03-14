//
//  QGOrgTeacherHttpDownload.m
//  LongForTianjie
//
//  Created by Albin on 15/11/19.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGOrgTeacherHttpDownload.h"
#import "QGTeacherListModel.h"
@implementation QGOrgTeacherHttpDownload

- (NSString *)path
{
    return QGOrgTeacherPath;
}


@end
@implementation QGOrgTeacherListResultModel

+(NSDictionary *)mj_objectClassInArray {
    
    
    return @{@"items":@"QGTeacherListModel"};
}

@end